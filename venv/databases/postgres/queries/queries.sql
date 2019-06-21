SELECT * FROM aircrafts WHERE  model ~~ 'Аэро%';
SELECT * FROM aircrafts 
	WHERE model NOT LIKE 'Аэро%'
	  AND model NOT LIKE 'Боин%';

SELECT * FROM airports WHERE airport_name LIKE '___';

EXPLAIN ANALYZE SELECT * FROM bookings;

SELECT * FROM aircrafts WHERE model SIMILAR TO '(А%|Бои%)';
SELECT * FROM aircrafts WHERE model ~ '^(А|Бои)';

SELECT * FROM aircrafts WHERE model !~ '300$';

SELECT * FROM aircrafts WHERE range BETWEEN 3000 AND 6000;


