COPY(
SELECT provider, date_trunc('day',TIMESTAMPSTART) AS Date, COUNT(DISTINCT vehicleid) AS Vehicles, Count(*)
FROM berlin.routes 
GROUP BY provider, Date)
TO '/tmp/Auslastung.csv' (format csv);
