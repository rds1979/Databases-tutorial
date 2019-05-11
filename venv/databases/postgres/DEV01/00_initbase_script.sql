\! sudo mkdir /data/exttbspaces/bsstore
\! sudo chown postgres.postgres /data/exttbspaces/bsstore
\! sudo chmod 700 /data/exttbspaces/bssrore

CREATE TABLESPACE bsstore LOCATION '/data/exttbspaces/bsstore';
CREATE DATABASE bsstore TABLESPACE bsstore;

\c bsstore

CREATE SCHEMA market AUTHORIZATION dmitriy;
CREATE SCHEMA xstore;

SET SEARCH_PATH TO market;

ALTER DATABASE bsstore SET SEARCH_PATH TO market, xstore;