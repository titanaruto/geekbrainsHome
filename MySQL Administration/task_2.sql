# (по желанию) Пусть имеется таблица accounts содержащая
  # три столбца id, name, password,
  # содержащие первичный ключ, имя пользователя и его пароль.
  # Создайте представление username таблицы accounts,
  # предоставляющий доступ к столбца id и name.
  # Создайте пользователя user_read,
  # который бы не имел доступа к таблице accounts,
  # однако, мог бы извлекать записи из представления username.

CREATE VIEW username as SELECT id, name, password FROM accounts;
CREATE USER user_read;
GRANT SELECT ON shop.username TO user_read;


