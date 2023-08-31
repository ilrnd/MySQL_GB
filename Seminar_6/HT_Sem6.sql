/*Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы
users в таблицу users_old (использование транзакции с выбором commit или ROLLBACK обязательно)*/
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);
DROP PROCEDURE IF EXISTS to_users_old;
DELIMITER //
CREATE PROCEDURE to_users_old(move_id INT)
BEGIN

START TRANSACTION;
INSERT INTO users_old SELECT * FROM users WHERE users.id = move_id;
DELETE FROM users WHERE users.id = move_id LIMIT 1;
COMMIT;

END //
DELIMITER ;

CALL to_users_old(10); 

SELECT * FROM users_old;
SELECT * FROM users;
INSERT INTO users (id, firstname, lastname, email) VALUES 
(10, 'Jordyn', 'Jerde', 'edach@example.com');

/*Создайте хранимую функцию hello(), которая будет возвращать приветсвие в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать
фразу "Доброе утро", с 12:00 до 18:00 - "Добрый день", с 18:00 до 00:00 - добрый вечер*/
DROP FUNCTION IF EXISTS hello; 
DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(20) READS SQL DATA
BEGIN
	SET @curr_time =  curtime();
    SET @evening_up = '24:00:00';
	SEt @night_up = '06:00:00';
    SET @morning_up = '12:00:00';
    SET @afternoon_up = '18:00:00';
    
RETURN
	CASE
		WHEN @curr_time >= @evening_up AND @curr_time <  @night_up THEN 'Good night'
        WHEN @curr_time >= @night_up AND @curr_time <  @morning_up THEN 'Good morning'
        WHEN @curr_time >= @morning_up AND @curr_time <  @afternoon_up THEN 'Good afternoon'
        WHEN @curr_time >= @afternoon_up AND @curr_time <  @evening_up THEN 'Good evening'
	END;
END//
DELIMITER ;

SELECT curtime() AS now, hello() AS hello;

/*(по желанию) Создайте таблицу logs типа Arhive. Пусть при каждом создании записи в таблице users, communities и message в таблицу logs помещается время
и дата создания записи, название таблицы, идентификатор первичного ключа*/
DROP TABLE IF EXISTS logs_table;
CREATE TABLE logs_table  (
    date_change DATETIME,
    table_update VARCHAR(50),
    id_prim_key INT
)
ENGINE= ARCHIVE;

DROP TRIGGER IF EXISTS archive_user;
DELIMITER //
CREATE TRIGGER archive_user AFTER INSERT
ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs_table (date_change, table_update, id_prim_key) VALUES (current_timestamp(), 'users', new.id);
END//
DELIMITER ;
INSERT INTO users (id, firstname, lastname, email) VALUES 
(11, 'Joe', 'Biden', 'joes@us.org');


DROP TRIGGER IF EXISTS archive_communities;
DELIMITER //
CREATE TRIGGER archive_communities AFTER INSERT
ON communities
FOR EACH ROW
BEGIN
	INSERT INTO logs_table (date_change, table_update, id_prim_key) VALUES (current_timestamp(), 'communities', new.id);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS archive_messages;
DELIMITER //
CREATE TRIGGER archive_messages AFTER INSERT
ON messages
FOR EACH ROW
BEGIN
	INSERT INTO logs_table (date_change, table_update, id_prim_key) VALUES (current_timestamp(), 'messages', new.id);
END//
DELIMITER ;

INSERT INTO users (id, firstname, lastname, email) VALUES 
(11, 'Joe', 'Biden', 'joes@us.org');

INSERT INTO communities (name) 
VALUES ('more');

INSERT INTO messages  (from_user_id, to_user_id, body, created_at) VALUES
(1, 2, 'Test message',  DATE_ADD(NOW(), INTERVAL 0 MINUTE));

SELECT * FROM logs_table;


