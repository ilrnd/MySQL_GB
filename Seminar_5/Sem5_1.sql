/*Задача 3. Для базы lesson_4 решите :
создайте представление, в котором будут выводится все сообщения, в которых принимал участие пользователь с id = 1;*/

CREATE OR REPLACE VIEW view_messages
AS 
(SELECT body
FROM messages 
WHERE from_user_id = 1 OR to_user_id =1);

SELECT *
FROM view_messages;

/*найдите друзей у  друзей пользователя с id = 1 и поместите выборку в представление; 
(решение задачи с помощью CTE)
*/
WITH friends AS
	(SELECT initiator_user_id 
	FROM friend_requests 
	WHERE target_user_id = 1 
	AND status = 'approved'
	UNION
	SELECT target_user_id 
	FROM friend_requests 
	WHERE initiator_user_id = 1 
	AND status = 'approved')
SELECT * FROM friends;
    
/*найдите друзей у  друзей пользователя с id = 1 и поместите выборку в представление; 
(решение задачи с помощью CTE)*/
WITH view_friends AS
(SELECT initiator_user_id AS fid
 FROM friend_requests 
 WHERE target_user_id = 1 
 AND status = 'approved'
 UNION
 SELECT target_user_id 
 FROM friend_requests 
 WHERE initiator_user_id = 1 
 AND status = 'approved')
 

 SELECT initiator_user_id 
 FROM view_friends
 JOIN friend_requests ON target_user_id = fid
 WHERE initiator_user_id != 1 
 AND status = 'approved'
 UNION
 SELECT target_user_id 
 FROM view_friends
 JOIN friend_requests ON initiator_user_id = fid
 WHERE target_user_id != 1 
 AND status = 'approved';
 
 
 /* найдите друзей у  друзей пользователя с id = 1. 
(решение задачи с помощью представления “друзья”)*/
 CREATE OR REPLACE VIEW view_friends AS
(SELECT initiator_user_id AS fid
 FROM friend_requests 
 WHERE target_user_id = 1 
 AND status = 'approved'
 UNION
 SELECT target_user_id 
 FROM friend_requests 
 WHERE initiator_user_id = 1 
 AND status = 'approved');

SELECT initiator_user_id 
 FROM view_friends
 JOIN friend_requests ON target_user_id = fid
 WHERE initiator_user_id != 1 
 AND status = 'approved'
 UNION
 SELECT target_user_id 
 FROM view_friends
 JOIN friend_requests ON initiator_user_id = fid
 WHERE target_user_id != 1 
 AND status = 'approved';