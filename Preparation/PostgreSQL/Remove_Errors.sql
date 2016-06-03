-- Alle Buchungen von Multicity löschen
DELETE FROM berlin.routes
WHERE provider = 'MULTICITY';

-- Fehlerhafter Timestampstart am 2014-12-22 (event. alle Buchungen an diesem Tag löschen)
--DELETE FROM berlin.routes
--WHERE timestampstart = TIMESTAMP '2014-12-22 00:24:14' OR timestampstart = TIMESTAMP '2014-12-22 00:24:00';

--DELETE FROM berlin.routes
--WHERE date_trunc('day', TIMESTAMPSTART) = TIMESTAMP '2014-07-08' AND provider = 'DRIVENOW';


--Umrüsterfahrten löschen

DELETE FROM berlin.routes
WHERE streetstart = 'Umrüster DE' OR streetend = 'Umrüster DE' ;

-- Alle Fahrten mit Durchschnittsgeschwindigkeit > 100km/h entfernen UND Nutzungsdauer < 4min

DELETE FROM berlin.routes
WHERE mean_speed > 100 OR duration < Interval '00:04:00';