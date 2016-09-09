setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Geodaten/Berlin/Strukturdaten/Einkaufszentren/")
shopping_malls <- read.table("Einkaufszentren_D.csv", sep = ",", dec = ".",header = TRUE,fileEncoding= "utf8")
shopping_malls <- shopping_malls[,1:5]
colnames(shopping_malls)[5] <- c("Verkaufsflaeche")

shopping_malls$Flaeche <- gsub("^[0]+", "", shopping_malls$Verkaufsflaeche)
shopping_malls$Flaeche <- substr(shopping_malls$Flaeche, 0,7)
shopping_malls$Flaeche <- gsub("([0-9]+)\\.([0-9])", "\\1\\2", shopping_malls$Flaeche)
shopping_malls$Flaeche <- as.numeric(shopping_malls$Flaeche)


write.table(x = shopping_malls, file = "malls.csv",
            fileEncoding= "utf8",
            row.names=FALSE,
            col.names = FALSE,
            sep = ";",
            dec = ".")
