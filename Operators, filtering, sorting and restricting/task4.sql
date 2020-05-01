# (по желанию) Из таблицы users необходимо извлечь пользователей,
  # родившихся в августе и мае.
  # Месяцы заданы в виде списка английских названий ('may', 'august')
select * from users where birthday_at RLIKE "may|august";