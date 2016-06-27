### Plot Buchungen im Tagesverlauf, Group by 'Day of the Week' ###
#Import#
library(ggplot2)
library(intervals)
library(xtable)
options(xtable.floating = TRUE)
options(xtable.timestamp = "")


setwd("C:/Program Files/PostgreSQL/9.5/data/")
Auslastung <- read.csv("Auslastung_Berlin.csv",header=FALSE)



colnames(Auslastung) <- c("Provider", "Date", "Vehicles", "PeriodeOfUse")
Auslastung$Date <- strptime(Auslastung$Date, format = "%Y-%m-%d %H:%M:%S")
Auslastung$PeriodeOfUse <- Auslastung$PeriodeOfUse/3600
Auslastung$Auslastung <- Auslastung$PeriodeOfUse/Auslastung$Vehicles

pdf("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Latex/Paper/images/mean_utilization.pdf",
    width = 10, height = 6)
ggplot(Auslastung, aes(x = Date, y = Auslastung, colour = Provider)) +
  geom_line()+
  xlab("Date")+
  ylab("Mean utilization in h/d")+
  theme_light()+
  scale_colour_discrete(name = "Provider (Vehicles)",
                        breaks=c("DRIVENOW", "CAR2GO", "MULTICITY"),
                        labels = c("Drivenow (829)", "Car2Go (939)", "Multicity (168)"))
ggsave("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Latex/Paper/images/mean_utilization.pdf",
    width = 10, height = 6)


mean_vehicled <- aggregate(Auslastung[,5], by = list(Auslastung$Provider), FUN = mean)
print(xtable(mean_vehicled,label = "Mean number of vehicles grouped by provider "), include.rownames = FALSE)

