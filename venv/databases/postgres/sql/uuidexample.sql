CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SELECT uuid_generate_v4()

CREATE TABLE contacts (
    contact_id UUID DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR NOT NULL,
	phone VARCHAR,
	PRIMARY KEY (contact_id)
);

INSERT INTO contacts(
    first_name,
    last_name,
    email,
    phone
)
VALUES
(
        'John',
        'Smith',
        'john.smith@example.com',
        '408-237-2345'
    ),
    (
        'Jane',
        'Smith',
        'jane.smith@example.com',
        '408-237-2344'
    ),
    (
        'Alex',
        'Smith',
        'alex.smith@example.com',
        '408-237-2343'
    );