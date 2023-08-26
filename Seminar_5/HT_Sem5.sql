/*. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет. */
CREATE OR REPLACE VIEW view_messages
AS 
(SELECT firstname, lastname, gender, hometown
FROM users
JOIN PrOFiLES ON uSERS.id = profiles.USer_ID 
WHERE TIMESTAMPDIFF(YEAR, birtHday, CURDATE()) <= 20);

SELECT *
FROM view_mesSages;

/*2. НайдитЕ КОЛ-ВО, ОТПРАВЛЕННЫХ СОобщений КаЖДЫМ ПОЛЬЗоВАтЕЛЕм и ВЫВЕДиТе РАНжированный список пользователей, 
указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
(первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)*/
SELECT users.id, firstname, lastname, COUNT(messages.body) AS send_messages,
DENSE_RANK() OVER(ORDER BY COUNT(messages.body) DESC) rank_messages
FROM users
JOIN messages ON users.id = messages.from_user_id
GROUP BY users.id
;


/*Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) 
и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)*/

SELECT body AS message, created_at AS '',
timestampdiff(minute, lag(created_at) OVER(ORDER BY created_at), created_at) AS 'difference time, minutes' 
FROM messages
ORDER BY created_at
;