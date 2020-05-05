# 3. Подсчитать общее количество лайков десяти самым
  # молодым пользователям
  # (сколько лайков получили 10 самых молодых пользователей).

SELECT ((SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = likes.target_id)) as "name",
       (SELECT (YEAR(CURRENT_DATE) - YEAR(birthday)) - /* step 1 */
               (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d'))
        FROM profiles
        WHERE user_id = likes.target_id)  as "age" ,
       COUNT(target_id) as "count_like"
FROM likes
WHERE target_type_id = (SELECT id FROM target_types WHERE name = "users")
GROUP BY target_id
ORDER BY age
LIMIT 10;
