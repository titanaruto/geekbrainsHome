
#Пусть в таблице users поля created_at
  # и updated_at оказались незаполненными.
  # Заполните их текущими датой и временем.
# DROP TABLE IF EXISTS users_home;
# CREATE TABLE users_home (
#                      id SERIAL PRIMARY KEY,
#                      name VARCHAR(255) COMMENT 'Имя покупателя',
#                      birthday_at DATE COMMENT 'Дата рождения',
#                      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
#                      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
# ) COMMENT = 'Покупатели';
# INSERT INTO users_home (name, birthday_at) VALUES
# ('Геннадий', '1990-10-05'),
# ('Наталья', '1984-11-12'),
# ('Александр', '1985-05-20'),
# ('Сергей', '1988-02-14'),
# ('Иван', '1998-01-12'),
# ('Мария', '1992-08-29');

#Пусть в таблице users поля created_at
# и updated_at оказались незаполненными.
# Заполните их текущими датой и временем.


UPDATE users set created_at = NOW(), updated_at = NOW();

