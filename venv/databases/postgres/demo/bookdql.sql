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