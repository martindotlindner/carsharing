library(ggplot2)
setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data")
hours <- read.csv("hour.csv",header=FALSE)
colnames(hours) <- c("Counts","Time")
hours$Time <- strptime(hours$Time, format = "%H")

ggplot(hours, aes(Time, Counts)) + 
  geom_line(colour = "red") +
  xlab("Zeit")


dow <- read.csv("dow.csv",header=FALSE)
colnames(dow) <- c("Count","Weekday")
dow$Wochentag <- c("Sunday","Monday",'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')
barplot(height = dow$Count, 
        xlab = "Day of the Week",
        ylab = "Routes",
        names.arg = dow$Wochentag)


### Plot Buchungen im Tagesverlauf, Group by 'Day of the Week' ###
#Import#
library(ggplot2)
setwd("C:/Program Files/PostgreSQL/9.5/data/")
#Nutzung_Wochenverlauf <- read.csv("Nutzung_HOUR_DOW.csv",header=FALSE)
Nutzung_Wochenverlauf <- read.csv("CAR2GO_DOW.csv",header=FALSE)

#Spaltennamen festlegen#
colnames(Nutzung_Wochenverlauf) <- c("Counts","DOW", "Provider","Hour")

#Stunden in Zeitformat umwandeln
Nutzung_Wochenverlauf$Houriso <- strptime(Nutzung_Wochenverlauf$Hour, format = "%H")
Nutzung_Wochenverlauf$Houriso <- strftime(Nutzung_Wochenverlauf$Hour, "%H")



trans <- c("Monday",'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',"Sunday")
names(trans) <- c(0,1,2,3,4,5,6)
Nutzung_Wochenverlauf$Wochentag <- trans[as.character(Nutzung_Wochenverlauf$DOW)]


ggplot(Nutzung_Wochenverlauf, aes(x = DOW, y = Counts, colour = Provider)) +
  geom_line()+
  xlab("Tageszeit")+
  ylab("Anzahl Buchungen")
  #scale_colour_discrete(breaks=c("Sunday","Monday",'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'))+
  #xlim(0,23)