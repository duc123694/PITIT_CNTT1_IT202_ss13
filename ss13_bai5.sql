create database ex5_ss13;
use ex5_ss13;
set foreign_key_checks = 0;
create table users (
	user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(50) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts(
	post_id int auto_increment primary key,
    user_id int ,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id)
);

CREATE TABLE post_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
);

create table likes(
	like_id INT PRIMARY KEY auto_increment,
    user_id INT,
    post_id INT,
    liked_at DATETIME default(current_time()),
    foreign key(user_id) references
    users(user_id),
    foreign key(post_id) references
    posts(post_id)
); 

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

INSERT INTO post_history 
(post_id, old_content, new_content, changed_at, changed_by_user_id)
VALUES
(1,
 'Hello world from Alice!',
 'Hello world from Alice! (edited)',
 '2025-01-15 10:30:00',
 1),

(2,
 'Second post by Alice',
 'Second post by Alice - updated content',
 '2025-01-16 14:00:00',
 1),

(3,
 'Bob first post',
 'Bob first post (fixed typo)',
 '2025-01-17 09:15:00',
 2),

(4,
 'Charlie sharing thoughts',
 'Charlie sharing thoughts - add hashtag #life',
 '2025-01-18 20:45:00',
 3);
delimiter //
create procedure add_user(username varchar(50), email varchar(50))
begin
	insert into users(username, email, created_at) values
    (username, email, now());
end //
create trigger trigger_before_insert
    before insert on users
    for each row
    begin
		if ((new.email not like '%@%' and new.email not like '%.%') or new.username not REGEXP '^[A-Za-z0-9]+$') 
        then
			 signal sqlstate '45000'
        set message_text = 'Data not valid';
        end if;
	end;
delimiter ;
select * from users;
