source("analyse_debarquement.R")



days <- as.integer(substr(debarquement_passager_ss$date,9,10))
month <- as.integer(substr(debarquement_passager_ss$date,6,7))
dayNmonth<-substr(debarquement_passager_ss$date,6,10)

G_debarquement <-data.frame(dayNmonth,days,month,debarquement_passager_ss$`nombre debarquements`)
G_daily_deb <-aggregate(G_debarquement[,2:4], list(G_debarquement$dayNmonth),mean)

for (i in 1:12){
  G_daily_sub = subset(G_daily_deb,G_daily_deb$month==i)
  if (length(G_daily_sub[,1])!=0){
  plot(G_daily_sub$days,G_daily_sub$debarquement_passager_ss..nombre.debarquements.,type ="h")
  title(i)
  }
}