CREATE SCHEMA education AUTHORIZATION postgres;

SET search_path TO education;

DROP TABLE IF EXISTS students;

CREATE TABLE students (
    record_book NUMERIC(5) NOT NULL,
    name TEXT NOT NULL,
    doc_serial NUMERIC(4),
    doc_number NUMERIC(6),
    PRIMARY KEY(record_book)
);

ALTER TABLE students
    ADD COLUMN user_name TEXT DEFAULT current_user,
    ADD COLUMN add_dt TIMESTAMP DEFAULT current_timestamp;

INSERT INTO students VALUES(12345, 'Lera Didkovskaya', 2235, 622443);

ALTER TABLE students ADD CONSTRAINT document_unique UNIQUE (doc_serial, doc_number);

INSERT INTO students (record_book, name, doc_serial) VALUES (22376, 'Zhenya Ogorodnikova', 2234);
INSERT INTO students (record_book, name, doc_serial) VALUES (22377, 'Zhenya Znayev', 2234);
INSERT INTO students (record_book, name) VALUES (22378, 'Marina Sergeeva');
INSERT INTO students (record_book, name) VALUES (22379, 'Thelggi Onenborgi');

DROP TABLE IF EXISTS progress;

CREATE TABLE progress (
    record_book NUMERIC(5) NOT NULL,
    subject TEXT NOT NULL,
    acad_year TEXT NOT NULL,
    term NUMERIC(1) NOT NULL,
    mark NUMERIC(1) NOT NULL DEFAULT 6,
    CONSTRAINT valid_term
        CHECK (term = 1 OR term = 2),
    CONSTRAINT valid_mark
        CHECK (mark >= 3 AND mark <=5),
    FOREIGN KEY (record_book)
        REFERENCES students(record_book)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

ALTER TABLE progress
    ADD COLUMN test_form VARCHAR(10) NOT NULL,
    DROP CONSTRAINT valid_mark,
    ADD CONSTRAINT valid_mark_check CHECK(
        (test_form = 'exam' AND mark IN (3, 4, 5)) OR
        (test_form = 'offset' AND mark IN (0, 1)));

INSERT INTO progress VALUES (12345, 'Chemistry', '2018/2019', 2, 5, 'exam');
INSERT INTO progress VALUES (12345, 'Sports', '2018/2019', 2, 1, 'offset');
INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
    VALUES (12345, 'Biology', '2018/2019', 2, 5, 'exam');
INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
    VALUES (12345, 'Math', '2018/2019', 2, 5, 'exam');

ALTER TABLE progress
    ALTER COLUMN term DROP NOT NULL,
    ALTER COLUMN mark DROP NOT NULL;

ALTER TABLE progress DROP CONSTRAINT progress_record_book_fkey;
ALTER TABLE students DROP CONSTRAINT students_pkey;
DELETE FROM students;
DELETE FROM progress;
ALTER TABLE students  ADD PRIMARY KEY (doc_serial, doc_number);
ALTER TABLE students  DROP COLUMN record_book;

ALTER TABLE progress
    DROP COLUMN record_book,
    ADD COLUMN doc_serial NUMERIC(4),
    ADD COLUMN doc_number NUMERIC(6),
    ADD FOREIGN KEY (doc_serial, doc_number)
        REFERENCES students (doc_serial, doc_number)
            ON UPDATE CASCADE
            ON DELETE CASCADE;

INSERT INTO students VALUES ('Valeriya Didkovskaya', 2219, 234334);
INSERT INTO students VALUES ('Zhenya Ogorodnikova', 2219, 234444);
INSERT INTO students VALUES ('Unnamed Student', 1111, 111111);

INSERT INTO progress VALUES ('Chemistry', '2018/2019', 2, 5, 'exam', 2219, 234334);
INSERT INTO progress VALUES ('Math', '2018/2019', 2, 4, 'exam', 2219, 234334);
INSERT INTO progress VALUES ('Sports', '2018/2019', 2, 1, 'offset', 2219, 234334);

INSERT INTO progress VALUES ('Chemistry', '2018/2019', 2, 5, 'exam', 2219, 234444);
INSERT INTO progress VALUES ('Math', '2018/2019', 2, 5, 'exam', 2219, 234444);
INSERT INTO progress VALUES ('Sports', '2018/2019', 2, 1, 'offset', 2219, 234444);

ALTER TABLE progress
    ALTER COLUMN doc_serial SET DEFAULT 1111,
    ALTER COLUMN doc_number SET DEFAULT 111111;

INSERT INTO progress VALUES ('Chemistry', '2018/2019', 2, 5, 'exam', 2204, 334544);
INSERT INTO progress VALUES ('Math', '2018/2019', 2, 4, 'exam', 2204, 334544);
INSERT INTO progress VALUES ('Sports', '2018/2019', 2, 1, 'offset', 2204, 334544);


UPDATE students SET doc_number = 234111 WHERE name = 'Petr Petrov';
UPDATE students SET doc_number = 333333 WHERE name = 'Valeriya Didkovskaya';
DELETE FROM students WHERE doc_number = 234444;

ALTER TABLE progress
    ALTER COLUMN doc_serial SET DEFAULT 1111,
    ALTER COLUMN doc_number SET DEFAULT 111111;

INSERT INTO students VALUES ('Unnamed Student', 1111, 111111);

ALTER TABLE progress
    DROP CONSTRAINT progress_doc_serial_fkey,
    ADD FOREIGN KEY (doc_serial, doc_number)
        REFERENCES students (doc_serial, doc_number)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT;

ALTER TABLE progress
    DROP CONSTRAINT progress_doc_serial_fkey,
    ADD FOREIGN KEY (doc_serial, doc_number)
        REFERENCES students (doc_serial, doc_number)
            ON DELETE SET NULL
            ON UPDATE SET NULL;

ALTER TABLE progress
	DROP CONSTRAINT progress_doc_serial_fkey,
	ADD FOREIGN KEY (doc_serial, doc_number)
		REFERENCES students (doc_serial, doc_number)
			ON DELETE SET DEFAULT
			ON UPDATE SET DEFAULT;

DROP TABLE IF EXISTS subjects;

CREATE TABLE subjects (
    subject_id INT PRIMARY KEY,
    subject TEXT NOT NULL,
    CONSTRAINT subject_unique UNIQUE (subject)
);

COMMENT ON TABLE subjects IS 'Subjects data';
COMMENT ON COLUMN subjects.subject IS 'Subject name';

INSERT INTO subjects VALUES (1, 'Math'), (2, Biology), (3, Chemistry), (4, Sports);

ALTER TABLE progress
    ALTER COLUMN subject DROP NOT NULL,
    ALTER COLUMN subject SET DATA TYPE INT
        USING(CASE WHEN subject = 'Math' THEN 1
                   WHEN subject = 'Biology' THEN 2
                   WHEN subject = 'Chemistry' THEN 3
                   WHEN subject = 'Sports' THEN 4
                   ELSE 5 END),
    ADD FOREIGN KEY (subject)
        REFERENCES subjects (subject_id);

ALTER TABLE students ADD CONSTRAINT name_check CHECK (name <> '');

ALTER TABLE students
    DROP CONSTRAINT name_check,
    ADD CONSTRAINT name_check CHECK (TRIM(name) <> '');

ALTER TABLE progress
    ALTER COLUMN mark SET DEFAULT 5;

ALTER TABLE students
    ALTER COLUMN doc_serial SET DATA TYPE TEXT,
    ALTER COLUMN doc_number SET DATA TYPE TEXT;