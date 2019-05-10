:edu

DROP TABLE IF EXISTS groups;

CREATE TABLE groups (
    group_id SERIAL PRIMARY KEY,
    group_name TEXT NOT NULL,
    group_num INT NOT NULL,
    CONSTRAINT name_num_unique
        UNIQUE(group_name, group_num));
        
ALTER TABLE groups
    ADD CONSTRAINT positive_group_num CHECK (group_num > 0),
    ADD CONSTRAINT group_name_chek CHECK (trim(group_name) <> ''); 