# 2. Выведите список товаров products и разделов catalogs,
  # который соответствует товару.
DROP TABLE IF EXISTS products_my;
create table products_my
(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(255) NOT NULL,
  category_id INT UNSIGNED NOT NULL
);

INSERT INTO products_my (`name`, `category_id`)
  VALUES ('Картошка', 1),
  ('Ручка', 2),
  ('Помидоры', 1);

DROP TABLE IF EXISTS category;
create table category
(
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO category (`name`)
  VALUES ('Продукты'),
  ('Конставары');

ALTER TABLE products_my
  ADD CONSTRAINT products_my_category_id_fk
    FOREIGN KEY (category_id) REFERENCES category (id);

SELECT p.id,
       p.name,
       c.name
FROM products_my AS p
       JOIN category AS c
            ON p.category_id = c.id;

