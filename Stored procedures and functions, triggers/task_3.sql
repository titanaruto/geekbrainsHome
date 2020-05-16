# (по желанию) Напишите хранимую функцию для вычисления произвольного
  # числа Фибоначчи.
  # Числами Фибоначчи называется последовательность в которой число
  # равно сумме двух предыдущих чисел.
  # Вызов функции FIBONACCI(10) должен возвращать число 55.


CREATE FUNCTION FIBONACCI(number INT)
  RETURNS INT DETERMINISTIC
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE first INT DEFAULT 1;
  DECLARE fib INT DEFAULT 0;
  DECLARE two INT DEFAULT 1;
  DECLARE action BOOL DEFAULT FALSE;
  WHILE i < (number-2) DO
  SET fib = first + two;
  IF action = FALSE THEN
    SET two = fib;
    SET action = TRUE;
  ELSEIF action = TRUE THEN
    SET first = fib;
    SET action = FALSE;
  end if;
  SET i = i + 1;
  END WHILE;
  RETURN fib;
END;



SELECT FIBONACCI(10);

DROP FUNCTION FIBONACCI;