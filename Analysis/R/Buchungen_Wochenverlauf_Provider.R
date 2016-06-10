### Plot Buchungen im Wochenverlauf, Group by 'Day of the Week' ###

#Import Data#
library(ggplot2)
# Set working directory in Windows
setwd("C:/Program Files/PostgreSQL/9.5/data/")

# Set working directory in Linux
#setwd("/tmp")

CAR2GO <- read.csv("CAR2GO_DOW_Hour.csv",header=FALSE)
colnames(CAR2GO) <- c("Count", "DOW", "Hour")
CAR2GO$Percent <- (CAR2GO$Count/sum(CAR2GO$Count))*100
CAR2GO$HoursInWeek <- seq(1:length((CAR2GO$Count)))
CAR2GO$Provider <- rep("CAR2GO", times = length(CAR2GO$DOW))

DRIVENOW <- read.csv("DRIVENOW_DOW_Hour.csv",header=FALSE)
colnames(DRIVENOW) <- c("Count", "DOW", "Hour")
DRIVENOW$Percent <- (DRIVENOW$Count/sum(DRIVENOW$Count))*100
DRIVENOW$HoursInWeek <- seq(1:length((DRIVENOW$Count)))
DRIVENOW$Provider <- rep("DRIVENOW", times = length(CAR2GO$DOW))

Wochenverlauf <- rbind(CAR2GO, DRIVENOW)
## Combine DOW and Hours to strptime ##

#Count_DOW$DOW <- Count_DOW$DOW-1
#Count_DOW$Timemerge <- paste(Count_DOW$DOW, Count_DOW$Hour, sep = "/" )
#Count_DOW$Time <- strptime(Count_DOW$Timemerge, "%W/%H")

Count_DOW$HoursInWeek <- seq(1:length((DRIVENOW$Count)))


ggplot(Wochenverlauf, aes(HoursInWeek, Count, colour = Provider))+
  geom_line()+
  theme_light()+
  xlab("Zeit (Stunden im Wochenverlauf)")+
  ylab("Anzahl Buchungen")
ggsave("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Latex/Paper/images/wochenverlauf_provider.pdf",
       width = 10, height = 6)

