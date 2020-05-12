# 1. Подсчитать общее количество лайков десяти самым
# молодым пользователям
# (сколько лайков получили 10 самых молодых пользователей).

SELECT SUM(total_like) as total_like_small_human
FROM (SELECT COUNT(likes.id) as total_like
      FROM profiles
             LEFT JOIN likes on profiles.user_id = likes.user_id
             LEFT JOIN target_types tt on likes.target_type_id = tt.id
      WHERE likes.target_type_id = 2
      GROUP BY profiles.user_id
      order by birthday DESC

      LIMIT 10) as count_likes_row;