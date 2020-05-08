# 3. (по желанию) Пусть имеется таблица рейсов flights
  # (id, from, to) и таблица городов cities (label, name).
  # Поля from, to и label содержат английские названия городов, поле name — русское.
  # Выведите список рейсов flights с русскими названиями городов.
DROP TABLE IF EXISTS flights;
create table flights
(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  from_city       VARCHAR(255) NOT NULL,
  to_city      VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS cities;
create table cities
(
  label       VARCHAR(255) NOT NULL,
  name      VARCHAR(255) NOT NULL
);

INSERT INTO flights (`from_city`, `to_city`)
  VALUES ('moscov', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscov'),
  ('moscov', 'kazan'),
  ('omsk', 'irkutsk');

INSERT INTO cities (`label`, `name`)
  VALUES ('moscov', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');

SELECT f.id,
       c.name as "from",
       c2.name as "to"

FROM flights AS f
       JOIN cities AS c
            ON f.from_city = c.label
       JOIN cities AS c2
            ON f.to_city = c2.label

ORDER BY f.id;
