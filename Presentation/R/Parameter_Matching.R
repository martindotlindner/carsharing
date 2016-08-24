library(ggplot2)
library(plyr)
library(Hmisc)

setwd("C:/Program Files/PostgreSQL/9.5/data/")

#Insert sales per hexagon
sales <- read.table("hexagon_sum_sales.csv",sep = ";",header = TRUE)
sales_order <- arrange(sales, sum_sales_day)
sales_order$x_seq <- seq(1,length(sales_order$gid))

#Insert stops from GTFS per hexagon
stops <- read.table("hexagon_sum_arrivals.csv",sep = ";",header = TRUE)
stops$sum_arrivals_scale <- stops$sum_arrivals/10
stops$sum_routes_scale <- stops$sum_routes*20
stops$stops_scale <- stops$count_stops*100

#Insert restaurant per hexagon
restaurants <- read.table("hexagon_count_restaurant.csv",sep = ";",header = TRUE)
restaurants$restaurants_scale <- restaurants$count_restaurant*100


#Insert aerodroms from OSM per hexagon
aerodroms <- read.table("hexagon_aerodroms.csv",sep = ";",header = TRUE)
aerodroms$aerodroms_scale <- aerodroms$sum_passengers/6000
 

hex_merge <- join_all(list(sales_order,stops, restaurants, aerodroms), by = c("gid", "st_astext"), type = 'left')

#Insert IKEA from OSM per hexagon
ikea <- read.table("hexagon_ikea.csv",sep = ";",header = TRUE)
## Scaling IKEA: population of city/number of shops
ikea$ikea_scale <- ikea$count_ikea*3520031/3/1000


#Merging all criteria
hex_merge <- join_all(list(sales_order,stops, restaurants, aerodroms,ikea), by = c("gid", "st_astext"), type = 'left')
hex_merge[is.na(hex_merge)] <- 0



#Utility Analysis
hex_merge$score <- (hex_merge$restaurants_scale*0.6) + (hex_merge$ikea_scale * 0.2) + (hex_merge$sum_arrivals_scale * 0.2)


ggplot(hex_merge, aes(x = x_seq))+
  geom_line(aes(y=sum_sales_day,colour = "Sales"))+
 # geom_line(aes(y=sum_arrivals_scale,colour = "Arrivals"))+
  geom_line(aes(y=restaurants_scale,colour = "Restaurants"))+
  geom_line(aes(y=score,colour = "Score"))+
#  geom_point(aes(y=sum_passengers,colour = "Passengers"))+
#  geom_point(aes(y=ikea_scale,colour = "IKEA"))+
  ylab("Sales per hexagon per day in € and count of cafes per hexagon")+
  xlab("Hexagon ID")

cor(hex_merge$sum_sales_day,hex_merge$restaurants_scale,method = "spearman",use="pairwise.complete.obs")

cor(hex_merge$sum_sales_day,hex_merge$sum_arrivals_scale,method = "spearman",use="pairwise.complete.obs")
cor(hex_merge$sum_sales_day,hex_merge$score,method = "spearman",use="pairwise.complete.obs")


