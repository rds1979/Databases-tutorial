SELECT
	w.city, w.temp_lo, w.temp_hi, w.pcrp, w.date, c.location
FROM weather w
LEFT OUTER JOIN cities c
ON (w.city = c.name)

SELECT
	w.city, w.temp_lo, w.temp_hi, w.pcrp, w.date, c.location
FROM weather w
INNER JOIN cities c
ON (w.city = c.name)

