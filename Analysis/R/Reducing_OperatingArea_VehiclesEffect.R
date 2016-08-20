library(RPostgreSQL)
library(ggplot2)


# Establish connection to PoststgreSQL using RPostgreSQL
drv <- dbDriver("PostgreSQL")

# Connection settings
con <- dbConnect(drv, dbname="Carsharing",host="localhost",port=5432,user="postgres",password="" )

#Test, if table exists 
dbExistsTable(con, c("berlin", "routes"))

q = "DROP TABLE if exists berlin.sum_wait_duration_hexagon;
SELECT berlin.berlin_hexagon_1km.gid, AVG(EXTRACT(EPOCH FROM berlin.routes.wait)/3600)  AS avg_wait, AVG(EXTRACT(EPOCH FROM berlin.routes.duration)/3600) AS avg_duration,(SUM(EXTRACT(EPOCH FROM berlin.routes.wait)/3600))/31  AS sum_wait_day, (SUM(EXTRACT(EPOCH FROM berlin.routes.duration)/3600))/31 AS sum_duration_day, count(*), SUM(sales) AS Sales_Sum
INTO berlin.sum_wait_duration_hexagon
 FROM berlin.berlin_hexagon_1km, berlin.routes
 WHERE ST_Within(berlin.routes.geom_end,berlin.berlin_hexagon_1km.geom) AND  berlin.routes.timestampstart < '2015-09-01'::timestamp AND berlin.routes.timestampstart > '2015-08-01'::timestamp
GROUP BY berlin.berlin_hexagon_1km.gid;"
rs = dbSendQuery(con,q)


q = "SELECT COUNT(DISTINCT vehicleid) AS Vehicles, date_trunc('day',timestampstart) as Day, SUM(EXTRACT(EPOCH FROM berlin.routes.wait)/3600)  AS sum_wait, SUM(EXTRACT(EPOCH FROM berlin.routes.duration)/3600) AS sum_duration
FROM berlin.routes WHERE timestampstart < '2015-09-01'::timestamp AND timestampstart > '2015-07-30'::timestamp
GROUP BY Day;"
rs = dbSendQuery(con,q)
count_vehicles_time <- fetch(rs,n=-1)
count_vehicles_mean <- round(mean(count_vehicles$vehicles),0)
count_vehicles_time$sum_total <- count_vehicles_time$sum_wait+count_vehicles_time$sum_duration
count_vehicles_time$timepervehicle <- count_vehicles_time$sum_total/count_vehicles_time$vehicles
timepervehicle_mean <- round(mean(count_vehicles_time$timepervehicle),2)

percent_value <- seq(1,0,by = -0.1)
area_shrink = data.frame(Percent = percent_value[1], Vehicles = 0, Sales_Hex = 0, Sales_Routes = 0)

for (i in 1:length(percent_value)){
#  for (i in 7:7){
  q = paste0("DROP TABLE if exists berlin.summary_hexagon_oa_shrink;
              SELECT *, avg_wait/avg_duration AS Unefficiency_Index INTO berlin.summary_hexagon_oa_shrink  FROM berlin.summary_hexagon_oa
             ORDER BY Unefficiency_Index LIMIT (select (count(*)*", percent_value[i], ")::int from berlin.summary_hexagon_oa);
             SELECT *, avg_wait/avg_duration AS Unefficiency_Index  FROM berlin.summary_hexagon_oa
             ORDER BY Unefficiency_Index LIMIT (select (count(*)*", percent_value[i], ")::int from berlin.summary_hexagon_oa);")
  rs = dbSendQuery(con,q)
  hexagon_shrink = fetch(rs,n=-1)
  hexagon_shrink$req_vehicles <- (hexagon_shrink$sum_wait_day + hexagon_shrink$sum_duration_day)/timepervehicle_mean
  area_shrink[i,1] = percent_value[i]
  area_shrink[i,2] = sum(hexagon_shrink$req_vehicles)
  area_shrink[i,3] = sum(hexagon_shrink$sales_sum_day)

  q = "SELECT SUM(berlin.routes.Sales) FROM berlin.routes, berlin.summary_hexagon_oa_shrink
  WHERE ST_Within(berlin.routes.geom_start,berlin.summary_hexagon_oa_shrink.geom) AND 
ST_Within(berlin.routes.geom_end,berlin.summary_hexagon_oa_shrink.geom) AND  berlin.routes.timestampstart < '2015-09-01'::timestamp AND berlin.routes.timestampstart > '2015-08-24'::timestamp;"
  rs = dbSendQuery(con,q)
  hexagon_shrink = fetch(rs,n=-1)
  area_shrink[i,4] = hexagon_shrink
  
}

area_shrink$SalesperVehicle <- area_shrink$Sales/area_shrink$Vehicles
ggplot(area_shrink, aes(x = Percent, y = SalesperVehicle))+
  geom_line()+
  scale_x_reverse()+
  xlab("Remaining optimized operating area in %")+
  ylab("Required vehicles")

dbDisconnect(con)



