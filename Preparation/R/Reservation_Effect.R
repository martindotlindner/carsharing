library(ggplot2)

setwd("C:/Program Files/PostgreSQL/9.5/data/")

reservation <- read.table("reservation_effect.csv",sep = ";",dec = ".", header = TRUE)
reservation$dow <- as.character(reservation$dow)

count_df <- read.table("reservation_effect_count.csv",sep = ";",dec = ".", header = TRUE)
count_df$dow <- as.character(count_df$dow)

count_merge <- merge(reservation,count_df,by = c("provider","dow"))
count_merge$count_rel <- count_merge$count.y/count_merge$count.x*100

ggplot(reservation, aes(x = dow,y = avg_duration_h,fill=provider))+
  geom_bar(stat = "identity",position=position_dodge())+ 
  xlab("Day of the week")+
  ylab("Average duration of a trip (in h)")+
  ggtitle("Average duration of a trip starting before 7:00 o´clock")+
  coord_cartesian(ylim=c(0.5,0.8))+
  scale_x_discrete(labels=c("1" = "Mo",
                              "2" = "Tu",
                              "3" = "We",
                              "4" = "Th",
                              "5" = "Fr",
                              "6" = "Sa",
                              "7" = "Su"))+
  scale_fill_discrete(name="Provider") #Title of Legend

ggplot(count_merge, aes(x = dow,y = count_rel,fill=provider))+
  geom_bar(stat = "identity",position=position_dodge())+ 
  xlab("Day of the week")+
  ylab("Amount of trips with duration > 4h in %")+
  ggtitle("Mean percentage of trips with duration > 4h started before 7:00 o´clock")+
 # coord_cartesian(ylim=c(0.5,0.8))+
  scale_x_discrete(labels=c("1" = "Mo",
                            "2" = "Tu",
                            "3" = "We",
                            "4" = "Th",
                            "5" = "Fr",
                            "6" = "Sa",
                            "7" = "Su"))+
  scale_fill_discrete(name="Provider") #Title of Legend




