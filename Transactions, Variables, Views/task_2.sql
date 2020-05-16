# 2.  Создайте представление, которое выводит название name товарной позиции
  # из таблицы products и соответствующее название
  # каталога name из таблицы catalogs.
CREATE VIEW cat AS SELECT name FROM catalogs ORDER BY name;
SELECT * FROM cat;