# Подсчитайте количество дней рождения,
  # которые приходятся на каждый из дней недели.
  # Следует учесть, что необходимы дни недели текущего года,
  # а не года рождения.
# комментарий: Сложная какая-то формулировка задания.
SELECT count(*), DAYOFWEEK(birthday_at) as day, ANY_VALUE(DAYNAME(birthday_at)) as dayname FROM users_home group by day;