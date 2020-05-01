# Подсчитайте средний возраст пользователей в таблице users
SELECT FLOOR(AVG(
      (YEAR(CURRENT_DATE) - YEAR(birthday_at)) - /* step 1 */
      (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday_at, '%m%d')) /* step 2 */
  )) AS age
FROM users