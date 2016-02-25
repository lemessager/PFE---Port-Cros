# This codes aims at showing the relationship between the number of passengers and the level of satisfaction
# It reads another table from the database: debarquement_jour
# We consider only the dates when questionnaires are given and when we get the results of satisfaction
# Result:
# Editor: ZHU Yuting
# Version: 2015-11-30



do_debarquement <- function(){
  # Connection with the database
  source("satisfaction_version_complet.R")
  # Consideration of the tables 'debarquement'
  debarquement_passager_ss <- get_table("debarquements")

  nbr_passager <- scale(debarquement_passager_ss[,2], center = T, scale = T)
  .debarquement_passager <<- data.frame(debarquement_passager_ss[,1], nbr_passager)
  colnames(.debarquement_passager) <<- c("date", "nbr_passager")
  
  col_name <- c("date", "result")
  colnames(.sat_result_nautique) <- col_name
  colnames(.sat_result_pieton) <- col_name
  colnames(sat_result_total) <- col_name

  # Merge the tables by date:
  # We only take in consideration the dates which have both number of passenger and number of satisfaction
  nautique_with_passager <<- merge(.debarquement_passager, .sat_result_nautique, by='date')
  pieton_with_passager <<- merge(.debarquement_passager, .sat_result_pieton, by="date")
  total_with_passager <<- merge(.debarquement_passager, sat_result_total, by="date")


  # Normalize the result of satisfaction in order to do a further analysis
  # nautique_with_passager$result <- scale(nautique_with_passager$result, center = T, scale = T)
  # pieton_with_passager$result <- scale(pieton_with_passager$result, center = T, scale = T)
  # remarque_with_passager$result <- scale(remarque_with_passager$result, center = T, scale = T)

  # Show the result
  show_res <- function(mat_res, mark){
    mat_res$result <- scale(mat_res$result, center = T, scale = T)
    plot(x=mat_res$date, y=mat_res$nbr_passager)
    title(paste("Satisfaction en fonction de", mark, "et le nombre de passager"))
    lines(x=mat_res$date, y=mat_res$nbr_passager,col="green")
    lines(x=mat_res$date, y=mat_res$result, col="red")
    legend("bottomright",legend=c("niveau de satisfaction", "nombre de passager"), col=c(2,3), lty=1)
  }


  # Data without scale
  colnames(debarquement_passager_ss) <- c("date", "debarquement..nombre.de.passagers.")

  nautique_with_passager_ss <<- merge(debarquement_passager_ss, .sat_result_nautique, by="date")
  pieton_with_passager_ss <<- merge(debarquement_passager_ss, .sat_result_pieton, by="date")
  total_with_passager_ss <<- merge(debarquement_passager_ss, sat_result_total, by="date")
}

do_debarquement()
