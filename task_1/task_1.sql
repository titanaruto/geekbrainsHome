# Составьте список пользователей users,
# которые осуществили хотя бы один заказ orders в интернет магазине.
create table users_order
(
  id   int auto_increment,
  name varchar(255) null
);

INSERT INTO `vk`.`users_order` (`name`)
  VALUES ('Вася'),
  ('Петя'),
  ('Костя'),
  ('Толик');

-- auto-generated definition
create table `order_my`
(
  id      int auto_increment
    primary key,
  name    varchar(255) null,
  user_id int          not null
);



INSERT INTO `vk`.order_my (`name`, `user_id`)
  VALUES ('Товар тест 1', 1),
  ('Товар тест 2', 2),
  ('Товар тест 3', 3);

alter table order_my
  add constraint order_users_order_id_fk
    foreign key (user_id) references users_order (id);


SELECT u.name,
       o.name
FROM order_my AS u
JOIN users_order AS o
ON u.user_id = o.id;

