source("normalize.R")
source("correlation.R")
source("readTable.R")

mysql = readMyTable()

frequentation_nautique <- dbGetQuery(mysql, "SELECT * FROM enquete_frequentation_nautique")

frequentation_nautique <- frequentation_nautique[-1]
frequentation_nautique[is.na(frequentation_nautique)] <- 0

satisfait_nautique <- frequentation_nautique[c(3,5,6,7,18)]%%5
satisfait_nautique <- normalize(satisfait_nautique,4)

derangeant_nautique <- frequentation_nautique[c(8,9,11,12,15,16)]%%5
derangeant_nautique <- normalize(derangeant_nautique,-4)

plot_cor(satisfait_nautique)
plot_cor(derangeant_nautique)

source("close_db_connections.R")