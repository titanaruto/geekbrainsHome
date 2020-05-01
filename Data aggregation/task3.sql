# Подсчитайте произведение чисел в столбце таблицы
# CREATE TABLE values_tmp(
#   value VARCHAR(255)
# );
#
# INSERT INTO values_tmp (value) VALUES
# (1),
# (2),
# (3),
# (4),
# (5);

select round(exp(SUM(log(value)))) from values_tmp