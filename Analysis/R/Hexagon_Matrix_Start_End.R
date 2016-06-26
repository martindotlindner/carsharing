library(reshape2)

# setwd("C:/Program Files/PostgreSQL/9.5/data/")
setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data/")

# Read table from sql query "Hexagon_Matrix_Start_End.sql"
hex_matrix_before <- read.table("Hexagon_Matrix_before.csv",header = TRUE, sep = ";")
hex_matrix_after <- read.table("Hexagon_Matrix_after.csv",header = TRUE, sep = ";")


#Create column with percentage
hex_matrix_before$Anteil <- (hex_matrix_before$count/sum(hex_matrix_before$count))*100
hex_matrix_after$Anteil <- (hex_matrix_after$count/sum(hex_matrix_after$count))*100

#Remove rows with NA
hex_matrix_before <- na.omit(hex_matrix_before)
hex_matrix_after <- na.omit(hex_matrix_after)

#Create matrix from data frame
hex_matrix_before_total <- acast(hex_matrix_before, start_hex~end_hex, value.var = "count")
hex_matrix_after_total <- acast(hex_matrix_after, start_hex~end_hex, value.var = "count")
#hex_matrix_anteil <- acast(hex_matrix, start_hex~end_hex, value.var = "Anteil")
#hex_matrix_anteil <- acast(hex_matrix, start_hex~end_hex, value.var = "Anteil")

## Set directory before writing csv
#setwd("")
write.csv(hex_matrix_before_total, file = "hex_matrix_before_total.csv")
write.csv(hex_matrix_after_total, file = "hex_matrix_after_total.csv")

#write.csv(hex_matrix_anteil, file = "hex_matrix_anteil.csv")

