library(ggplot2)
library(plyr)
#setwd("C:/Program Files/PostgreSQL/9.5/data/")
setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data/")


sales_vehicle <- read.table("Sales_after.csv",sep = ";",header = TRUE)
sales_vehicle$salespervehicle <- sales_vehicle$sum/sales_vehicle$vehicles
sales_vehicle$date <- strptime(sales_vehicle$date, format = "%Y-%m-%d %H:%M:%S")
sales_vehicle$day <- weekdays(as.Date(sales_vehicle$date))

ggplot(sales_vehicle,aes(date,salespervehicle, colour = provider)) +
  geom_line()

after <- ddply(sales_vehicle, .(date,provider), summarize, SalesperVehicleperDay = mean(salespervehicle,na.rm = TRUE))
tapply(sales_vehicle$salespervehicle, month(mdy_hms(sales_vehicle$date)), mean)

date <- seq(from = as.Date("2010/5/30"), by="week", length=10) ## Example data

cuts <- seq(from = as.Date("2000/7/1"), by="year", length=13) 
labs <- paste0("FY", 1:12)

cut_data <- cut(date, breaks = cuts, labels = labs)
