DROP USER dmitriy

CREATE USER dmitriy

ALTER USER dmitriy PASSWORD '*******'

DROP SCHEMA enterprise;

CREATE SCHEMA enterprise AUTHORIZATION postgres;

COMMENT ON SCHEMA enterprise IS 'Демонстрационная схема предприятия в обучающей базе данных tutorial';

-- Удаление таблиц отношений
DROP TABLE IF EXISTS enterprise.products_orders;

-- Удаление основных таблиц
DROP TABLE IF EXISTS enterprise.subdivision;
DROP TABLE IF EXISTS enterprise.employeers;
DROP TABLE IF EXISTS enterprise.salary;
DROP TABLE IF EXISTS enterprise.products;
DROP TABLE IF EXISTS enterprise.orders;


CREATE TABLE enterprise.subdivision (
    subdivision_id_chr CHAR(3) UNIQUE NOT NULL,
    subdivision_title_varch VARCHAR(200) NOT NULL,
    subdivision_strength_int INT,
    PRIMARY KEY (subdivision_id_chr),
    CHECK(subdivision_strength_int > 0)
);

COMMENT ON TABLE enterprise.subdivision IS 'Структурные подразделения предприятия';

ALTER TABLE enterprise.subdivision DROP CONSTRAINT subdivision_pkey

ALTER TABLE enterprise.subdivision ADD PRIMARY KEY (subdivision_title_str)

ALTER TABLE enterprise.subdivision DROP CONSTRAINT subdivision_id_in;

ALTER TABLE enterprise.subdivision ADD COLUMN subdivision_strength_int INT;

ALTER TABLE enterprise.subdivision
    ADD CONSTRAINT subdivision_strength_check
    CHECK(subdivision_strength_int > 0)

ALTER TABLE enterprise.subdivision RENAME COLUMN
subdivision_strenght_dgt TO subdivision_strength_int

ALTER TABLE enterprise.subdivision RENAME CONSTRAINT
subdivision_subdivision_strenght_dgt_check TO subdivision_strength_check

ALTER TABLE enterprise.subdivision ADD COLUMN subdivision_manager_str VARCHAR(10);

DROP FROM enterprise.subdivision;

INSERT INTO enterprise.subdivision(subdivision_id_str, subdivision_title_str)
	VALUES ('AAA', 'Административно управленческий персонал'),
	       ('BBB', 'Бухгалтерия и финансы'),
	       ('CCC', 'Служба безопасности');

UPDATE enterprise.subdivision
	SET subdivision_strength_int = 3
	WHERE subdivision_id_str = 'AAA';

UPDATE enterprise.subdivision
	SET subdivision_strength_int = 5
	WHERE subdivision_id_str = 'BBB';

INSERT INTO enterprise.subdivision
    (subdivision_id_str, subdivision_title_str, subdivision_strength_int)
	VALUES ('DDD', 'Отдел логистики', 4),
	       ('EEE', 'Информационный отдел', 3);


CREATE TABLE enterprise.employeers(
    employeer_id_uuid UUID DEFAULT uuid_generate_v4(),
    employeer_tubnum_str CHAR(5) UNIQUE NOT NULL,
    employeer_lname_str VARCHAR(20),
    employeer_fname_str VARCHAR(20),
    employeer_mname_str VARCHAR(20),
    employeer_bdate_date DATE,
    employeer_start_date DATE DEFAULT current_date,
    employeer_mainjob_bool BOOLEAN NOT NULL,
    subdivision_id_str CHAR(3),
    PRIMARY KEY (employeer_id_uuid)
);

INSERT INTO enterprise.employeers(
	employeer_tubnum_str,
	employeer_lname_str,
    employeer_fname_str,
    employeer_mname_str,
    employeer_bdate_date,
    employeer_mainjob_bool
) VALUES (
	'00001', 'Redkin', 'Dmitriy', 'Sergeevich', '1979-10-05', 'T'
),
(
	'00002', 'Sankin', 'Yuriy', 'Ivanovich', '1945-01-03', 'T'
);

SELECT
	employeer_lname_str AS lname,
	employeer_fname_str AS fname,
	employeer_mname_str AS mname,
	age(employeer_bdate_date)
FROM enterprise.employeers;

CREATE TABLE enterprise.salary(
    salary_id_ser SERIAL,
    salary_sum_int NUMERIC(7,2),
    salary_amount_int NUMERIC(7,2)
    employeer_id_str VARCHAR
);

CREATE TABLE enterprise.products (
	products_id_uuid UUID DEFAULT uuid_generate_v4(),
	products_name_varch VARCHAR UNIQUE,
	products_price_num NUMERIC NOT NULL,
	discount_price_num NUMERIC NOT NULL,
	PRIMARY KEY (products_id_uuid),
	CONSTRAINT price_valid_values CHECK (
		discount_price_num > 0
	AND products_price_num > discount_price_num
	)
);

COMMENT ON TABLE enterprise.products IS 'Таблица продуктов предприятия';

CREATE TABLE enterprise.orders(
    orders_id_uuid UUID DEFAULT uuid_generate_v4(),
	orders_address_txt TEXT NOT NULL,
    PRIMARY KEY (orders_id_uuid)
);

COMMENT ON TABLE enterprise.orders IS 'Таблица заказов продукции';

CREATE TABLE enterprise.products_orders(
    products_id_uuid UUID,
	orders_id_uuid UUID,
    PRIMARY KEY (products_id_uuid, orders_id_uuid),
	FOREIGN KEY(products_id_uuid)
        REFERENCES enterprise.products(products_id_uuid)
        ON DELETE RESTRICT,
    FOREIGN KEY (orders_id_uuid)
        REFERENCES enterprise.orders(orders_id_uuid)
        ON DELETE CASCADE
);

COMMENT ON TABLE enterprise.products_orders IS 'Таблица отношений заказов продукции';