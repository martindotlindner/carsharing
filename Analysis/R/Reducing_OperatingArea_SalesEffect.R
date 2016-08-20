library(RPostgreSQL)
library(ggplot2)


# Establish connection to PoststgreSQL using RPostgreSQL
drv <- dbDriver("PostgreSQL")

# Connection settings
con <- dbConnect(drv, dbname="Carsharing",host="localhost",port=5432,user="postgres",password="" )
#readOGR("PG:dbname=gps_tracking_db host=localhost", layer = "main.gps_data_animals")

#Test, if table exists 
dbExistsTable(con, c("berlin", "routes"))

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
sales_shrink = data.frame(Percent = percent_value[1], Sum_Sales = 0, Area = 0)

for (i in 1:length(percent_value)){
  #for (i in 1:1){
  q = paste0("SELECT *, avg_wait/avg_duration AS Unefficiency_Index FROM berlin.avg_wait_duration_hexagon_oa
ORDER BY Unefficiency_Index LIMIT (select (count(*)*", percent_value[i], ")::int from berlin.avg_wait_duration_hexagon_oa);")
  rs = dbSendQuery(con,q)
  hexagon_shrink = fetch(rs,n=-1)
  sales_shrink[i,1] = percent_value[i]
  sales_shrink[i,2] = sum(hexagon_shrink$sales_sum)
  sales_shrink[i,3] = nrow(hexagon_shrink)
}

for (i in 1:length(percent_value)){
  #for (i in 1:1){
  q = paste0("DROP TABLE if exists berlin.hexagon_oa_shrink;
  SELECT *, avg_wait/avg_duration AS Unefficiency_Index INTO berlin.hexagon_oa_shrink FROM berlin.avg_wait_duration_hexagon_oa
             ORDER BY Unefficiency_Index LIMIT (select (count(*)*", percent_value[i], ")::int from berlin.avg_wait_duration_hexagon_oa);")
  rs = dbSendQuery(con,q)
  q = paste0("SELECT SUM(berlin.routes.Sales) FROM berlin.routes, berlin.hexagon_oa_shrink
WHERE ST_Within(berlin.routes.geom_start,berlin.hexagon_oa_shrink.geom) AND ST_Within(berlin.routes.geom_end,berlin.hexagon_oa_shrink.geom);")
  rs = dbSendQuery(con,q)
  hexagon_shrink = fetch(rs,n=-1)
  sales_shrink[i,1] = percent_value[i]
  sales_shrink[i,2] = hexagon_shrink
}


sales_shrink$Area <- seq(217,0,by = -21.7)
sales_shrink$SalesperArea <- sales_shrink$Sum_Sales/sales_shrink$Area
sales_shrink[is.na(sales_shrink)] <- 0

ggplot(sales_shrink, aes(x = Percent, y = SalesperArea))+
  geom_line()+
  scale_x_reverse()+
  xlab("Remaining optimized operating area in %")+
  ylab("Absolut sales per area in €")

dbDisconnect(con)



