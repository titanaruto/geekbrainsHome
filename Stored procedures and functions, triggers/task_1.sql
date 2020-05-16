# Создайте хранимую функцию hello(),
  # которая будет возвращать приветствие,
  # в зависимости от текущего времени суток.
  # С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
  # с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
  # с 18:00 до 00:00 — "Добрый вечер",
  # с 00:00 до 6:00 — "Доброй ночи".


# CREATE PROCEDURE hello (time_my datetime)
CREATE PROCEDURE hello ()
BEGIN
  SET @time_now := NOW();
#   SET @time_now := time_my;
  SET @time_h := TIME (DATE_FORMAT(@time_now,"%H:%i:%s"));

  IF (@time_h > TIME('06:00:00') AND @time_h < TIME('12:00:00')) THEN
    SELECT 'Доброе утро';
  ELSEIF (@time_h > TIME('12:00:00') AND @time_h < TIME('18:00:00')) THEN
    SELECT 'Добрый день';
  ELSEIF (@time_h > TIME('18:00:00') AND @time_h < TIME('00:00:00')) THEN
    SELECT 'Добрый вечер';
  ELSEIF (@time_h > TIME('00:00:00') AND @time_h < TIME('06:00:00')) THEN
    SELECT 'Доброй ночи';
  END IF;

END

CALL hello();
# CALL hello("2018-08-01 06:33:56");
DROP PROCEDURE hello;