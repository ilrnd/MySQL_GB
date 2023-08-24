USE seminar_4;

/* Подсчитать общее количество лайков, которые получили пользователи младше 12 лет. */
SELECT COUNT(likes.user_id) AS likes_under_12
FROM likes
JOIN profiles ON profiles.user_id = likes.user_id
WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) < 12;


/*Определить кто больше поставил лайков (всего): мужчины или женщины. */
SELECT gender, COUNT(likes.user_id) AS likes
FROM likes
JOIN profiles ON profiles.user_id = likes.user_id
GROUP BY gender
ORDER BY likes DESC
LIMIT 1
;

/*Вывести всех пользователей, которые не отправляли сообщения.*/
SELECT firstname, lastname
FROM users
LEFT JOIN messages ON users.id = messages.from_user_id
WHERE messages.from_user_id IS NULL;

/*Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех написал ему сообщений.*/

SELECT firstname AS friend_firstname, lastname AS friend_lastname, COUNT(body) AS send_messages_to_user_1
FROM users
JOIN messages ON users.id = messages.from_user_id
WHERE users.id = ANY(SELECT target_user_id FROM friend_requests WHERE initiator_user_id = 1 AND status = 'approved')
OR  users.id = ANY(SELECT initiator_user_id FROM friend_requests WHERE target_user_id = 1 AND status = 'approved')
GROUP BY users.id
ORDER BY send_messages_to_user_1 DESC
LIMIT 1
;


