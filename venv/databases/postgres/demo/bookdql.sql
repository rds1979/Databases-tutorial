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