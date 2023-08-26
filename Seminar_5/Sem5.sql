/*Задача 1. Получить с помощью оконных функции:
средний балл ученика 
наименьшую оценку ученика
наибольшую оценку ученика
сумму всех оценок
количество всех оценок*/
SELECT name, grade, 
avg(grade) OVER( PARTITION BY name) AS average,
max(grade) OVER( PARTITION BY name) AS max,
min(grade) OVER( PARTITION BY name) AS min,
sum(grade) OVER( PARTITION BY name) AS sum,
count(grade) OVER( PARTITION BY name) AS count 
FROM academic_record;

/*Задача 2. Получить информацию об оценках 
Пети по физике по четвертям: 
текущая успеваемость 
оценка в следующей четверти
оценка в предыдущей четверти*/

SELECT name, 
grade, quartal,
LAG(grade) OVER ql AS next_q,
LEAD(grade) OVER ql AS previous_q
FROM academic_record
WHERE 
subject = 'физика'
AND
name = 'Петя'
WINDOW ql AS (ORDER BY quartal)
;

