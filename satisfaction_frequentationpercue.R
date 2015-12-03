#
# Recherche l'influance de la fréquentation perçue sur la satisfaction générale du client
#
# Benjamin CLAQUIN
# Version: 2015/12/01

#####################################################################
####################  Extaction of the data  ########################
#####################################################################

#install.packages("plyr")

# Clear the console
cat("\014") 
rm(list = ls())


library("plyr")

cons <- dbListConnections(MySQL())
for(con in cons)
  dbDisconnect(con)

# Connection with the database
source("readTable.R")
channel =  readMyTable()

# load tables
frequentation_nautique <- dbGetQuery(channel, "SELECT * FROM `enquete sur la frequentation nautique`")
frequentation_pietonne <- dbGetQuery(channel, "SELECT * FROM `enquete sur la frequentation pietonne`")

#delete first columns
frequentation_pietonne <- frequentation_pietonne[-1]
frequentation_nautique <- frequentation_nautique[-1]


#on supprime les données où il n'y a pas de présentation
frequentation_pietonne = frequentation_pietonne[-c(1:1087),]
general_pieton <- frequentation_pietonne[c(3)]

# dates
date_nautique <- substr(frequentation_nautique[,1],1,10)
date_pietonne <- substr(frequentation_pietonne[,1],1,10)


#"imp.fréq.plages"   "imp.fréq.sentiers" "imp.fréq.port"    
# "fréq.plages"       "fréq.sentiers"     "fréq.village"  
general_freq <-  frequentation_pietonne[c(9,10,12:15)]%%5




# Calculate the number of non-zero and non-NA values in every row
cal_na <- function(sat_der){
  res <- length(which(!is.na(sat_der)&sat_der!=0))
  return(res) 
}
# Normalise the data
sat_cal <- function(sat_der, mark_val){
  num_vec <- apply(sat_der,1,cal_na)
  cal_vec <- 1./(num_vec*mark_val)
  sat_der[is.na(sat_der)]<-0
  cal_vec[is.infinite(cal_vec)]<-0
  res <- cal_vec*sat_der
  return(res)
}

g_freq0 <- sat_cal(sat_der = general_freq, mark_val = 4)
g_pieton0 <- sat_cal(sat_der = general_pieton, mark_val = 4)

#date_pietonne <- date_pietonne[c(1)]
#on attache la date
g_pieton <- data.frame(cbind(date_pietonne, g_pieton0))
g_freq <- data.frame(cbind(date_pietonne, g_freq0))



# 4 à 1 -> 0 a 10
display_pieton <- ddply(g_pieton, .(date_pietonne), summarize, moyen=mean(visite)*10)
#display_frequ  <- ddply(g_freq, .(date_pietonne), summarize, moyen=((mean(imp.fréq.plages)+mean(imp.fréq.sentiers)+mean(imp.fréq.port)+mean(fréq.plages)+mean(fréq.sentiers)+mean(fréq.village))*10))
display_frequ  <- ddply(g_freq, .(date_pietonne), summarize, moyen=((mean(imp.fréq.plages+imp.fréq.sentiers+imp.fréq.port+fréq.plages+fréq.sentiers+fréq.village))*10))

#plot(x = display_pieton$date_pietonne, y = display_pieton$moyen, xlab = "Date d'enquete", ylab = "Niveau de satisfaction", main = "Satisfaction calcule de Remarque", ylim=c(0,10), col="black")
plot(x = display_pieton$date_pietonne, y = display_pieton$moyen,type="n")
lines(x = display_pieton$date_pietonne, y=display_frequ$moyen,col="green", type="p")
#lines(x = display_pieton$date_pietonne, y = display_pieton$moyen,col= "black" )
#lines(x = display_pieton$date_pietonne, y=display_frequ$moyen,col="green")
