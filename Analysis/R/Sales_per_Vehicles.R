library(ggplot2)
library(plyr)

setwd("C:/Program Files/PostgreSQL/9.5/data/")
# setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data/")


sales_vehicle <- read.table("Sales_Vehicles_City.csv",sep = ";",header = TRUE)
sales_vehicle$salespervehicle <- sales_vehicle$sum/sales_vehicle$vehicles
sales_vehicle$date <- as.POSIXct(strptime(sales_vehicle$date, format = "%Y-%m-%d %H:%M:%S"))

sales_vehicle$day <- weekdays(as.Date(sales_vehicle$date))
sales_vehicle$shortdate <- strftime(sales_vehicle$date, format="%Y-%m")


#sales_mean <- ddply(sales_vehicle, .(shortdate,provider,city), summarize, SalesperDay = mean(salespervehicle,na.rm = TRUE))
sales_mean <- ddply(sales_vehicle, .(provider,city), summarize, SalesperDay = mean(salespervehicle,na.rm = TRUE))
vehicles_mean <- ddply(sales_vehicle, .(provider,city), summarize, Vehicles = mean(vehicles,na.rm = TRUE))

sales_mean <- sales_mean[-which(sales_mean$city == ""), ]
newrow <- c("DRIVENOW", "Frankfurt", NA)
sales_mean <- rbind(sales_mean, newrow)
sales_mean$SalesperDay <- as.numeric(sales_mean$SalesperDay)

ggplot(data=sales_mean, aes(x=city, y=SalesperDay)) +
  geom_bar(aes(fill = provider),colour = "black", position = "dodge", stat="identity")



sales_mean$shortdate <- as.yearmon(sales_mean$shortdate)
sales_mean$shortdate <- as.POSIXct(sales_mean$shortdate)
ggplot(sales_mean, aes(shortdate,SalesperDay,colour = provider)) +
  geom_line()

