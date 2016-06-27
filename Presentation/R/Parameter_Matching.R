library(ggplot2)
library(plyr)

setwd("C:/Program Files/PostgreSQL/9.5/data2/")

sales <- read.table("Sales_Starts_Hexagon_Total.csv",sep = ",",header = FALSE)
colnames(sales) <- c("ID", "geom", "sales_sum")
sales$sales_sum <- sales$sales_sum/100000
sales_order <- arrange(sales, sales_sum)
sales_order$x_seq <- seq(1,length(sales_order$ID))


POI <- read.table("POI_Cafe_Hexagon.csv",sep = ",",header = FALSE)
colnames(POI) <- c("ID", "geom", "count_cafe")

hex_merge <- merge(sales_order,POI,by="ID")

ggplot(sales_order, aes(x_seq, sales_sum))+
  geom_line()

ggplot(hex_merge, aes(x = x_seq))+
  geom_line(aes(y=sales_sum,colour = "Sales"))+
  geom_line(aes(y=count_cafe,colour = "Cafes"))+
  scale_colour_manual("", 
                      breaks = c("Sales", "Cafes"),
                      values = c("red", "blue")) +
  theme(legend.justification=c(0,0), legend.position=c(0,0.8))+
  ylab("Sales in 100.000 Euro and count of cafes per hexagon")+
  xlab("Hexagon ID")
  


