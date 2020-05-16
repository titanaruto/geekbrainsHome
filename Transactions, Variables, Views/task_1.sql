# В базе данных shop и sample присутствуют одни и те же таблицы,
  # учебной базы данных. Переместите запись id = 1 из таблицы shop.users
  # в таблицу sample.users. Используйте транзакции.
START TRANSACTION;
SELECT @name:= name,  @birthday_at:= birthday_at,  @created_at:=created_at,
       @updated_at:= updated_at
FROM homework.users WHERE id = 1;
SELECT @name;
INSERT INTO sample.users(name, birthday_at, created_at, updated_at)
VALUES (@name, @birthday_at, @created_at, @updated_at);
SELECT * FROM sample.users;
COMMIT ;