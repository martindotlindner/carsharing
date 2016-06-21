library(ggplot2)
library(plyr)
library(zoo)
#setwd("C:/Program Files/PostgreSQL/9.5/data/")
setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data/")


sales_vehicle <- read.table("Sales_Vehicles.csv",sep = ";",header = TRUE)
sales_vehicle$salespervehicle <- sales_vehicle$sum/sales_vehicle$vehicles
sales_vehicle$date <- as.POSIXct(strptime(sales_vehicle$date, format = "%Y-%m-%d %H:%M:%S"))

sales_vehicle$day <- weekdays(as.Date(sales_vehicle$date))
sales_vehicle$shortdate <- strftime(sales_vehicle$date, format="%Y-%m")

ggplot(sales_vehicle,aes(date,salespervehicle, colour = provider)) +
  geom_line()

sales_sum <- ddply(sales_vehicle, .(shortdate,provider), summarize, SalesperDay = mean(salespervehicle,na.rm = TRUE))


sales_sum$shortdate <- as.yearmon(sales_sum$shortdate)
sales_sum$shortdate <- as.POSIXct(sales_sum$shortdate)
ggplot(sales_sum, aes(shortdate,SalesperDay,colour = provider)) +
  geom_line()

