
# Connection with the database
source("analyse_debarquement.R")

# Consideration of two tables 'meteo' and 'debarquements_jour'
.meteo_db <- dbGetQuery(channel, "SELECT * FROM meteo;")

.meteo <- .meteo_db[,-1]
.date_meteo <- substr(.meteo[,1],1,10)
.meteo <- .meteo[,-1]
.moyen_tem <- (.meteo[,3]+.meteo[,4])/2
.meteo <- data.frame(.date_meteo, .meteo[-c(3,4)], .moyen_tem)

colnames(.meteo) <- c("date", "pluie", "pluie_neige", "ev_piche", "moyen_tem")
.meteo_passager <- merge(.meteo, .debarquement_passager, by="date")
# plot(.meteo_passager$pluie, .meteo_passager$nbr_passager, xlab = "pluie", ylab = "nombre de passager", main = "Relation entre la plue et le nombre de passager")
# plot(.meteo_passager$pluie_neige, .meteo_passager$nbr_passager, xlab = "pluie neige", ylab = "nombre de passager", main = "Relation entre la plue neige et le nombre de passager")
# plot(.meteo_passager$ev_piche, .meteo_passager$nbr_passager, xlab = "ev_piche", ylab = "nombre de passager", main = "Relation entre l'ev_piche et le nombre de passager")
# plot(.meteo_passager$moyen_tem, .meteo_passager$nbr_passager, xlab = "temperature", ylab = "nombre de passager", main = "Relation entre le temperature et le nombre de passager")

.meteo_sat_nautique <- merge(.meteo, .sat_result_nautique, by="date")
.meteo_sat_pieton <- merge(.meteo, .sat_result_pieton, by="date")
.meteo_sat_remarque <- merge(.meteo, .sat_result_remarque, by="date")

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

show_det_meteo <- function(sat_mat, mark, detail){
  date_ <- sat_mat[,1]
  sat_mat_ <- sat_mat[-c(1,6)]
  sat_mat_ <- apply(sat_mat_, 2, scale)
  sat <- data.frame(date_, sat_mat_, sat_mat[,6])
  col_names <- c("date", "pluie", "pluie_neige", "ev_piche", "moyen_temperature", "sat_val")
  colnames(sat) <- col_names
  plot(x=sat$date, y=3*sat$sat_val, ylim=c(-3,3))
  title(paste("Satisfaction en fonction de frequentation", mark, "et le meteo"))
  lines(x=sat$date, y=3*sat$sat_val)
  
  colors_m <- c("red", "green", "blue", "yellow")
  pch <- which(col_names == detail) - 1
  eval(parse(text = paste(
    "points(x=sat$date, y=sat$",detail,", col=colors_m[pch], pch = pch)", sep = ""
  )))
  legend("bottomright",legend=c(detail, "satisfaction"), col=c(colors_m[pch],"black"), pch = pch)
}

show_res_meteo <- function(sat_mat, mark, detail){
  date_ <- sat_mat[,1]
  sat_mat_ <- sat_mat[-c(1,6)]
  sat_mat_ <- apply(sat_mat_, 2, scale)
  sat <- data.frame(date_, sat_mat_, sat_mat[,6])
  col_names <- c("date", "pluie", "pluie_neige", "ev_piche", "moyen_temperature", "sat_val")
  colnames(sat) <- col_names
  y_val <- mean(sat$sat_val)
  eval(parse(text = paste(
    "x_val <- median(sat$",detail,")", sep = ""
  )))
  eval(parse(text = paste(
    "plot(x=sat$",detail,", y=sat$sat_val, xlab= '", detail,"', ylab= 'satisfaction')", sep = ""
  )))
  title(paste("Satisfaction en fonction de frequentation", mark, "et", detail))
  abline(h=y_val, col = "red", lwd=0.5)
  abline(v=x_val, col = "red", lwd=0.5)
  }
