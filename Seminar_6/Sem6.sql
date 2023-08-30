/*Задача 1.  Создайте процедуру, которая выберет для одного пользователя
 5 пользователей в случайной комбинации, которые удовлетворяют хотя бы одному критерию:
1) из одного города 
2) состоят в одной группе
3) друзья друзей*/
DROP PROCEDURE IF EXISTS user_friends;
DELIMITER //
CREATE PROCEDURE user_friends( us_id INT)
BEGIN

WITH view_friends AS
(SELECT initiator_user_id AS fid
 FROM friend_requests 
 WHERE target_user_id = us_id 
 AND status = 'approved'
 UNION
 SELECT target_user_id 
 FROM friend_requests 
 WHERE initiator_user_id = us_id 
 AND status = 'approved')
 
 
 
 SELECT initiator_user_id 
 FROM view_friends
 JOIN friend_requests ON target_user_id = fid
 WHERE initiator_user_id != us_id 
 AND status = 'approved'
 UNION
 SELECT target_user_id 
 FROM view_friends
 JOIN friend_requests ON initiator_user_id = fid
 WHERE target_user_id != us_id 
 AND status = 'approved'
 
 UNION
 SELECT user_id FROM profiles
WHERE hometown = 
(SELECT hometown FROM profiles WHERE user_id = us_id) AND  user_id != us_id
UNION
SELECT user_id FROM users_communities WHERE community_id IN
(SELECT community_id FROM users_communities WHERE user_id = us_id) AND  user_id != us_id;
 
END //
DELIMITER ;

CALL user_friends (1);