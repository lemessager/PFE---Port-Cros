#drv = dbDriver("MySQL")

library(RMySQL)
source("C:\\Users\\user\\Desktop\\codesR\\readTable.R");

#mydb = dbConnect(MySQL(), user='root', password='', dbname='port-cros')
mydb = readMyTable();

dbListTables(mydb)

#remarques
remarques = dbGetQuery(mydb, "select * from remarques;")
remarques <- remarques [,-1]
date <- substr (remarques [,1],1,10)
remarques <- remarques [,-1]
remarques <- data.frame (date, remarques)
#meteo2001\
meteo2001 = dbGetQuery(mydb, "select * from meteo2001;")
meteo2001 <- meteo2001 [,-1]
date <- substr (meteo2001 [,1],1,10)
meteo2001 <- meteo2001 [,-1]
meteo2001 <- data.frame (date, meteo2001)
table_globale <- merge (remarques, meteo2001, by="date")
#debarquementjour
# debarquement_jour<- dbGetQuery(mydb, "select * from debarquement_jour;")
# debarquements_jour <- debarquements_jour [,-1]
# date <- substr (debarquements_jour [,1],1,10)
# debarquements_jour <- debarquements_jour [,-1]
# debarquements_jour <- data.frame (date, debarquements_jour)
# table_globale <- merge (remarques, debarquements_jour, by="date")


#joinedTables = dbGetQuery(mydb, "select * from meteo2001 join remarques group by meteo2001.DATE;")
#Meteo2001
#remarques.csv
