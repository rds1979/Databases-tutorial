-- числовые типы данных
CREATE TABLE employeers (
    emloyeer_uuid UUID DEFAULT uuid_generate_v4(),
    employeer_salary NUMERIC (8,2),
    employeer_projects INTEGER,
    PRIMARY KEY (emloyeer_uuid)
);

-- Последнее значение инсерта будет обрезано до двух знаков после запятой
INSERT INTO employeers(employeer_salary)
VALUES (60000),(57500),(80000),(72000.80),(60000.134);

DROP TABLE employeers;

CREATE TABLE employeers (
    emloyeer_bigserial BIGSERIAL,
    employeer_salary NUMERIC (8,2),
    employeer_projects INTEGER,
    PRIMARY KEY (emloyeer_uuid)
);

ALTER TABLE employeers
ALTER COLUMN emloyeer_bigserial TYPE SMALLINT

-- Значение Num будет обрезано до дзпз, Integer преобразовано в целое число
INSERT INTO employeers (
	employeer_salary, employeer_projects
)VALUES(501453455464.34567, 10.345);


CREATE TABLE employeers (
    emloyeer_bigserial SMALLSERIAL,
    employeer_salary NUMERIC (8,2),
    employeer_projects INTEGER,
    employeers_measurement REAL(4), -- FLOAT(1..24) - REAL
    PRIMARY KEY (emloyeer_uuid)
);
-- строковые типы данных
CREATE TABLE alphabets (
    aaa CHAR(3),
    bbb VARCHAR(10),
    ccc TEXT,
    PRIMARY KEY (aaa),
	CHECK(bbb IN ('Somewhat', 'Bla-bla', 'To-to'))
);

DELETE FROM alphabets;

INSERT INTO alphabets VALUES
	('AAA', 'Somewhat', 'Somewhat\somewhat'), -- \
	('CCC', 'Somewhat', $$Somewhat'Somewhat$$), -- $$ ' $$
	('CC', 'Bla-bla', 'Somewhat-somewhat-somewhat'), --CHAR added 000
	('ZZZ', 'Somewhat', 'Somewhat''somewhat'), -- ''
	('BBB', 'Somewhat', 'Somewhat$somewhat'); -- $

-- типы данных даты и времени
CREATE TABLE dates (
	birthday DATE,
	today DATE DEFAULT current_date,
	now TIME default current_time,
	timeprint TIMESTAMPTZ DEFAULT current_timestamp
);

INSERT INTO dates VALUES ('05.10.1979');

SELECT to_char(birthday, 'dd.mm.yyyy') AS bday,
	   to_char(today, 'dd.mm.yyyy') AS today FROM dates;

SELECT to_char(timeprint, 'dd.mm.yyyy hh24:mi') FROM dates; -- смена формата вывода даты-времени
SELECT (birthday::TIMESTAMP - today::TIMESTAMP):: INTERVAL FROM dates; -- интервал в днях
SELECT age(birthday) from dates; -- считаем возраст на текущую дату
SELECT extract('mon' FROM birthday) FROM dates; -- извлекаем месяц из текущей даты

-- логические типы данных

CREATE TABLE dbms (
	is_opens BOOLEAN,
	dbms_name TEXT
);

INSERT INTO dbms
VALUES ('false', 'Microsoft SQL SERVER'),
	   ('yes', 'PostgreSQL'),
	   ('n', 'Oracle'),
	   ('1', 'MySql');

SELECT * from dbms WHERE is_opens; -- можно не указывать значение логического столбца, выберет True

-- Структуры данных: массивы

CREATE TABLE employeers (
    employeer_name VARCHAR(50),
    week_days INTEGER[]
);

INSERT INTO employeers
    VALUES
        ('Иван', '{1,3,5,6,7}'::integer[]),
        ('Сергей', '{2, 4}'::integer[]),
        ('Анатолий', '{1,3,5}'::integer[]),
        ('Владимир', '{7}'::integer[]);

UPDATE employeers
    SET week_days = week_days || 5
    WHERE employeer_name = 'Сергей'; -- добавляем элемент в конец массива конкатенацией

UPDATE employeers
    SET week_days = array_append(week_days, 7) -- добавляем элемент в конец массива функцией
    WHERE employeer_name = 'Анатолий';

UPDATE employeers
    SET week_days = array_prepend(1, week_days) -- добавляем элемент в начало массива функцией
    WHERE employeer_name = 'Сергей';

UPDATE employeers
    SET week_days = '{2,4,6,7}'::integer[] -- переопределяем весь массив
    WHERE employeer_name = 'Анатолий';

UPDATE employeers
	SET week_days = array_remove(week_days, 2) -- удаляем элемент по значению (не по индексу)
	WHERE employeer_name = 'Анатолий';

UPDATE employeers
	SET week_days[1] = 2, week_days[2] = 3 -- изменяем значения элементов по индексу, нумерация индексов начинается с 1
	WHERE employeer_name = 'Сергей';

UPDATE employeers
	SET week_days[1:3] = ARRAY[1,2,3] -- изменяем срез массива
	WHERE employeer_name = 'Владимир';

SELECT * FROM employeers
    WHERE array_position(week_days, 5) IS NOT NULL; -- array_position находит первое вхождение элемента в массив
                                                    -- или возвращает NULL

SELECT * FROM employeers
	WHERE week_days @> '{1,7}'::INTEGER[]; -- оператор @> проверяет, что все элементы правого массива
	                                       -- находятся в левом массиве

SELECT * FROM employeers
	WHERE week_days && ARRAY[2,5]; -- оператор && "или" проверяет наличие хотя бы одного элемента правого массива
	                               -- в левом массиве

SELECT * FROM employeers
	WHERE NOT (week_days && ARRAY[2,4,6]); -- отрицательный запрос - не должен вкючаться ни один указанный элемент

SELECT UNNEST(week_days) AS days  -- UNNEST разворачивает массив в столбец
FROM employeers
WHERE employeer_name = 'Сергей'