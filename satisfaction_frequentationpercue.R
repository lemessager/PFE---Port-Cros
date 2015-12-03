#
# Recherche l'influance de la fréquentation perçue sur la satisfaction générale du client
#
# Benjamin CLAQUIN
# Version: 2015/12/01

#####################################################################
####################  Extaction of the data  ########################
#####################################################################
# Clear the console
cat("\014") 
rm(list = ls())

install.packages("plyr")
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
frequentation_pietonne = frequentation_pietonne[-c(1:1086),]
general_pieton <- frequentation_pietonne[c(3)]

# dates
date_nautique <- substr(frequentation_nautique[,1],1,10)
date_pietonne <- substr(frequentation_pietonne[,1],1,10)


#"imp.fréq.plages"   "imp.fréq.sentiers" "imp.fréq.port"    
# "fréq.plages"       "fréq.sentiers"     "fréq.village"  
general_freq <-  frequentation_pietonne[c(9,10,12:15)]%%5

#date_pietonne <- date_pietonne[c(1)]

g_pieton <- data.frame(cbind(date_pietonne, general_pieton))
g_freq <- data.frame(cbind(date_pietonne, general_freq))

display_pieton <- ddply(g_pieton, .(date_pietonne), summarize, moyen=mean(visite))
display_frequ  <- ddply(g_freq, .(date_pietonne), summarize, moyen=((mean(imp.fréq.plages)+mean(imp.fréq.sentiers)+mean(imp.fréq.port)+mean(fréq.plages)+mean(fréq.sentiers)+mean(fréq.village))/6))

plot(x = display_pieton$date_pietonne, y = display_pieton$moyen, xlab = "Date d'enquete", ylab = "Niveau de satisfaction", main = "Satisfaction calcule de Remarque", ylim=c(0,5))
lines(x = display_pieton$date_pietonne, y=display_frequ$moyen,col="green")


