library(ggplot2)
library(plyr)
library(Hmisc)

setwd("C:/Program Files/PostgreSQL/9.5/data/")

#Insert sales per hexagon
sales <- read.table("hexagon_sum_sales.csv",sep = ";",header = TRUE)
sales_order <- arrange(sales, sum_sales_day)
sales_order$x_seq <- seq(1,length(sales_order$gid))

#Insert population density per hexagon
pop_density <- read.table("hexagon_population.csv",sep = ";",header = TRUE)
#pop_density$pop_density_scale <- scale(pop_density$Pop_Densitymean)
#pop_density$pop_density_peer_scale <- scale(pop_density$Pop_Density_Peermean)
#pop_density$peergroup_percent_scale <- scale(pop_density$Peergroup_Percentmean)

#Insert stops from GTFS per hexagon
stops <- read.table("hexagon_sum_arrivals.csv",sep = ";",header = TRUE)

#Insert restaurant per hexagon
restaurants <- read.table("hexagon_count_restaurant.csv",sep = ";",header = TRUE)


#Insert aerodroms from OSM per hexagon
aerodroms <- read.table("hexagon_aerodroms.csv",sep = ";",header = TRUE)


#Insert IKEA from OSM per hexagon
ikea <- read.table("hexagon_ikea.csv",sep = ";",header = TRUE)
## Scaling IKEA: population of city/number of shops

#Insert Shopping Malls from OSM/Wikipedia per hexagon
mall <- read.table("hexagon_mall.csv",sep = ";",header = TRUE)
colnames(mall) <- c("gid","prop_mall_area", "mall_area","count_mall")


#Insert Parks (recreation) from OSM per hexagon
park <-  read.table("hexagon_park.csv",sep = ";",header = TRUE)
colnames(park) <- c("gid","park_area","count_park")

#Insert Parking spaces (points) from OSM per hexagon
parking_point <-  read.table("hexagon_parking.csv",sep = ";",header = TRUE)
colnames(parking_point) <- c("gid","count_parking_spaces","capacity_parking")

#Insert Parking spaces (points) from OSM per hexagon
parking_area <-  read.table("hexagon_parking_area.csv",sep = ";",header = TRUE)
colnames(parking_area) <- c("gid","parking_area","count_parking_area")
parking_area$parking_area <- parking_area$parking_area*1000000


#Merging all criteria
hex_merge <- join_all(list(sales_order,stops, restaurants, aerodroms,ikea,pop_density,mall,park,parking_point,parking_area), by = c("gid"), type = 'left')
hex_merge[is.na(hex_merge)] <- 0



#Utility Analysis
hex_merge$score <- (hex_merge$restaurants_scale*0.3) + (hex_merge$pop_density_peer_scale*0.3) + (hex_merge$ikea_scale * 0.2) + (hex_merge$sum_arrivals_scale * 0.2)
hex_merge$score_abs <- ((hex_merge$count_restaurant*10)*0.3) + 
  (hex_merge$Pop_Density_Peermean/5*0.2) + 
  (hex_merge$count_ikea*1000*0.2) + 
  (hex_merge$sum_arrivals/10 * 0.1) + 
  (hex_merge$sum_passengers/10000 * 0.1) +
  (hex_merge$prop_shoppingarea * 0.1)

ggplot(hex_merge, aes(x = x_seq))+
      geom_line(aes(y=sum_sales_day,colour = "Sales"))+
   #   geom_line(aes(y=score_abs,colour = "Variable"))+
      geom_point(aes(y=prop_shoppingarea/30),na.rm = TRUE)+
      ylab("Sales per hexagon per day and count of cafes per hexagon")+
      xlab("Hexagon ID")
                    

ggplot(hex_merge, aes(x = x_seq))+
 # geom_line(aes(y=sum_sales_day,colour = "Sales"))+
  geom_line(aes(y=sales_scale,colour = "Sales"))+
 # geom_line(aes(y=sum_arrivals_scale,colour = "Arrivals"))+
 # geom_line(aes(y=restaurants_scale,colour = "Restaurants"))+
  geom_line(aes(y=score,colour = "Score"))+
   geom_line(aes(y=pop_density_peer_scale,colour = "Score"))+
#  geom_point(aes(y=sum_passengers,colour = "Passengers"))+
#  geom_point(aes(y=ikea_scale,colour = "IKEA"))+
  ylab("Sales per hexagon per day and count of cafes per hexagon")+
  xlab("Hexagon ID")

#Export as csv file
write.table(hex_merge, file = "hex_merge.csv", sep = ";", na = "NA", dec = ".")

cor(hex_merge$sum_sales_day,hex_merge$restaurants_scale,method = "spearman",use="pairwise.complete.obs")

cor(hex_merge$sum_sales_day,hex_merge$sum_arrivals_scale,method = "spearman",use="pairwise.complete.obs")
cor(hex_merge$sum_sales_day,hex_merge$score,method = "spearman",use="pairwise.complete.obs")
cor(hex_merge$sum_sales_day,hex_merge$pop_density_scale,method = "spearman",use="pairwise.complete.obs")
cor(hex_merge$sum_sales_day,hex_merge$pop_density_scale,method = "spearman",use="pairwise.complete.obs")

cor(hex_merge[c(3,7:9,24:26)], use="complete.obs", method="kendall") 

cor_data <- hex_merge[c(3,7:9,24:26)]
cor_df <- cor(cor_data,method = "spearman",use="pairwise.complete.obs")
corrgram(cor_df, order = TRUE, lower.panel = panel.shade, upper.panel = panel.pie, 
         text.panel = panel.txt, main = "Correlation structural data")

shapiro.test(hex_merge$Pop_Densitymean)
histogram(hex_merge$Pop_Densitymean)
