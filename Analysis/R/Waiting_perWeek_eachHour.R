library(RPostgreSQL)


# Establish connection to PoststgreSQL using RPostgreSQL
drv <- dbDriver("PostgreSQL")

# Connection settings
con <- dbConnect(drv, dbname="Carsharing",host="localhost",port=5432,user="postgres",password="MuC4ever!" )
#readOGR("PG:dbname=gps_tracking_db host=localhost", layer = "main.gps_data_animals")

#Test, if table exists 
dbExistsTable(con, c("berlin", "routes"))

times <- seq(as.POSIXct("2000-01-01 00:00:00"), as.POSIXct("2000-01-01 23:00:00"), by="hour")
t <- strftime(times, format="%H:%M:%S")

q = (" SELECT gid, ST_AsText(berlin.hexagon_empty.geom) FROM berlin.hexagon_empty;")
rs = dbSendQuery(con,q)
Hexagon = fetch(rs,n=-1)

Waiting_Week_ls <- list()


for (i in 1:24){
  q = paste0("SELECT berlin.hexagon_empty.gid, count(*)/60.0 AS sum_vehicles_time FROM berlin.hexagon_empty, berlin.routes WHERE ST_Within(berlin.routes.geom_end,berlin.hexagon_empty.geom) AND timestampend::time <= '",t[i],"'::time AND nextstart::time > '",t[i],"'::time GROUP BY berlin.hexagon_empty.gid;")
  rs = dbSendQuery(con,q)
  Waiting_Week = fetch(rs,n=-1)
  
  if (nrow(Waiting_Week) == 0) {
    Waiting_Week <- data.frame(0,0)
    colnames(Waiting_Week) <- c("ID", t[i])
    
  }
  else{
    colnames(Waiting_Week) <- c("ID", t[i])
    Waiting_Week_ls[[i]] <- Waiting_Week
    }
}
dbDisconnect(con)

data <- Reduce(function(x, y) merge(x, y, all=T), Waiting_Week_ls, accumulate=F)
Wait_Merge <- merge(Hexagon, data, by.x = "gid", by.y = "ID", all.y = TRUE)

write.table(Wait_Merge, file = "C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data/Waiting_perWeek_eachHour.csv" )
