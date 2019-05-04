--> \l
--> \c demo
--> \dn
--> SET SEARCH_PATH bookings
--> \x
--> \d
SELECT * FROM airports;
SELECT * FROM airports_data;
SELECT * FROM aircrafts;
SELECT * FROM aircrafts_data;

SELECT * FROM aircrafts_data WHERE model::TEXT ~~ '%Airbus%';

SELECT * FROM aircrafts_data
    WHERE model:: TEXT !~~ '%Airbus%'
    AND model::TEXT !~~ '%Boeing%';

SELECT * FROM aircrafts_data
    WHERE model:: TEXT NOT LIKE '%Airbus%'
    AND model::TEXT NOT LIKE '%Boeing%';

SELECT * FROM airports WHERE airport_name LIKE '___';

SELECT * FROM aircrafts WHERE model ~ '^(А|Бои)';
SELECT * FROM aircrafts WHERE model !~ '300$';

SELECT * FROM aircrafts WHERE range::INT BETWEEN 3000 AND 6000;

SELECT models, range "kilometers", round(range/1.609, 2) "miles" FROM aircrafts;

SELECT * FROM aircrafts ORDER BY range DESC;

SELECT DISTINCT timezone FROM airports ORDER BY 1;

SELECT airport_name, city, coordinates[0]"longtitude" FROM airports ORDER BY longtitude DESC LIMIT 3 OFFSET 3;

SELECT model, range"kilometers", round(range/1.609, 2)"miles",
CASE
    WHEN range < 2000 THEN 'Ближнемагистральный'
    WHEN range < 5000 THEN 'Среднемагистральный'
    ELSE 'Дальнемагистральный' END"type"
FROM aircrafts ORDER BY range DESC;

SELECT
    a.aircraft_code"code", a.model,
    s.seat_no"seat", s.fare_conditions"fare"
FROM seats s JOIN aircrafts a
ON s.aircraft_code = a.aircraft_code
WHERE a.model ~ '^Сессна' ORDER BY s.seat_no;

SELECT
    a.aircraft_code AS code, a.model,
    s.seat_no AS seat, s.fare_conditions AS fcond
FROM seats AS s, aircrafts AS a
WHERE s.aircraft_code = a.aircraft_code
AND a.model LIKE 'Сессна%' ORDER BY s.seat_no;