# This codes aims at showing the relationship between the number of passengers and the level of satisfaction
# It reads another table from the database: debarquement_jour
# We consider only the dates when questionnaires are given and when we get the results of satisfaction
# Result:
# Editor: ZHU Yuting
# Version: 2015-11-30

# Connection with the database
source("satisfaction_version_complet.R")

# Consideration of the tables 'debarquement'
debarquement <- dbGetQuery(channel, "SELECT * FROM BOUNTILLES_PC_juillet2013.debarquements_jour;")

# Preparation for merge the tables and Normalize the number of passenger
debarquement <- debarquement[-1]
date <- substr(debarquement[,1],1,10)
nbr_passager <- scale(debarquement[,2], center = T, scale = T)
debarquement_passager <- data.frame(date, nbr_passager)

col_name <- c("date", "result")
colnames(sat_result_nautique) <- col_name
colnames(sat_result_pieton) <- col_name
colnames(sat_result_remarque) <- col_name

# Merge the tables by date:
# We only take in consideration the dates which have both number of passenger and number of satisfaction
nautique_with_passager <- merge(debarquement_passager, sat_result_nautique, by="date")
pieton_with_passager <- merge(debarquement_passager, sat_result_pieton, by="date")
remarque_with_passager <- merge(debarquement_passager, sat_result_remarque, by="date")

# Normalize the result of satisfaction in order to do a further analysis
nautique_with_passager$result <- -scale(nautique_with_passager$result, center = T, scale = T)
pieton_with_passager$result <- -scale(pieton_with_passager$result, center = T, scale = T)
remarque_with_passager$result <- -scale(remarque_with_passager$result, center = T, scale = T)

# Show the result
show_res <- function(mat_res, mark){
  plot(x=mat_res$date, y=mat_res$nbr_passager)
  title(paste("Satisfaction en fonction de", mark, "et le nombre de passager"))
  lines(x=mat_res$date, y=mat_res$nbr_passager,col="green")
  lines(x=mat_res$date, y=mat_res$result, col="red")
  legend("bottomright",legend=c("niveau de satisfaction", "nombre de passager"), col=c(2,3), lty=1)
}

show_res(mat_res = nautique_with_passager, mark = "frequentation nautique")
show_res(mat_res = pieton_with_passager, mark = "frequentation pietonne")
show_res(mat_res = remarque_with_passager, mark = "remarque")
