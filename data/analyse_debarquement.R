# This codes aims at showing the relationship between the number of passengers and the level of satisfaction
# It reads another table from the database: debarquement_jour
# We consider only the dates when questionnaires are given and when we get the results of satisfaction
# Result:
# Editor: ZHU Yuting
# Version: 2015-11-30
# 
# Add the part with bateau :
# debarquement_passager_ss ==> bateau_ss
# .debarquement_passager ==> .bateau
# **_with_passager_ss ==> **_with_bateau_ss
# **_with_passager ==> **_with_bateau


do_debarquement <- function(){
  # Connection with the database
  source("satisfaction_version_complet.R")
  # Consideration of the tables 'debarquement'
  debarquement_passager_ss <<- get_table("debarquements")
  bateau_ss <<- get_table("bateaux")

  col_name <- c("date", "result")
  colnames(.sat_result_nautique) <- col_name
  colnames(.sat_result_pieton) <- col_name
  colnames(sat_result_total) <- col_name
  
  colnames(debarquement_passager_ss) <- c("date", "debarquement..nombre.de.passagers.")
  
  nautique_with_passager_ss <<- merge(debarquement_passager_ss, .sat_result_nautique, by="date")
  pieton_with_passager_ss <<- merge(debarquement_passager_ss, .sat_result_pieton, by="date")
  total_with_passager_ss <<- merge(debarquement_passager_ss, sat_result_total, by="date")
  
  nautique_with_bateau_ss <<- merge(bateau_ss, .sat_result_nautique, by = "date")
  pieton_with_bateau_ss <<- merge(bateau_ss, .sat_result_pieton, by = "date")
  total_with_bateau_ss <<- merge(bateau_ss, sat_result_total, by = "date")
  
  nbr_passager <- scale(debarquement_passager_ss[,2], center = T, scale = T)
  nbr_bateau <- scale(bateau_ss[,2], center = T, scale = T)
  .debarquement_passager <<- data.frame(debarquement_passager_ss[,1], nbr_passager)
  .bateau <<- data.frame(bateau_ss[,1], nbr_bateau)
  colnames(.debarquement_passager) <<- c("date", "nbr_passager")
  colnames(.bateau) <<- c("date", "nombre bateau")

  # Merge the tables by date:
  # We only take in consideration the dates which have both number of passenger and number of satisfaction
  nautique_with_passager <<- merge(.debarquement_passager, .sat_result_nautique, by='date')
  pieton_with_passager <<- merge(.debarquement_passager, .sat_result_pieton, by="date")
  total_with_passager <<- merge(.debarquement_passager, sat_result_total, by="date")
  
  nautique_with_bateau <<- merge(.bateau, .sat_result_nautique, by="date")
  pieton_with_bateau <<- merge(.bateau, .sat_result_pieton, by="date")
  total_with_bateau <<- merge(.bateau, sat_result_total, by="date")

  # Data without scale
}

# Show the result
show_res <- function(mat_res, mark){
  mat_res$result <- scale(mat_res$result, center = T, scale = T)
  plot(x=mat_res$date, y=mat_res$nbr_passager)
  title(paste("Satisfaction en fonction de", mark, "et le nombre de passager"))
  lines(x=mat_res$date, y=mat_res$nbr_passager,col="green")
  lines(x=mat_res$date, y=mat_res$result, col="red")
  legend("bottomright",legend=c("niveau de satisfaction", "nombre de passager"), col=c(2,3), lty=1)
}


do_debarquement()

