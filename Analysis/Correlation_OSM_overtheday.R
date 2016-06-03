library(RPostgreSQL)
library(ggplot2)


# Establish connection to PoststgreSQL using RPostgreSQL
drv <- dbDriver("PostgreSQL")

# Connection settings
con <- dbConnect(drv, dbname="carsharing",host="localhost",port=5433,user="postgres",password="CS4ever" )


# POI importieren
schema = "berlin"
table = "osm_point"
key <- "amenity"
value <- "cafe"
name <- paste0(schema,".",table,".",key," = '",value,"'")

sqlcommand = paste0("SELECT berlin.hexagon_1km.gid, ST_AsText(berlin.hexagon_1km.geom), count(*) FROM berlin.hexagon_1km, berlin.osm_point WHERE ST_Within(berlin.osm_point.geom_25833,berlin.hexagon_1km.geom) AND ",name," GROUP BY berlin.hexagon_1km.gid;")

rs = dbSendQuery(con,sqlcommand)
POI = fetch(rs,n=-1)

correlation_df <- data.frame(spearman = NA, pearson = NA, key_value = NA, count_poi = NA)

hour <- seq(0,23)
for (i in 1:24){  
  hour_sql <- hour[i]
  
  sqlcommand = paste0("SELECT berlin.hexagon_1km.gid, ST_AsText(berlin.hexagon_1km.geom), SUM(berlin.routes.sales) FROM berlin.hexagon_1km, berlin.routes WHERE ST_Within(berlin.routes.geom_start,berlin.hexagon_1km.geom) AND berlin.routes.hour = ", hour_sql, " GROUP BY berlin.hexagon_1km.gid ;" )
  
  rs = dbSendQuery(con,sqlcommand)
  Sales = fetch(rs,n=-1)
  
  
  #if (nrow(POI_Time) == 0) {}
  #else{
    colnames(Sales) <- c("gid", "geom", "Count_Sales")
    
    cor_df <- merge(Sales,POI,by.x = "gid",by.y = "gid", all.x = TRUE)
    cor_df[is.na(cor_df)] <- 0
    correlation_df[i,1] <- cor(cor_df$Count_Sales,cor_df$count,method = "spearman")
    correlation_df[i,2] <- cor(cor_df$Count_Sales,cor_df$count,method = "pearson")
    correlation_df[i,3] <- as.numeric(hour_sql)
    
 # }
}
dbDisconnect(con)

ggplot(correlation_df, aes(key_value)) +
  geom_line(aes(y = spearman, colour = "Spearman")) + 
  geom_line(aes(y = pearson, colour = "Pearson"))+
  xlab("Hours")+
  ylab("Correlation Coefficient")+
  ggtitle("Correlation coefficient of POI 'Cafe' and sales per hexagon over the day")