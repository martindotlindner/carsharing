COPY(
SELECT provider, date_trunc('day',TIMESTAMPSTART) AS Date, COUNT(DISTINCT vehicleid) AS Vehicles, SUM(sales)
FROM berlin.routes 
GROUP BY provider, Date)
TO 'C:/Program Files/PostgreSQL/9.5/data/Sales_Vehicles_head.csv' DELIMITER ';' CSV HEADER;
