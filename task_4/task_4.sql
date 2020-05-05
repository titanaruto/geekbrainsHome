# 4.  поставил лайков (всего) - мужчины или женщины?Определить кто больше

SELECT if(
             COUNT(
                 (SELECT user_id
                  FROM profiles
                  WHERE user_id = likes.user_id
                    and gender = "W")
               ) >
             COUNT(
                 (SELECT user_id
                  FROM profiles
                  WHERE user_id = likes.user_id
                    and gender = "M")
               ),
             CONCAT("Больше лайков поставили женжины. всего: ",
                    COUNT((SELECT user_id
                           FROM profiles
                           WHERE user_id = likes.user_id
                             and gender = "W"))
               )
         ,
             CONCAT("Больше лайков поставили мужчины. всего: ",
                    COUNT((SELECT user_id
                           FROM profiles
                           WHERE user_id = likes.user_id
                             and gender = "m"))
               )) as "count"
FROM likes
WHERE target_type_id = (SELECT id FROM target_types WHERE name = "users");

