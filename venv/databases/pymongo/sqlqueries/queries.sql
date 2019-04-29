SET SEARCH_PATH TO education;

CREATE TABLE students (
    student_uuid UUID DEFAULT uuid_generate_v4(),
    lname TEXT NOT NULL,
    fname TEXT NOT NULL,
    bdate DATE NOT NULL,
    gender VARCHAR(6) NOT NULL,
    lang TEXT NOT NULL,
    email TEXT,
    univer TEXT,
    ipaddr TEXT
);