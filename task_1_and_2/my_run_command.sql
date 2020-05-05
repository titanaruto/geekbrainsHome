DROP TABLE IF EXISTS likes;
CREATE TABLE likes
(
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id        INT UNSIGNED NOT NULL,
  target_id      INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at     DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types
(
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name)
VALUES ('messages'),
       ('users'),
       ('media'),
       ('posts');

-- Заполняем лайки
INSERT INTO likes
SELECT id,
       FLOOR(1 + (RAND() * 100)),
       FLOOR(1 + (RAND() * 100)),
       FLOOR(1 + (RAND() * 4)),
       CURRENT_TIMESTAMP
FROM messages;

-- Проверим
SELECT *
FROM likes
LIMIT 10;


-- Добавляем внешние ключи в БД vk
-- Для таблицы профилей

-- Смотрим структуру таблицы
DESC profiles;

-- Добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users (id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media (id)
      ON DELETE SET NULL;

-- Изменяем тип столбца при необходимости
ALTER TABLE profiles
  DROP FOREIGN KEY profiles_user_id_fk;
ALTER TABLE profiles
  MODIFY COLUMN photo_id INT(10) UNSIGNED;

DESC messages;

-- Случайным образом очистим часть community_id
UPDATE messages
SET community_id = NULL
WHERE community_id > FLOOR(1 + RAND() * 20);

-- При выполнения этой команды получил ошибку
-- Cannot add or update a child row: a foreign key constraint fails
-- (`vk`.`#sql-356_2a`, CONSTRAINT `messages_from_user_id_fk` FOREIGN KEY
-- (`from_user_id`) REFERENCES `users` (`id`))
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk
    FOREIGN KEY (from_user_id) REFERENCES users (id),
  ADD CONSTRAINT messages_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users (id);

-- Понял что Messages from_user_id Больше 100 есть айдишники а их нету.
-- по-этому нужно обновить данные from_user_id and to_user_id от 1 до 100

UPDATE messages
SET from_user_id = FLOOR(1 + RAND() * 100);
UPDATE messages
SET to_user_id = FLOOR(1 + RAND() * 100);

SELECT *
FROM messages;

-- После, все коректно отработало
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk
    FOREIGN KEY (from_user_id) REFERENCES users (id),
  ADD CONSTRAINT messages_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users (id);

-- Случайным образом очистим часть to_user_id
UPDATE messages
SET to_user_id = NULL
WHERE to_user_id > FLOOR(1 + RAND() * 100)
  AND community_id IS not NULL;

-- Заменим группы на корректные для отправителя сообщения
UPDATE messages
SET community_id =
      (SELECT community_id
       FROM communities_users
       WHERE communities_users.user_id = messages.from_user_id
       ORDER BY RAND()
       LIMIT 1)
WHERE community_id IS NOT NULL;

-- Заменим получателя на пользователя из той-же группы что и отправитель
UPDATE messages
SET to_user_id =
      (SELECT user_id
       FROM communities_users
       WHERE communities_users.community_id = messages.community_id
       ORDER BY RAND()
       LIMIT 1)
WHERE community_id IS NOT NULL;


SELECT *
FROM friendship;

UPDATE friendship
SET user_id = FLOOR(1 + RAND() * 100);
UPDATE friendship
SET friend_id = FLOOR(1 + RAND() * 100);

ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users (id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_friend_id_fk
    FOREIGN KEY (friend_id) REFERENCES users (id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_status_id_fk
    FOREIGN KEY (status_id) REFERENCES friendship_statuses (id);


ALTER TABLE messages
  ADD CONSTRAINT messages_from_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities (id);

SELECT *
FROM media;

UPDATE media
SET user_id = FLOOR(1 + RAND() * 100);

ALTER TABLE media
  ADD CONSTRAINT media_from_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users (id),
  ADD CONSTRAINT media_from_media_type_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types (id);

SELECT *
FROM communities_users;

ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities (id),
  ADD CONSTRAINT communities_users_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users (id);

SELECT *
FROM likes;

ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users (id),
  ADD CONSTRAINT likes_target_id_fk
    FOREIGN KEY (target_id) REFERENCES users (id),
  ADD CONSTRAINT likes_target_type_id_fk
    FOREIGN KEY (target_type_id) REFERENCES target_types (id);

DROP TABLE IF EXISTS posts;
CREATE TABLE posts
(
  id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id      INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head         VARCHAR(255),
  body         TEXT         NOT NULL,
  media_id     INT UNSIGNED,
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


INSERT INTO `posts` VALUES ('1','7','9','aut','Qui id facilis molestiae modi. Sed mollitia atque repellat et et. Asperiores dolor quia suscipit dignissimos aspernatur rerum.','8','1983-05-30 05:07:51','2003-10-04 02:22:10'),
                           ('2','9','7','temporibus','Totam molestias nam provident repellat earum. Ea libero praesentium rerum itaque perferendis velit. Officia suscipit rem atque voluptas.','1','1999-11-08 19:31:52','2013-05-24 21:07:00'),
                           ('3','5','9','sed','Dolorem fugit impedit dolorem ipsa. Voluptate autem repudiandae harum aperiam facere omnis. Rerum nostrum dolorem dolor ut vitae. Sint quia assumenda nisi facere assumenda.','1','2012-12-03 18:23:56','1976-12-08 14:02:11'),
                           ('4','5','8','non','Corporis magni eveniet cupiditate quam omnis. Fugiat odio ex debitis. Qui ratione consequatur corporis illum sint esse. Laudantium qui sit tenetur at earum aut eum natus.','3','1975-09-06 09:20:08','2008-09-06 19:00:35'),
                           ('5','1','9','quos','Est tempora autem maxime quod reiciendis ipsa id. Aperiam esse eaque et neque ipsa id ea. Dolorum a adipisci doloremque repudiandae at fuga. Autem accusantium eaque nemo et iure. Quia tenetur impedit cupiditate sunt necessitatibus magnam.','6','2003-09-28 04:21:54','1996-11-15 07:08:14'),
                           ('6','4','7','provident','Rerum et blanditiis officiis deserunt blanditiis iusto aspernatur. Earum ducimus voluptatum quis. Delectus unde corrupti eos id ea.','7','1971-08-31 20:19:08','1977-11-19 05:53:45'),
                           ('7','5','6','natus','Molestias fugiat quo dignissimos molestiae omnis vitae aut numquam. Quis consequatur tempora quia. Eaque dignissimos vel ut ipsam. Nobis exercitationem commodi omnis nesciunt delectus.','6','1980-06-05 01:41:41','1978-09-13 22:03:53'),
                           ('8','3','7','dolor','Accusantium sed porro dolore error impedit aut. Dolorem ea deleniti eaque magnam culpa. Nisi molestiae ut quasi sed molestias.','9','1991-06-22 17:20:00','1992-07-15 17:15:31'),
                           ('9','1','9','consequatur','Perspiciatis excepturi reiciendis sequi alias vel nobis quo. Quo sit sint sint rerum. Voluptas et minima velit pariatur id sunt.','8','1999-08-01 09:45:48','1997-06-17 22:22:39'),
                           ('10','3','5','et','Unde dolorum rem aperiam natus repellat et maxime. Perspiciatis veniam libero quo est veritatis. Eveniet reiciendis magnam necessitatibus expedita dolorem magnam. Quisquam ipsum nostrum est ea quas.','5','1997-01-08 12:01:39','1992-10-11 06:42:03'),
                           ('11','9','2','iste','Molestiae et officiis soluta quidem modi. Aut ea deserunt numquam eos quasi. Est saepe et impedit sed aliquam.','6','1974-02-19 15:22:49','2010-04-24 05:18:59'),
                           ('12','1','1','tempore','Accusantium ex voluptatem consequatur hic est atque molestiae. Unde quia asperiores voluptas quo deserunt. Dolor corrupti ab voluptate illo vel est impedit. Quia et in autem cum dolores et tempore.','5','2009-07-29 11:33:55','1998-07-28 06:01:21'),
                           ('13','9','8','deleniti','Alias est culpa nihil facilis vel aut reprehenderit quibusdam. Sit vel dolore aut consequuntur voluptatem. Qui aut quae ab exercitationem provident.','2','1987-04-21 19:48:22','1987-04-21 17:54:42'),
                           ('14','2','9','qui','Necessitatibus aut voluptas quae aut asperiores. Eius voluptatem nesciunt corrupti fugit voluptatibus aperiam. Consequuntur ea officiis in soluta aut hic. Magnam error voluptate sunt aliquam in deserunt optio.','3','1979-01-24 06:40:24','2008-10-08 15:21:18'),
                           ('15','7','2','ut','Iusto repudiandae dolor necessitatibus. Voluptatem inventore molestiae aliquam error dignissimos vero nam. Quia quam sapiente ducimus eum. Quibusdam est occaecati quasi vel officiis laborum et.','9','1976-10-18 00:45:14','2000-01-17 07:06:47'),
                           ('16','5','4','nostrum','Adipisci nostrum maiores vel in quo. Fugit debitis consectetur nam sed rerum excepturi id. Debitis animi voluptate rerum. Aspernatur necessitatibus quidem voluptatem.','4','1988-10-20 11:36:46','1999-12-22 18:15:31'),
                           ('17','2','1','necessitatibus','Recusandae tenetur veniam sed est. Est iure aut molestiae dolorem sequi. Sed omnis et quos quia deleniti dolorum aut. Eligendi laudantium quis ipsam labore libero atque laboriosam.','4','1970-12-30 17:26:20','1984-10-22 10:45:42'),
                           ('18','6','9','minima','Rerum sed et possimus beatae. Et totam accusamus aut omnis qui tempora est libero. Facere cupiditate recusandae impedit cupiditate voluptatem consequuntur soluta.','5','2016-06-15 14:26:51','2002-06-21 05:01:41'),
                           ('19','9','1','molestiae','A alias omnis earum voluptatem consequatur tenetur odio. Illo nobis quis voluptatem vel numquam. Laboriosam dignissimos perferendis ut.','8','2016-08-21 01:28:43','1981-07-11 17:41:20'),
                           ('20','3','5','autem','Quaerat impedit eum nesciunt est incidunt et. Ipsum ea omnis repellendus quis error. A reiciendis voluptatibus animi fugiat ut minima et.','9','2012-02-11 11:28:04','1977-05-28 07:37:47'),
                           ('21','9','5','dolores','Harum et facilis inventore veritatis molestiae illum nobis. Consequuntur quia reprehenderit vero aut sint. Eos expedita tenetur velit voluptatem facilis optio. Modi consequatur vel earum animi animi quisquam et. Eius aut asperiores qui dolore.','1','1994-06-11 19:23:25','2013-05-14 13:10:17'),
                           ('22','5','7','quaerat','Iusto rerum vel deserunt quia. Maiores natus earum aut odit expedita. Maxime quo explicabo sunt.','9','1976-03-07 00:11:08','2017-03-08 07:12:13'),
                           ('23','7','1','provident','Hic rerum nihil sunt. Hic ut dolore voluptates ut. Modi ad porro omnis rem tempore. Sint ut sint dolore eius sit.','2','1998-02-28 14:26:00','1992-11-19 17:20:52'),
                           ('24','5','3','atque','Necessitatibus veniam mollitia vitae aut hic sequi. Adipisci ducimus debitis et veritatis laudantium. Atque ea dolorem at praesentium ratione nulla reprehenderit aspernatur. Minima dignissimos consequuntur enim.','2','2017-06-11 08:36:02','2012-10-21 09:39:10'),
                           ('25','6','9','aut','Ratione asperiores id voluptatem quo. Cum ut voluptatem quae. Ipsam at dolorum nisi voluptate voluptas deserunt minima. Dolorum aperiam in nesciunt quia quam.','6','1977-11-26 22:17:42','1983-11-29 23:42:24'),
                           ('26','7','6','incidunt','Et earum debitis odio. Est at blanditiis sed et et voluptates. Aut aut minima libero eum quidem. Reiciendis rem placeat assumenda et fugiat.','8','1995-01-12 15:51:54','1991-12-05 09:36:20'),
                           ('27','6','8','molestiae','In dolor rerum consectetur eum alias. Recusandae corporis tenetur animi dolor sunt. Tenetur laboriosam architecto laudantium dolores. Modi asperiores aut architecto amet qui aliquid.','5','1979-11-09 18:35:39','2014-03-19 08:31:36'),
                           ('28','4','9','asperiores','Minus eos eveniet pariatur repellendus commodi qui ut. Odit unde quam vel et nihil. Aliquid adipisci numquam molestiae magni numquam. Est et quam eos.','1','1996-10-12 03:21:50','1978-12-30 17:22:39'),
                           ('29','1','3','et','Ad nemo autem laudantium dolorum ut. Dolor dignissimos vitae optio quae doloribus. Officia molestiae dolor consequatur voluptatem in dolor placeat. Repellendus nihil minus dolor.','9','2002-03-15 23:24:25','2009-11-07 10:46:10'),
                           ('30','3','5','sed','Qui tempora odio blanditiis fugiat esse. Quaerat sapiente blanditiis vel impedit autem et sed. Quae molestias nostrum mollitia quia architecto culpa. Aperiam itaque non aut et.','4','2019-07-05 17:14:31','2005-11-28 12:00:16'),
                           ('31','8','7','officiis','Fuga sit dolor magnam dolor. Facilis doloremque magni facilis. Harum quia ut sed ad natus explicabo itaque. Tenetur esse et enim itaque.','1','1970-12-27 00:51:12','2018-06-05 17:27:20'),
                           ('32','7','6','exercitationem','Sunt quam laudantium illum deserunt consequuntur explicabo. Natus est officia natus ut. Qui porro culpa natus non nesciunt fugiat. Et rem consequatur aut laboriosam eos id.','6','2008-06-01 09:18:18','2002-11-19 17:17:52'),
                           ('33','8','1','aut','Ducimus aut accusantium deserunt nisi. Cupiditate similique tempore et ea amet quasi nesciunt dolores. Autem laudantium exercitationem ex itaque ut aut.','9','2004-01-05 06:15:21','2005-06-11 13:01:46'),
                           ('34','7','3','necessitatibus','Dolorum hic pariatur et autem inventore corporis. Optio aut esse exercitationem porro sunt sit. Illo possimus eos aut voluptatem ab dolorem dolor. Ut harum recusandae autem ea eius aut recusandae.','8','1973-02-07 04:13:47','2012-04-23 05:35:57'),
                           ('35','9','7','et','Suscipit enim consequatur iste et quia. Autem amet nam et. Placeat tempore architecto id molestias consequatur fuga.','7','1989-10-01 10:18:26','2003-03-06 20:43:55'),
                           ('36','2','4','sit','Consequatur distinctio aut eius quia non. Aut nesciunt sit ducimus labore quis. Similique vel cumque laborum quia nisi reprehenderit consequatur omnis.','5','1972-12-15 03:04:48','2001-06-22 16:33:59'),
                           ('37','8','6','provident','Fuga aut beatae aut quisquam consectetur. Ut sequi dignissimos sit aut necessitatibus. Sunt sed vitae voluptas assumenda recusandae ut. Voluptatem voluptatem autem id doloribus quae maiores.','5','2012-06-16 13:55:16','2000-02-05 21:20:24'),
                           ('38','3','6','rerum','Veniam ipsam debitis sequi totam perspiciatis. Est recusandae sed voluptas saepe. Blanditiis quos nihil natus adipisci.','6','1978-03-08 13:28:41','2018-10-12 20:40:36'),
                           ('39','8','6','animi','Qui enim aperiam vel temporibus. Minus tenetur ipsam numquam ipsum velit beatae. Quasi ipsa et consequuntur recusandae qui nesciunt voluptatem.','7','1992-06-16 13:50:29','1972-12-17 19:33:52'),
                           ('40','2','7','sit','Sit saepe assumenda quis sed quo quia. Velit blanditiis quidem commodi ab corporis. Qui enim ducimus nulla id odio ab deleniti.','8','1975-01-17 18:51:30','1989-08-14 21:46:19'),
                           ('41','9','5','iste','Autem laudantium alias delectus consequuntur. Cumque est mollitia est et eaque illo. Ut mollitia vel aliquid asperiores quia in qui nihil. Occaecati eum tenetur omnis consequatur.','6','2000-02-05 23:19:28','1990-10-10 04:47:27'),
                           ('42','3','4','hic','Maiores quia et architecto quas iste. Minima laborum magni dolor mollitia eum doloribus.','6','1975-05-05 20:06:57','2009-06-20 21:20:01'),
                           ('43','7','5','maiores','Voluptate explicabo eveniet in aliquid voluptatem. Nihil consequatur voluptas consequatur dolore reprehenderit qui.','3','2002-03-25 20:33:32','2019-10-19 21:49:24'),
                           ('44','2','1','numquam','Vero dolores in rerum culpa. Et occaecati necessitatibus consequuntur vel. Odio ut aperiam qui aperiam unde.','7','2008-02-15 15:44:21','2012-11-21 09:49:38'),
                           ('45','1','4','unde','Deleniti qui accusamus corrupti omnis ea id. Vitae vero omnis amet dolorem exercitationem. Officiis quibusdam sint omnis et.','1','1998-02-08 22:00:15','2008-01-20 03:11:01'),
                           ('46','9','6','asperiores','Id perspiciatis neque quo molestiae eum. Quaerat rerum officia dolores. Est et minima in. Voluptatum facere voluptatem vel sapiente doloribus culpa.','1','2008-08-07 16:24:48','2014-12-08 12:10:47'),
                           ('47','5','2','libero','Deserunt sint incidunt nemo quia facilis ullam. Labore architecto optio mollitia ut et impedit. Ut sequi dolor quod consectetur reiciendis fuga. Suscipit qui at aspernatur sapiente voluptatem natus. Sunt sit veritatis eum ex expedita iste non modi.','4','2016-08-23 01:08:21','1987-04-28 20:01:18'),
                           ('48','6','7','in','Nulla fugiat est mollitia. Enim ut ut tempore numquam. Magnam sint occaecati natus facere qui qui assumenda.','9','2009-11-14 22:16:28','1972-12-23 11:32:26'),
                           ('49','7','6','eum','Dolore ab ipsa itaque ut. Architecto atque facilis minima voluptatem consequatur non facilis.','6','2011-09-13 23:42:36','1986-09-15 17:03:13'),
                           ('50','3','2','accusamus','Explicabo possimus sequi id eum cum occaecati. Nesciunt ex possimus non iusto et. Veritatis dolorem quo minima.','4','2014-04-12 16:49:43','2001-08-22 04:48:13'),
                           ('51','1','3','rem','Aliquam odio dolor nemo non eos non provident. Nobis tempora ipsa dolores quis iusto. Aut maxime nostrum adipisci dolorem. Itaque exercitationem maiores sit et rem consectetur et.','6','2010-09-18 22:51:56','1972-04-12 22:32:41'),
                           ('52','5','4','dolorem','Illum enim id consequatur aut voluptatem et. Occaecati non consequatur reiciendis eum. Est facilis enim quis ut dignissimos aut quis.','2','2006-09-18 07:18:33','2001-07-03 05:18:42'),
                           ('53','8','5','autem','Consequatur sunt aliquam incidunt. Autem quia distinctio ut error quidem modi qui. Veritatis recusandae voluptatem a illo dolore dolor. Rem dolores fuga deleniti et provident repellendus.','9','2020-04-19 19:37:23','1971-07-16 16:20:17'),
                           ('54','4','7','omnis','Ipsam totam fuga nesciunt soluta et officiis vel. Eos officiis dolore labore reiciendis occaecati sint tenetur occaecati. Nisi dolore alias et quam. Qui velit sapiente aut saepe explicabo deserunt eos.','8','2000-03-30 02:51:44','1996-03-28 10:09:22'),
                           ('55','8','3','sed','Labore similique odio delectus provident voluptatibus. Repudiandae nisi sit eum et. Et dolorum sunt modi. Aut ratione accusamus aut sed quis vero.','3','2010-04-15 18:38:07','1978-09-18 09:17:54'),
                           ('56','9','6','sed','Sit in alias ex totam temporibus. Aspernatur maiores sunt voluptatem earum. Voluptatem quisquam qui est eveniet sit non deleniti. Aut repudiandae nam reprehenderit ut aspernatur consequatur corporis.','6','2001-02-21 23:22:15','1995-06-11 01:56:01'),
                           ('57','8','7','qui','Accusamus et possimus ratione sed nihil nesciunt molestias. Itaque voluptatem aut praesentium error accusamus. Est architecto et et distinctio.','5','1978-04-26 12:14:20','2011-07-16 14:31:17'),
                           ('58','7','8','non','Et id doloribus voluptas error culpa ut voluptate. Autem omnis porro ea nihil qui rerum alias. Mollitia et fugiat praesentium qui officiis cupiditate molestiae. Sint earum aut error. Et ut suscipit enim qui quas.','6','2015-12-25 11:21:21','1983-06-14 17:22:48'),
                           ('59','1','6','at','Voluptatibus placeat est vitae quo omnis itaque facilis quasi. Omnis recusandae eos dignissimos sit. Ipsum dicta id qui repudiandae consequuntur.','6','2007-02-25 12:33:54','2013-12-23 07:25:49'),
                           ('60','9','5','qui','Hic aut ex assumenda autem voluptas placeat aperiam laborum. Alias nesciunt enim voluptatem molestias non dolores asperiores. Voluptatem excepturi nam quidem at velit.','3','1986-02-07 09:17:26','2001-03-26 23:18:51'),
                           ('61','8','4','temporibus','Quod et sapiente sit. At vel totam a voluptatem. Qui porro eos non cupiditate voluptas. Praesentium qui qui amet in.','3','1989-01-16 00:26:28','1981-09-26 15:24:57'),
                           ('62','7','1','est','Non eos qui ut qui porro. Molestiae veniam et quis et corporis enim dolorem. Consectetur consequatur cupiditate esse iusto quod est. Ipsa rerum voluptas libero sit fugit omnis eligendi.','8','1999-01-07 18:52:32','1997-02-06 08:13:54'),
                           ('63','5','7','rem','Nobis repellat aliquid aspernatur accusantium labore. Perspiciatis soluta voluptas non cum dolor eius aspernatur. Rem sed ea dignissimos occaecati.','9','1998-08-16 09:38:44','2010-01-16 11:59:29'),
                           ('64','4','2','officia','Dolor voluptatem praesentium doloremque ratione dolor. Harum et et natus et provident ipsum id. Natus dolorum et tempore sit ad porro repellat. A nulla itaque et est sit.','3','1992-05-18 00:25:29','1993-04-16 03:15:37'),
                           ('65','7','1','sint','Explicabo est praesentium quas rem eligendi velit vel. Dolores repellendus vel recusandae nesciunt. Sit non et at quia dolores occaecati inventore.','8','1987-03-03 05:15:36','1983-11-08 23:30:39'),
                           ('66','9','4','sunt','Cumque molestiae quas ad explicabo esse officiis architecto. Labore non qui dicta sit laboriosam vel nobis. Repellendus mollitia eos magni sed libero nihil eveniet.','2','2020-03-03 07:25:13','2007-03-22 09:24:55'),
                           ('67','4','6','modi','Magni deleniti eligendi molestiae. Dolorem est adipisci commodi ducimus est corrupti. Illum ea a provident atque rerum dolorem vitae doloribus. Ut aliquid eum nisi itaque voluptas perferendis cum autem.','2','1994-09-24 13:52:11','2019-05-18 00:21:00'),
                           ('68','3','8','nam','Nihil qui quas necessitatibus doloribus et. Eos et sunt dolores fugiat. Est ea qui provident ut.','4','1974-06-14 12:53:11','1975-03-17 01:46:57'),
                           ('69','7','8','blanditiis','Tempora quos modi est iure animi. Porro quos consequuntur officiis quo error eum. Ex ut maxime sit consequatur.','3','2003-12-06 01:45:46','2001-10-02 19:23:20'),
                           ('70','5','7','praesentium','Quas corporis velit culpa rerum quam delectus eos. Atque non ipsum id eligendi inventore velit reiciendis quod. Quia quas earum id quis. Mollitia sapiente in harum in eveniet ut recusandae sed.','2','1993-08-02 07:33:04','2014-10-09 10:19:06'),
                           ('71','5','4','distinctio','Ut aut eveniet similique beatae quasi. Rerum sunt eum in consectetur exercitationem aut facilis.','8','2000-08-01 22:58:48','1973-04-21 05:55:34'),
                           ('72','6','2','aliquid','Doloremque dolorum facilis quas. Odit quia maiores veniam in. Sint corporis voluptate recusandae vel inventore nemo. Fuga sed quo vel aut.','7','1977-09-30 16:36:12','2019-02-02 10:45:53'),
                           ('73','6','4','veritatis','Consectetur quas quia veniam doloribus dolor ut et quasi. Quis sunt molestiae et amet. Ipsa dolores tempore architecto ipsa.','4','1987-12-29 14:36:39','1991-09-11 15:42:48'),
                           ('74','4','3','consequatur','Et aliquid porro eaque accusamus sed rerum qui. Omnis velit ex nihil inventore. Explicabo sunt qui facere magnam perspiciatis velit iure. Unde velit culpa aut ratione et non sint.','4','2019-09-10 02:17:10','1983-02-12 08:14:08'),
                           ('75','6','4','voluptas','Odit voluptates tempora sit excepturi nobis et facilis enim. Et ea magni esse ea architecto minus ut deleniti.','4','2016-02-05 22:22:53','1993-06-12 21:45:02'),
                           ('76','1','6','ad','Corrupti sapiente sapiente in maxime cumque. Id placeat consequatur non placeat. Voluptas tempora rerum laboriosam totam et. Doloribus dolor facilis sunt.','2','2014-03-15 16:41:52','2012-07-29 22:01:21'),
                           ('77','4','7','cumque','Nobis porro perferendis aliquid nostrum culpa vel et. Unde numquam dolorem eum iure et dicta atque. Sed molestiae similique ducimus.','3','2005-04-28 13:01:30','2011-06-02 03:22:06'),
                           ('78','7','3','id','Asperiores enim saepe minus soluta iste fugiat recusandae. Vero et necessitatibus aliquid qui consectetur ad omnis. Consequatur incidunt et cum et aut rem animi blanditiis. In laboriosam repellat ut sint laudantium blanditiis.','4','2005-08-13 02:56:23','2018-01-14 16:26:37'),
                           ('79','7','2','qui','Quis deleniti consequatur deserunt sint voluptas. Reprehenderit nam quo quisquam ea. Autem eos dolorum aperiam odio omnis ea.','9','1977-01-28 15:16:25','2011-12-23 07:48:42'),
                           ('80','1','4','hic','Impedit nemo reiciendis libero natus aut maiores atque officiis. Fugit velit enim perferendis tempore. Minus animi eum vel temporibus quod. Molestias tempore voluptatibus cupiditate quas magnam. Aut corporis voluptas et eligendi officia minima expedita omnis.','2','1994-04-03 10:51:11','1989-08-24 22:08:50'),
                           ('81','7','8','itaque','Minima ex dolores dolor molestiae nisi explicabo laborum. Nobis sit dolores ex corporis aliquid nihil. Et aut laboriosam ad officia enim ut. Distinctio voluptatum eos voluptas deleniti et velit magni eligendi.','2','1994-09-19 11:36:51','2003-12-30 07:53:31'),
                           ('82','8','1','earum','Fugiat consequatur aut consequuntur et. Quaerat omnis libero rem ab in autem. Voluptates distinctio facilis ea blanditiis repellat vel. Sint et dolorum rerum dolores modi.','8','1989-04-27 10:40:30','2009-11-09 01:06:41'),
                           ('83','2','5','cupiditate','Dignissimos velit fugiat voluptate nemo. Libero voluptates aut ut. Ea sit harum similique.','5','2016-07-12 17:02:02','1981-12-25 17:51:43'),
                           ('84','6','7','sed','Ut deleniti eveniet sit sed pariatur ex. Laboriosam excepturi eligendi eum. Culpa nemo nostrum non et asperiores molestiae. Ipsum provident occaecati id ipsam vitae animi rerum.','9','1980-04-17 22:08:10','1982-10-02 04:20:08'),
                           ('85','4','5','praesentium','Officiis ab sit praesentium a quasi provident. Et minima voluptas consequatur et. Totam sint quisquam modi iusto ut aut enim fugiat.','7','1990-03-29 14:01:14','1995-11-21 09:51:08'),
                           ('86','4','5','asperiores','Praesentium et eum maiores corrupti beatae. Autem exercitationem laboriosam est rem aut quas. Id tempore autem rerum numquam. Voluptate perferendis tenetur tempora porro sed et sequi. Id voluptatem error eos omnis voluptatem autem.','3','2006-06-17 18:59:36','2009-06-05 06:31:19'),
                           ('87','7','7','delectus','Enim et veniam consequatur magni aut inventore. Dignissimos consequatur quo ut iste. Sed ab maiores sunt labore exercitationem possimus.','3','2016-07-02 22:57:32','1996-07-16 14:48:30'),
                           ('88','4','1','quam','Sapiente nulla nesciunt necessitatibus ex. Dolor officia laboriosam illum. Molestiae quia aut possimus quod.','4','2018-12-23 11:38:34','1982-03-04 19:29:07'),
                           ('89','7','7','incidunt','Sed quasi commodi ut illum placeat exercitationem quo dolorem. Soluta unde cupiditate atque. Ullam quis expedita et excepturi provident nulla unde.','3','1992-03-07 16:01:25','2014-07-24 01:39:27'),
                           ('90','5','6','maxime','Accusantium error quo esse officiis reiciendis vel minus. Harum fuga asperiores pariatur consequatur molestias. Non expedita ipsa tempora et consequatur. Sit sit at minima.','5','2008-02-15 18:41:19','2015-03-15 08:42:57'),
                           ('91','9','3','eaque','Mollitia est iusto in est sequi molestias cum. Provident sit cupiditate hic neque occaecati neque. Ab inventore commodi aperiam laudantium aspernatur inventore. Excepturi voluptatum laboriosam vel neque.','6','2005-12-27 13:59:59','1985-03-13 21:46:47'),
                           ('92','7','5','eius','Numquam autem deserunt ut sed. Voluptas ratione eligendi tenetur ut est facilis amet explicabo. Magni quia odio quisquam quae enim laudantium. Qui aut in itaque laboriosam aut.','1','1984-09-23 15:08:10','2018-02-06 19:57:50'),
                           ('93','2','9','pariatur','Recusandae quibusdam autem maxime vero sint. Aliquid eligendi nesciunt ducimus eligendi inventore. Sunt sit numquam architecto ad amet quidem. Eos maxime quia suscipit ea.','7','2014-09-16 11:00:37','1984-06-06 17:32:57'),
                           ('94','1','8','voluptas','Ab perferendis cupiditate cumque voluptatem enim impedit accusamus modi. Quidem laboriosam perspiciatis quibusdam aut sequi hic non ut. Est quia natus dolore aliquid.','5','2002-10-22 01:30:11','1988-07-16 06:08:07'),
                           ('95','5','3','voluptatem','Sunt doloribus expedita enim saepe quos. Odit autem qui harum expedita. Nihil magni similique dolorum et officiis quasi rerum. Et porro molestiae velit ullam non labore.','7','2008-12-26 16:42:31','1976-06-03 07:05:32'),
                           ('96','1','9','facilis','Et enim et velit saepe est sint. Odio qui veniam ipsum omnis placeat voluptatem. Explicabo voluptate sit at mollitia numquam.','3','2012-04-29 15:22:05','1982-11-22 23:34:38'),
                           ('97','7','2','harum','Nobis consequatur deleniti nulla ea sequi aliquid. Qui officiis autem ullam non. Iure ut non esse qui nihil exercitationem itaque quisquam. Placeat temporibus et sit ut quia quidem sint excepturi.','4','1973-11-17 15:17:05','2004-05-03 21:24:34'),
                           ('98','9','6','quod','Consequuntur fugiat sint magnam. Quia assumenda molestiae provident maxime iure blanditiis. Quos et eligendi voluptatibus quam.','2','1991-10-30 20:19:57','2006-08-29 18:55:07'),
                           ('99','7','3','fuga','Aut et dignissimos ab omnis esse. Saepe atque qui voluptate assumenda architecto.','3','1992-11-21 23:39:43','2010-07-09 06:50:14'),
                           ('100','8','6','et','Officiis aliquid iste odit sit temporibus. Qui distinctio voluptates laudantium. Eaque veritatis omnis laborum et placeat. A omnis praesentium quod suscipit et minima aut.','5','2000-07-11 02:59:09','2005-07-17 10:45:19');

UPDATE posts
SET user_id = FLOOR(1 + RAND() * 100);
UPDATE posts
SET community_id =
      (SELECT community_id
       FROM communities_users
       WHERE communities_users.user_id = posts.user_id
       ORDER BY RAND()
       LIMIT 1)
WHERE community_id IS NOT NULL;