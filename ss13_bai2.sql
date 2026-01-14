create database ss13_bai2;
use ss13_bai2;
create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

-- posts
create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- dữ liệu users
insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- dữ liệu posts
insert into posts (user_id, content, created_at) values
(1, 'hello world from alice', '2025-01-10 10:00:00'),
(1, 'second post by alice', '2025-01-10 12:00:00'),
(2, 'bob first post', '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts', '2025-01-12 15:00:00');
create table likes (
    like_id int auto_increment primary key,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);
-- thêm dữ liệu mẫu vào likes
insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

--  trigger cập nhật like_count trong posts

delimiter $$
create trigger trg_after_insert_likes after insert on likes for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end$$
delimiter ;

delimiter $$
create trigger trg_after_delete_likes after delete on likes for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end$$
delimiter ;
-- tạo view user_statistics
drop view if exists user_statistics;

create view user_statistics as
select u.user_id,u.username,u.post_count,ifnull(sum(p.like_count), 0) as total_likes from users u left join posts p on u.user_id = p.user_id group by u.user_id, u.username, u.post_count;

--  thêm lượt thích và kiểm chứng
insert into likes (user_id, post_id, liked_at) values (2, 4, now());

select * from posts where post_id = 4;

select * from user_statistics;

delete from likes
where user_id = 2 and post_id = 4;
select * from posts where post_id = 4;

select * from user_statistics;
