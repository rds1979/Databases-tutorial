\! sudo mkdir /data/exttbspaces/bookshop
\! sudo chown postgres.postgres /data/exttbspaces/bookshop
\! sudo chmod 700 /data/exttbspaces/bookshop

CREATE TABLESPACE bookshop LOCATION '/data/exttbspaces/bookshop';
CREATE DATABASE bookshop TABLESPACE bookshop;

\c bookshop

CREATE SCHEMA bookshop AUTHORIZATION dmitriy;
CREATE SCHEMA xstorage;

SET SEARCH_PATH TO bookshop;

ALTER DATABASE bookshop SET SEARCH_PATH TO bookshop, xstorage;

CREATE TABLE inittbl (id SERIAL, name TEXT);

INSERT INTO inittbl (name) VALUES ('Dmitriy Redkin');

\! touch .psqlrc
\set name 'SELECT name FROM dmitriy WHERE id = 1';
name: