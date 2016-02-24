source("normalize.R")
source("correlation.R")
source("readTable.R")

mysql = readMyTable()

frequentation_pietonne <- dbGetQuery(mysql, "SELECT * FROM enquete_frequentation_pietonne")

frequentation_pietonne <- frequentation_pietonne[-1]
frequentation_pietonne[is.na(frequentation_pietonne)] <- 0

satisfait_pieton <- frequentation_pietonne[c(2,3,5,6,17)] %% 5
satisfait_pieton <- normalize(satisfait_pieton, 4)

derangeant_pieton <- frequentation_pietonne[c(7,9,10,12:15)] %% 5
derangeant_pieton <- normalize(derangeant_pieton,-4)

plot_cor(satisfait_pieton)
plot_cor(derangeant_pieton)

source("close_db_connections.R")