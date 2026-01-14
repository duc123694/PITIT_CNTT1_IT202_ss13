use ss13_bai2;
select * from users;
select * from posts;
select * from likes;
drop trigger if exists trg_before_insert_likes;
drop trigger if exists trg_after_insert_likes;
drop trigger if exists trg_after_delete_likes;
drop trigger if exists trg_after_update_likes;

delimiter $$
create trigger trg_before_insert_likes
before insert on likes
for each row
begin
    declare post_owner int;
    select user_id
    into post_owner
    from posts
    where post_id = new.post_id;
    if post_owner = new.user_id then
        signal sqlstate '45000'
        set message_text = 'khong duoc like bai dang cua chinh minh';
    end if;
end$$
delimiter ;

delimiter $$
-- 3.2 after insert: tăng like_count
create trigger trg_after_insert_likes
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end$$
delimiter ;

delimiter $$
-- giảm like_count
create trigger trg_after_delete_likes after delete on likes for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end$$
delimiter ;

delimiter $$
-- đổi like sang post khác
create trigger trg_after_update_likes after update on likes for each row
begin
    -- giảm like
    if old.post_id <> new.post_id then
        update posts
        set like_count = like_count - 1
        where post_id = old.post_id;

        -- tăng like
        update posts
        set like_count = like_count + 1
        where post_id = new.post_id;
    end if;
end$$
delimiter ;

-- thêm like hợp lệ
insert into likes (user_id, post_id) values (2, 1);
select post_id, like_count from posts where post_id = 1;

-- update like sang post khác
update likes set post_id = 3 where user_id = 2 and post_id = 1;
select post_id, like_count from posts where post_id in (1, 3);

-- xóa like
delete from likes where user_id = 2 and post_id = 3;

select post_id, like_count from posts where post_id = 3;

-- 5. kiểm chứng bằng select
select * from posts;

select * from user_statistics;
