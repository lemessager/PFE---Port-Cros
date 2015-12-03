
# Connection with the database
source("analyse_debarquement.R")

# Consideration of two tables 'meteo' and 'debarquements_jour'
meteo <- dbGetQuery(channel, "SELECT * FROM meteo;")

meteo <- meteo[,-1]
date <- substr(meteo[,1],1,10)
meteo <- meteo[,-1]
moyen_tem <- (meteo[,3]+meteo[,4])/2
meteo <- data.frame(date, meteo[-c(3,4)], moyen_tem)

date <- substr(debarquement[,1],1,10)
nbr_passager <- debarquement[,2]
debarquement_passager <- data.frame(date, nbr_passager)

meteo_passager <- merge(meteo, debarquement_passager, by="date")
plot(meteo_passager$PLUIE, meteo_passager$nbr_passager, xlab = "pluie", ylab = "nombre de passager", main = "Relation entre la plue et le nombre de passager")
plot(meteo_passager$PLUIE_NEIGE, meteo_passager$nbr_passager, xlab = "pluie neige", ylab = "nombre de passager", main = "Relation entre la plue neige et le nombre de passager")
plot(meteo_passager$EV_PICHE, meteo_passager$nbr_passager, xlab = "ev_piche", ylab = "nombre de passager", main = "Relation entre l'ev_piche et le nombre de passager")
plot(meteo_passager$moyen_tem, meteo_passager$nbr_passager, xlab = "temperature", ylab = "nombre de passager", main = "Relation entre le temperature et le nombre de passager")

col_names <- c("date", "result")
colnames(sat_result_nautique) <- col_names
colnames(sat_result_pieton) <- col_names
colnames(sat_result_remarque) <- col_names

meteo_sat_nautique <- merge(meteo, sat_result_nautique, by="date")
meteo_sat_pieton <- merge(meteo, sat_result_pieton, by="date")
meteo_sat_remarque <- merge(meteo, sat_result_remarque, by="date")

###### Problem !!!!

show_sat_meteo <- function(sat_mat, mark){
  date_ <- sat_mat[,1]
  sat_mat_ <- sat_mat[-c(1,6)]
  sat_mat_ <- apply(sat_mat_, 2, scale)
  sat <- data.frame(date_, sat_mat_, sat_mat[,6])
  col_names <- c("date", "pluie", "pluie_neige", "ev_piche", "moyen_temperature", "sat_val")
  colnames(sat) <- col_names
  plot(x=sat$date, y=3*sat$sat_val, ylim=c(-3,3))
  title(paste("Satisfaction en fonction de frequentation", mark, "et le meteo"))
  lines(x=sat$date, y=3*sat$sat_val)
  points(x=sat$date, y=sat$pluie, col="red", pch = 1)
  points(x=sat$date, y=sat$pluie_neige, col="green", pch = 2)
  points(x=sat$date, y=sat$ev_piche, col="blue", pch = 3)
  points(x=sat$date, y=sat$moyen_temperature, col="yellow", pch = 4)
  legend("bottomright",legend=c("pluie", "pluie neige", "ev_piche", "temp"), col=c("red", "green", "blue","yellow"), pch=c(1,2,3,4))
}

show_sat_meteo(sat_mat = meteo_sat_nautique, mark = "nautique")
show_sat_meteo(sat_mat = meteo_sat_pieton, mark = "pietonne")
show_sat_meteo(sat_mat = meteo_sat_remarque, mark = "remarque")
