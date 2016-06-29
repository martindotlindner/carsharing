--Fensterfunktionen führen Berechnungen gruppenweise durch. Näheres unter: http://fabrizioregini.info/blog/2015/04/26/postgres-essentials-window-functions/
-- Tabelle löschen
DROP TABLE if exists berlin.standzeit;

-- Zeitdifferenz zw. Stop aus Fahrt1 und Start aus Fahrt 2 
SELECT id, vehicleid, timestampstart, LEAD (timestampstart) OVER (partition by vehicleid ORDER BY vehicleid, timestampstart) -
           timestampend AS timetonext INTO berlin.standzeit
		   FROM berlin.routes;
		   
CREATE INDEX idx_berlin_standzeit_id ON berlin.standzeit(id);

ALTER TABLE berlin.routes DROP COLUMN if exists wait;
ALTER TABLE berlin.routes ADD COLUMN wait interval;

UPDATE berlin.routes
SET    wait = berlin.standzeit.timetonext
FROM   berlin.standzeit
WHERE  berlin.routes.id = berlin.standzeit.id;


CREATE INDEX idx_berlin_routes_id ON berlin.routes(id);
