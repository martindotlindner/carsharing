-- addional airport fees are not considered yet!
-- Tegel: ST_GeomFromText('POINT(13.287711 52.559686)', 4326) 
-- Schönefeld: ST_GeomFromText('POINT(13.52 52.388333)', 4326) 

ALTER TABLE berlin.routes ADD COLUMN sales double precision;
--calculate costs for Car2Go
UPDATE berlin.routes SET sales = CASE
   WHEN duration_min < 60 THEN duration_min*0.29  
   WHEN duration_min >= 60 AND duration_min < 236 THEN duration_min*0.25 
   WHEN duration_min >= 236 AND duration_min < 1440 THEN 79
   WHEN duration_min >= 1440 AND duration_min < 2880 THEN 158
   WHEN duration_min >= 2880 THEN 237
   ELSE duration_min*9999999 
END
WHERE berlin.routes.provider LIKE 'CAR2GO';

--calculate costs for Drivenow
UPDATE berlin.routes SET sales = CASE
   WHEN duration_min < 60 THEN duration_min*0.29  --0.29 euro/min
   WHEN duration_min >= 60 AND duration_min < 180 THEN 29 
   WHEN duration_min >= 180 AND duration_min < 360 THEN 54
   WHEN duration_min >= 360 AND duration_min < 540 THEN 79
   WHEN duration_min >= 540 AND duration_min < 1440 THEN 109
   WHEN duration_min >= 1440 AND duration_min < 2880 THEN 218
   ELSE duration_min*9999999 
END
WHERE berlin.routes.provider LIKE 'DRIVENOW';

DELETE FROM berlin.routes WHERE sales > 999999;