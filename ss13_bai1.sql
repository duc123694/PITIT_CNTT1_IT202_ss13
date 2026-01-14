create database ss13_Bai1;
use ss13_Bai1;
create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

-- tạo bảng posts
create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- thêm dữ liệu mẫu vào users
insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- trigger sau khi thêm bài viết
delimiter $$
create trigger trg_after_insert_posts after insert on posts for each row
begin
    update users
    set post_count = post_count + 1
    where user_id = new.user_id;
end$$
delimiter ;

-- trigger sau khi xóa bài viết
delimiter $$
create trigger trg_after_delete_posts after delete on posts for each row
begin
    update users
    set post_count = post_count - 1
    where user_id = old.user_id;
end$$
delimiter ;

insert into posts (user_id, content, created_at) values
(1, 'hello world from alice!', '2025-01-10 10:00:00'),
(1, 'second post by alice', '2025-01-10 12:00:00'),
(2, 'bob first post', '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts', '2025-01-12 15:00:00');

-- kiểm tra bảng users
select * from users;

-- xóa một bài đăng (post_id = 2)
delete from posts where post_id = 2;

-- kiểm tra lại bảng users
select * from users;