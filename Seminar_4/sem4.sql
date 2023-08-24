USE seminar_4;
/*Станислав Никуличев
Задача 1: выбрать всех пользователей, указав их id, имя и фамилию, город и аватарку
(используя вложенные запросы)*/
SELECT id, firstname, lastname, (SELECT  hometown FROM profiles WHERE users.id=profiles.user_id) as hometown,
(SELECT  photo_id FROM profiles WHERE users.id=profiles.user_id) as photo_id
FROM users;

/*Задача 2: выбрать фотографии (filename) пользователя с email: arlo50@example.org.
ID типа медиа, соответствующий фотографиям неизвестен
 (используя вложенные запросы)*/
 
 SELECT filename, user_id 
 FROM media
 WHERE media.user_id  = (SELECT users.id FROM users WHERE email = 'arlo50@example.org') 
 AND media_type_id = (SELECT id FROM media_types WHERE name_type = 'Photo')
 ;
 
 /*Задача 3: выбрать id друзей пользователя с id = 1
 (используя UNION)*/
 SELECT initiator_user_id
 FROM friend_requests
 WHERE target_user_id=1 
 AND status = 'approved'
 UNION
 SELECT target_user_id
 FROM friend_requests
 WHERE initiator_user_id=1 
 AND status = 'approved';
 
 
 /*Задача 4: выбрать всех пользователей, указав их id, имя и фамилию, город и аватарку
(используя JOIN)*/
SELECT id, firstname, lastname, hometown, photo_id 
FROM users
LEFT JOIN profiles ON users.id = profiles.user_id;

/*Задача 5: Список медиафайлов пользователей с количеством лайков (используя JOIN)*/
SELECT firstname, lastname, filename, COUNT(likes.media_id) FROM media
JOIN users ON media.user_id = users.id
JOIN likes ON likes.media_id = media.id
GROUP BY likes.media_id;

/*Задача 6: Список медиафайлов пользователей, указав название типа медиа (id, filename, name_type)
(используя JOIN)*/

SELECT filename, firstname, lastname, name_type
FROM users
JOIN media 
ON users.id = media.user_id
JOIN media_types
ON media.media_type_id = media_types.id;

/*ДЗ 
Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.

Определить кто больше поставил лайков (всего): мужчины или женщины. 

Вывести всех пользователей, которые не отправляли сообщения.

(по желанию)* Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех написал ему сообщений.

11:50

*/

 
 