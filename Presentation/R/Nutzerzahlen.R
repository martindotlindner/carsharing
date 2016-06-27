library(ggplot2)
## Directory festlegen
setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data/")
Nutzerzahlen <- read.csv("Nutzerzahlen.csv", header = TRUE, sep = ";")
Nutzerzahlen$Datum <- strptime(Nutzerzahlen$Datum, format = "%d.%m.%Y")

ggplot(Nutzerzahlen, aes(Datum, Nutzer,colour = Provider))+
  geom_line()+
  geom_point()