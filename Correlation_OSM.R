library(RPostgreSQL)


# Establish connection to PoststgreSQL using RPostgreSQL
drv <- dbDriver("PostgreSQL")

# Connection settings
con <- dbConnect(drv, dbname="carsharing",host="localhost",port=5433,user="postgres",password="CS4ever" )
#readOGR("PG:dbname=gps_tracking_db host=localhost", layer = "main.gps_data_animals")

#Test, if table exists 
dbExistsTable(con, c("berlin", "routes"))

q = "SELECT * FROM information_schema.columns WHERE table_schema = 'berlin' AND table_name = 'osm_point' AND data_type = 'character varying';"
rs = dbSendQuery(con,q)
osm_info = fetch(rs,n=-1)
osm_keys <- osm_info$column_name

osm_tables <- list()
for (i in 1:length(osm_keys)){
#for (i in 1:40){
q = paste0("SELECT count(*), ",osm_keys[i], " FROM berlin.osm_point GROUP BY ",osm_keys[i]," ORDER BY count desc;")
rs = dbSendQuery(con,q)
osm_table = fetch(rs,n=-1)
osm_table = cbind(osm_table,rep(osm_keys[i],length(osm_table[,1])))
colnames(osm_table) <- c("count","value", "key")
osm_tables[[i]] = osm_table
}

osm_key_value <- do.call(rbind.data.frame, osm_tables)
osm_key_value <- na.omit(osm_key_value)
osm_key_value_500 <- subset(osm_key_value, count > 2)

Sales <- read.table("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data/sales_starts_hexagon.csv",header=FALSE, dec=".",sep = ",")
colnames(Sales) <- c("ID_Hexagon", "geom", "Count_Sales")

correlation_df <- data.frame(spearman = NA, pearson = NA, key_value = NA, count_poi = NA)
schema = "berlin"
table = "osm_point"
for (i in 1:nrow(osm_key_value_500)){

key <- osm_key_value_500$key[i]
value <- osm_key_value_500$value[i]
name <- paste0(schema,".",table,".",key," = '",value,"'")

sqlcommand = paste0("SELECT berlin.hexagon_1km.gid, ST_AsText(berlin.hexagon_1km.geom), count(*) FROM berlin.hexagon_1km, berlin.osm_point WHERE ST_Within(berlin.osm_point.geom_25833,berlin.hexagon_1km.geom) AND ",name," GROUP BY berlin.hexagon_1km.gid;")

rs = dbSendQuery(con,sqlcommand)
POI = fetch(rs,n=-1)



  if (nrow(POI) == 0) {}
  else{
#colnames(POI) <- c("ID_Hexagon", "geom", "Count_POI")

cor_df <- merge(Sales,POI,by.x = "ID_Hexagon",by.y = "gid", all.x = TRUE)
cor_df[is.na(cor_df)] <- 0
correlation_df[i,1] <- cor(cor_df$Count_Sales,cor_df$count,method = "spearman")
correlation_df[i,2] <- cor(cor_df$Count_Sales,cor_df$count,method = "pearson")
correlation_df[i,3] <- paste(key,value,sep = "_")
correlation_df[i,4] <- osm_key_value_500$count[i]
}
}
dbDisconnect(con)