CREATE TABLES employeer_hobies (
    employeer_name TEXT,
    employeer_hobies JSONB
)

DELETE FROM employeer_hobies;

INSERT INTO employeer_hobies(
	employeer_name,
	employeer_hobi
) VALUES
('Иван', '{
	"sports": ["Футбол", "Плавание"],
    "home_lib":true, "trips":3
  }'::jsonb
),
('Петр', '{
	"sports": ["Теннис", "Плавание"],
    "home_lib":true, "trips":2
  }'::jsonb
),
('Павел', '{
	"sports": ["Плавание"],
    "home_lib":true, "trips":4
  }'::jsonb
),
('Борис', '{
	"sports": ["Футбол", "Плавание", "Теннис"],
    "home_lib":true, "trips":0
  }'::jsonb
);

SELECT * FROM employeer_hobies
WHERE employeer_hobi @> '{"sports" : ["Футбол"]}'::jsonb;