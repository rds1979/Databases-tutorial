--> psql
--> \l
CREATE DATABASE tutorial;

--> \dn+
DROP SCHEMA IF EXISTS bookings CASCADE;

CREATE USER dmitriy WITH ENCRYPTED PASSWORD '*********';
GRANT ALL PRIVILEGES ON DATABASE tutorial TO dmitriy;

--> psql -d tutorial -U dima
CREATE SCHEMA bookings AUTHORIZATION dima;

SET SEARCH_PATH TO bookings;

DROP TABLE IF EXISTS aircrafts;

CREATE TABLE aircrafts (
    aircraft_code CHAR(3) NOT NULL,
    model JSONB NOT NULL,
    range INT NOT NULL,
    PRIMARY KEY (aircraft_code),
    CONSTRAINT positive_range_value
    	CHECK (range > 0)
); -- Таблица самолётов

COMMENT ON TABLE aircrafts IS 'Aircrafts data';

--> \d+
--> \df
--> \du

INSERT INTO aircrafts (aircraft_code, model, range)
VALUES ('SU9', '{"en":"Sukhoi SuperJet-100", "ru":"Сухой СуперДжет-100"}', 3000),
       ('763', '{"en":"Boeing 767-300", "ru":"Боинг 767-300"}', 7900),
       ('733', '{"en":"Boeing 737-300", "ru":"Боинг 737-300"}', 4200),
       ('320', '{"en":"Airbus A320-200", "ru":"Аэробус A320-200"}', 5700),
       ('321', '{"en":"Airbus A321-200", "ru":"Аэробус A321-200"}', 5600),
       ('319', '{"en":"Airbus A319-100", "ru":"Аэробус A319-100"}', 6700),
       ('CN1', '{"en":"Cessna 208 Caravan", "ru":"Цессна 208 Караван"}', 1200),
       ('CR2', '{"en":"Bombardier CRJ-200", "ru":"Бомбардир CRJ-200"}', 2700),
       ('773', '{"en":"Boeing 777-300", "ru":"Боинг 777-300"}', 11100);

CREATE USER zhenya WITH ENCRYPTED PASSWORD '********';
GRANT USAGE ON SCHEMA booking TO zhenya;
GRANT SELECT ON ALL TABLES IN SCHEMA booking TO zhenya;

ALTER TABLE aircrafts ADD COLUMN speed INT;

UPDATE aircrafts SET speed = 807 WHERE aircraft_code = '733';
UPDATE aircrafts SET speed = 851 WHERE aircraft_code = '763';
UPDATE aircrafts SET speed = 907 WHERE aircraft_code = '773';
UPDATE aircrafts SET speed = 786 WHERE aircraft_code = 'CR2';
UPDATE aircrafts SET speed = 341 WHERE aircraft_code = 'CN1';
UPDATE aircrafts SET speed = 830 WHERE aircraft_code = 'SU9';

UPDATE aircrafts SET speed = 851 WHERE aircraft_code = '763';
UPDATE aircrafts SET speed = 840
    WHERE aircraft_code IN ('319', '320', '321');

SELECT 
	MIN(speed)"Minimum speed",
	MAX(speed)"Maximum speed",
	round(AVG(speed),2)"Average speed"
FROM aircrafts;

ALTER TABLE aircrafts ALTER COLUMN speed SET NOT NULL;
ALTER TABLE aircrafts ADD CONSTRAINT spedd_more CHECK (speed >= 300);
ALTER TABLE aircrafts RENAME CONSTRAINT spedd_more TO speed_more;

-- ALTER TABLE aircrafts ALTER COLUMN speed DROP NOT NULL;
-- ALTER TABLE aircrafts DROP CONSTRAINT speed_more;
-- ALTER TABLE aircrafts DROP COLUMN speed;

DROP TABLE IF EXISTS fare_conditions;

CREATE TABLE fare_conditions (
    fare_conditions_code INT NOT NULL,
    fare_conditions_name VARCHAR(10) NOT NULL,
    PRIMARY KEY(fare_conditions_code)
);

COMMENT ON TABLE fare_conditions IS 'Fare condition data';

INSERT INTO fare_conditions (fare_conditions_code, fare_conditions_name)
    VALUES(1, 'Economy'),
          (2, 'Business'),
          (3, 'Comfort');

ALTER TABLE fare_conditions ADD UNIQUE (fare_conditions_name);

DROP TABLE IF EXISTS seats;

CREATE TABLE seats (
    aircraft_code CHAR(3) NOT NULL,
    seat_num VARCHAR(4) NOT NULL,
    fare_conditions VARCHAR(10)NOT NULL,
    CONSTRAINT fare_conditions_in
        CHECK(fare_conditions IN ('Economy', 'Comfort', 'Business')),
    PRIMARY KEY(aircraft_code, seat_num),
    FOREIGN KEY(aircraft_code) REFERENCES aircrafts (aircraft_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE
); -- Таблица мест в самолётах

COMMENT ON TABLE seats IS 'Seats data';

INSERT INTO seats (aircraft_code, seat_num, fare_conditions)
VALUES ('SU9', '1A', 'Business'),
       ('SU9', '1B', 'Business'),
       ('SU9', '10A', 'Economy'),
       ('SU9', '10B', 'Economy'),
       ('SU9', '10F', 'Economy'),
       ('SU9', '20F', 'Economy'),
       ('SU9', '1F', 'Comfort'),
       ('SU9', '2F', 'Comfort');

ALTER TABLE seats
    DROP CONSTRAINT fare_conditions_in,
    ALTER COLUMN fare_conditions SET DATA TYPE INT
    USING (CASE WHEN fare_conditions = 'Economy'  THEN 1
                WHEN fare_conditions = 'Business' THEN 2
                ELSE 3 END),
    ADD FOREIGN KEY(fare_conditions)
        REFERENCES fare_conditions(fare_conditions_code);

ALTER TABLE seats RENAME COLUMN fare_conditions TO fare_conditions_code;

ALTER TABLE seats RENAME CONSTRAINT seats_fare_conditions_fkey
	TO seats_fare_conditions_code_fkey;

DROP TABLE IF EXISTS aCirports;

CREATE TABLE airports (
    airport_code CHAR(3)NOT NULL,
    airport_name TEXT NOT NULL,
    city TEXT NOT NULL,
    longitude FLOAT NOT NULL,
    latitude FLOAT NOT NULL,
    timezone TEXT NOT NULL,
    PRIMARY KEY(airport_code)
); -- Таблица аэропортов

COMMENT ON TABLE airports IS 'Airport data';
COMMENT ON COLUMN airports.city IS 'City data';

ALTER TABLE airports
    ALTER COLUMN longitude SET DATA TYPE NUMERIC(5,2),
    ALTER COLUMN latitude  SET DATA TYPE NUMERIC(5,2);

DROP TABLE IF EXISTS flights;

CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,                               -- идентификатор рейса
    flight_num CHAR(6) NOT NULL,                                -- номер рейса
    sheduled_departure TIMESTAMPTZ NOT NULL,                    -- время вылета по расписанию
    sheduled_arrival TIMESTAMPTZ NOT NULL,                      -- время прибытия по расписанию
    departure_airport CHAR(3) NOT NULL,                         -- аэропорт вылета
    arrival_airport CHAR(3) NOT NULL,                           -- аэропорт прибытия
    status VARCHAR(20) NOT NULL,                                -- статус рейса
    aircraft_code CHAR(3) NOT NULL,                             -- код самолёта IATA
    actual_departure TIMESTAMPTZ,                               -- фактическое время вылета
    actual_arrival TIMESTAMPTZ,                                 -- фактическое время прибытия
    CONSTRAINT sheduled_arrival_more
        CHECK (sheduled_arrival > sheduled_departure),          -- время прибытия дб > времени отправления
    CONSTRAINT status_in
        CHECK (status IN ('On Time', 'Delayed', 'Departed',
                          'Arrived', 'Sheduled', 'Canceled')),  -- определение состояния статуса
    CONSTRAINT many_other_conditions
        CHECK (actual_arrival IS NULL OR (
               actual_departure IS NOT NULL AND
               actual_arrival IS NOT NULL AND
               actual_arrival > actual_departure
               )),                                              -- гарантия условий времени прибытия
    CONSTRAINT flight_departure_unique
        UNIQUE(flight_id, sheduled_departure),                  -- уникальность идентификатора рейса и времени вылета
    FOREIGN KEY (aircraft_code)
        REFERENCES aircrafts (aircraft_code),                   -- вк ссылающийся на таблицу самолётов
    FOREIGN KEY (arrival_airport)
        REFERENCES airports(airport_code),                      -- вк ссылающийся на таблицу аэропортов
    FOREIGN KEY(departure_airport)
        REFERENCES airports(airport_code)                       -- вк ссылающийся на таблицу аэропортов
); -- Таблица рейсов

COMMENT ON TABLE flights IS 'Flight data';
COMMENT ON SEQUENCE flights_flight_id_seq IS 'Flight sequence';
COMMENT ON COLUMN flights.flight_id IS 'Fligth identity';

DROP TABLE IF EXISTS bookings;

CREATE TABLE bookings (
    book_ref CHAR(6) NOT NULL,
    book_date TIMESTAMPTZ NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY(book_ref)
); -- Таблица бронирования

COMMENT ON TABLE bookings IS 'Bookings data';
COMMENT ON TABLE bookings IS NULL;
COMMENT ON TABLE bookings IS 'Booking data';

DROP TABLE IF EXISTS tickets;

CREATE TABLE tickets (
    ticket_num CHAR(13) PRIMARY KEY,
    passenger_id VARCHAR(20) NOT NULL,
    passenger_name TEXT NOT NULL,
    contact_data JSONB,
    book_ref CHAR(6) NOT NULL,
    FOREIGN KEY (book_ref)
        REFERENCES bookings(book_ref)
); -- Таблица купленных билетов

COMMENT ON TABLE tickets IS 'Ticket data';

DROP TABLE IF EXISTS tickets_flights;

CREATE TABLE tickets_flights (
    ticket_num CHAR(13) NOT NULL,
    flight_id INT NOT NULL,
    fare_conditions VARCHAR(10) NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (ticket_num, flight_id),
    CONSTRAINT total_amount_positive
        CHECK (total_amount >= 0),
    CONSTRAINT fare_conditions_in
        CHECK(fare_conditions IN ('Economy', 'Comfort', 'Business')),
    FOREIGN KEY (ticket_num)
        REFERENCES tickets(ticket_num),
    FOREIGN KEY (flight_id)
        REFERENCES flights(flight_id)
); -- Таблица перелётов

COMMENT ON TABLE tickets_flights IS 'Ticket flight data';

ALTER TABLE tickets_flights
    DROP CONSTRAINT fare_conditions_in,
    ALTER COLUMN fare_conditions SET DATA TYPE INT
        USING(CASE WHEN fare_conditions = 'Economy'  THEN 1
                   WHEN fare_conditions = 'Business' THEN 2
                   ELSE 3 END),
    ADD FOREIGN KEY (fare_conditions)
        REFERENCES fare_conditions(fare_conditions_code);

ALTER TABLE tickets_flights
    RENAME COLUMN fare_conditions TO fare_conditions_code;

ALTER TABLE tickets_flights RENAME CONSTRAINT
    tickets_flights_fare_conditions_fkey TO tickets_flights_fare_conditions_code_fkey;


DROP TABLE IF EXISTS boarding_passes;

CREATE TABLE boarding_passes (
    ticket_num CHAR(13) NOT NULL,
    flight_id INT NOT NULL,
    boarding_num INT NOT NULL,
    seat_num VARCHAR(4) NOT NULL,
    PRIMARY KEY (ticket_num, flight_id),
    CONSTRAINT flight_board_unique
        UNIQUE(flight_id, boarding_num),
    CONSTRAINT flight_seat_unique
        UNIQUE(flight_id, seat_num),
    FOREIGN KEY (ticket_num, flight_id)
        REFERENCES tickets_flights (ticket_num, flight_id)
);

COMMENT ON TABLE boarding_passes IS 'Boarding passenger data';

DROP VIEW IF EXISTS seats_by_fare_cond;

-- CREATE OR REPLACE VIEW seats_by_fare_cond AS
-- SELECT
-- 	s.aircraft_code,
-- 	s.fare_conditions_code,
-- 	COUNT(*) AS num_seats
-- FROM seats s
-- GROUP BY aircraft_code, fare_conditions_code
-- ORDER BY aircraft_code, fare_conditions_code;

CREATE OR REPLACE VIEW seats_by_fare_cond (acode, fcc, num) AS
SELECT
	s.aircraft_code,
    s.fare_conditions_code,
	COUNT(*)
FROM seats s
GROUP BY aircraft_code, fare_conditions_code
ORDER BY aircraft_code, fare_conditions_code;

COMMENT ON VIEW seats_by_fare_cond IS 'By fare cond';

ALTER TABLE seats RENAME TO places;
ALTER TABLE places RENAME TO seats;

ALTER TABLE flights
    DROP CONSTRAINT many_other_conditions,
    ADD CONSTRAINT many_other_conditions CHECK
        (actual_arrival IS NULL OR (
         actual_departure IS NOT NULL AND
         actual_arrival > actual_departure));

ALTER TABLE flights
    DROP CONSTRAINT flights_check1,
    ADD CONSTRAINT flights_check1 CHECK
        (actual_arrival IS NULL OR (
         actual_departure IS NOT NULL AND
         actual_arrival IS NOT NULL AND
         actual_arrival > actual_departure));
