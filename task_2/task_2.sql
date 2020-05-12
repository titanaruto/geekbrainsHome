# 2.  поставил лайков (всего) - мужчины или женщины?Определить кто больше
SELECT gender, COUNT(likes.id) as count_gender
FROM profiles
       LEFT JOIN likes ON profiles.user_id = likes.user_id
GROUP BY gender
ORDER BY count_gender DESC
LIMIT 1;