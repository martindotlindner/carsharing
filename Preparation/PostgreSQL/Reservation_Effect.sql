-- Effects of free reservations from 0:00 - 6:00 on weekends

COPY(
SELECT count(*) AS count, AVG(EXTRACT(EPOCH FROM berlin.routes.duration)/3600) AS avg_duration_h, EXTRACT(isodow from timestampstart) AS dow, provider FROM berlin.routes
WHERE (timestampstart::time) < '07:00:00'::time --AND duration > '05:00:00'::interval
GROUP BY dow, provider
ORDER BY dow)
TO 'C:/Program Files/PostgreSQL/9.5/data/reservation_effect.csv' DELIMITER ';' CSV HEADER;

COPY(
SELECT count(*) AS count, EXTRACT(isodow from timestampstart) AS dow, provider FROM berlin.routes
WHERE (timestampstart::time) < '07:00:00'::time AND duration > '04:00:00'::interval
GROUP BY dow, provider
ORDER BY dow)
TO 'C:/Program Files/PostgreSQL/9.5/data/reservation_effect_count.csv' DELIMITER ';' CSV HEADER;


