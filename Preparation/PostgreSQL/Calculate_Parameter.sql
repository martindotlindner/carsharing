-- wichtige Parameter berechnen


--Nutzungsdauer als Interval berechnen
ALTER TABLE berlin.routes ADD COLUMN Nutzungsdauer interval;
UPDATE berlin.routes
    SET Nutzungsdauer =  TIMESTAMPEND - TIMESTAMPSTART ;
    
--Nutzungsdauer in Stunden berechnen
ALTER TABLE berlin.routes ADD COLUMN Nutzungsdauer_h double precision;
UPDATE berlin.routes
    SET Nutzungsdauer_h = EXTRACT(epoch FROM Nutzungsdauer)/3600 ;

--Distanz in Metern berechnen
ALTER TABLE berlin.routes ADD COLUMN distance double precision;
UPDATE berlin.routes
    SET distance = ROUND(ST_Length(geom)::numeric,2) ;

--Durchschnittsgeschwindigkeit berechnen
ALTER TABLE berlin.routes ADD COLUMN mean_speed double precision;
UPDATE berlin.routes
    SET mean_speed = (distance/1000)/(EXTRACT(epoch FROM Nutzungsdauer)/3600) ; 