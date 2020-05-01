# (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
  # SELECT * FROM catalogs WHERE id IN (5, 1, 2);
  # Отсортируйте записи в порядке, заданном в списке IN.

# DROP TABLE IF EXISTS catalogs;
# CREATE TABLE catalogs (
#                         id SERIAL PRIMARY KEY,
#                         name VARCHAR(255) COMMENT 'Название раздела',
#                         UNIQUE unique_name(name(10))
# ) COMMENT = 'Разделы интернет-магазина';
#
# INSERT INTO catalogs VALUES
# (1, 'Процессоры'),
# (2, 'Материнские платы'),
# (5, 'Видеокарты'),
# (3, 'Жесткие диски'),
# (4, 'Оперативная память');

SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by id = 5 desc , id = 1 desc , id = 2 asc;