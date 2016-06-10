library(RPostgreSQL)
library(ggplot2)


# Establish connection to PoststgreSQL using RPostgreSQL
drv <- dbDriver("PostgreSQL")

# Connection settings
con <- dbConnect(drv, dbname="carsharing",host="localhost",port=5433,user="postgres",password="CS4ever" )
#readOGR("PG:dbname=gps_tracking_db host=localhost", layer = "main.gps_data_animals")




q = "SELECT * FROM information_schema.columns WHERE table_schema = 'berlin' AND table_name = 'ewr2015_plr' AND data_type = 'double precision';"
rs = dbSendQuery(con,q)
pop_info = fetch(rs,n=-1)
pop_column <- pop_info$column_name



correlation_df <- data.frame(spearman = NA, pearson = NA, key_value = NA, avg_pop = NA)
schema = "berlin"
table = "ewr2015_plr"

#for (i in 1:nrow(pop_column)){
for (i in 1:30){  
  column <- pop_column[i]
  name <- paste0(schema,".",table,".",column)
  
  sqlcommand = paste0("SELECT berlin.hexagon_1km.gid, ST_AsText(berlin.hexagon_1km.geom), AVG(",name, ") FROM berlin.hexagon_1km, berlin.ewr2015_plr
    WHERE ST_Intersects(berlin.ewr2015_plr.geom,berlin.hexagon_1km.geom) GROUP BY berlin.hexagon_1km.gid ;" )
  
  
  rs = dbSendQuery(con,sqlcommand)
  POP = fetch(rs,n=-1)
  

  if (nrow(POP) == 0) {}
  else{
    colnames(POP) <- c("gid", "geom", "avg_pop")
    
    cor_df <- merge(Sales,POP,by.x = "ID_Hexagon",by.y = "gid", all.x = TRUE)
    cor_df[is.na(cor_df)] <- 0
    correlation_df[i,1] <- cor(cor_df$Count_Sales,cor_df$avg_pop,method = "spearman")
    correlation_df[i,2] <- cor(cor_df$Count_Sales,cor_df$avg_pop,method = "pearson")
    correlation_df[i,3] <- column

  }
}
dbDisconnect(con)

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))}

correlation_df$years <- substrRight(correlation_df$key_value, 2)
substr(correlation_df)
correlation_plot <- correlation_df[-c(1:3),]
correlation_plot$years <- as.numeric(correlation_plot$years)

ggplot(correlation_plot, aes(years)) +
  geom_line(aes(y = spearman, colour = "Spearman")) + 
  geom_line(aes(y = pearson, colour = "Pearson"))+
  xlab("age-set")+
  ylab("Correlation")

  