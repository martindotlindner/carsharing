﻿COPY(
SELECT provider, date_trunc('day',TIMESTAMPSTART) AS Date, COUNT(DISTINCT vehicleid) AS Vehicles, SUM(sales)
FROM berlin.routes 
-- WHERE TIMESTAMPSTART < '2015-07-01'::timestamp AND TIMESTAMPSTART > '2015-05-01'::timestamp
GROUP BY provider, Date)
--TO 'C:/Program Files/PostgreSQL/9.5/data/Sales_Vehicles_head.csv' DELIMITER ';' CSV HEADER;
TO '/tmp/Sales_Vehicles.csv' DELIMITER ';' CSV HEADER;