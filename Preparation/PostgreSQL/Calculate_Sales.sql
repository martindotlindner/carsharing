ALTER TABLE berlin.routes ADD COLUMN sales double precision;
--calculate costs
UPDATE berlin.routes SET sales = CASE
   WHEN duration_min < 60 THEN duration_min*0.29  --0.29 euro/min
   WHEN duration_min >= 60 AND duration_min < 236 THEN duration_min*0.25 
   WHEN duration_min >= 236 AND duration_min < 1440 THEN 59
   WHEN duration_min >= 1440 AND duration_min < 2880 THEN 118
   WHEN duration_min >= 2880 THEN 177
   ELSE duration_min*9999999 
END;