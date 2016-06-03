library(ggplot2)
setwd("/tmp/")

## Zeitreihe FFCS-Daten
Auslastung <- read.table("Auslastung.csv",
                         sep=",",
                         dec=".",
                         header = FALSE)
colnames(Auslastung) <- c("Provider", "Date", "Vehicles", "PeriodeOfUse")
Auslastung$Date <- strptime(Auslastung$Date, format = "%Y-%m-%d %H:%M:%S")
#Auslastung$Date <- strptime(Auslastung$Date, format = "%d.%m.%Y %H:%M:%S")
Auslastung$Auslastung <- Auslastung$PeriodeOfUse/Auslastung$Vehicles


Drivenow <- subset(Auslastung, Provider == 'DRIVENOW')
Drivenow_sd <- sd(Drivenow$Auslastung)
Drivenow_mean <- mean(Drivenow$Auslastung)
Drivenow_sd2_max <- Drivenow_mean + Drivenow_sd*3
Drivenow_sd2_min <- Drivenow_mean - Drivenow_sd*3

Drivenow_Error_max <- subset(Drivenow, Auslastung > Drivenow_sd2_max)
Drivenow_Error_min <- subset(Drivenow, Auslastung < Drivenow_sd2_min)

Car2Go <- subset(Auslastung, Provider == 'CAR2GO')
Car2Go_sd <- sd(Car2Go$Auslastung)
Car2Go_mean <- mean(Car2Go$Auslastung)
Car2Go_sd2_max <- Car2Go_mean + Car2Go_sd*3
Car2Go_sd2_min <- Car2Go_mean - Car2Go_sd*3

Car2Go_Error_max <- subset(Car2Go, Auslastung > Car2Go_sd2_max)
Car2Go_Error_min <- subset(Car2Go, Auslastung < Car2Go_sd2_min)
error <- rbind(Drivenow_Error_max,Drivenow_Error_min,Car2Go_Error_max,Car2Go_Error_min)

error_sql <- matrix(ncol=1,nrow=length(error$Provider))
for (i in 1:length(error$Provider)){
  error_sql[i] <- paste0("DELETE FROM berlin.routes WHERE date_trunc('day', TIMESTAMPSTART) = TIMESTAMP '",error$Date[i], "' AND provider = '",error$Provider[i],"' ;")
}

write.table(error_sql, 
            "/home/martinlindner/Postgres/Querys/carsharing/remove_error_sd3.sql",
            quote=FALSE,
            row.names=FALSE,
            col.names = FALSE)

ggplot(Auslastung, aes(x = Date, y = Auslastung, colour = Provider)) +
  geom_line()+
  xlab("Date")+
  ylab("Mean utilization in h/d")+
  theme_light()

ggplot(Auslastung, aes(x = Date, y = PeriodeOfUse, colour = Provider)) +
  geom_line()+
  xlab("Date")+
  ylab("Mean utilization in h/d")+
  theme_light()
