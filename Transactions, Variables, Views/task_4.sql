# (по желанию) Пусть имеется любая таблица с календарным полем created_at.
  # Создайте запрос, который удаляет устаревшие записи из таблицы,
  # оставляя только 5 самых свежих записей.
START TRANSACTION;

CREATE VIEW user_test as SELECT id FROM homework.users ORDER BY created_at DESC limit 5;

DELETE FROM homework.users as user WHERE  id NOT IN((SELECT * FROM user_test));

SELECT * FROM homework.users;
DROP VIEW user_test;
ROLLBACK ;