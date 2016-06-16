library(ggplot2)
library(plyr)
setwd("C:/Program Files/PostgreSQL/9.5/data/")

sales_vehicle <- read.table("Sales_Vehicles_head.csv",sep = ";",header = TRUE)
sales_vehicle$salespervehicle <- sales_vehicle$sum/sales_vehicle$vehicles
sales_vehicle$date <- strptime(sales_vehicle$date, format = "%Y-%m-%d %H:%M:%S")
sales_vehicle$day <- weekdays(as.Date(sales_vehicle$date))

ggplot(sales_vehicle,aes(date,salespervehicle, colour = provider)) +
  geom_line()

ddply(sales_vehicle, .(provider), summarize, SalesperVehicleperDay = mean(salespervehicle,na.rm = TRUE))
