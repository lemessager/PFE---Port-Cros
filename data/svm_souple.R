####################   Script for SVM training and prediction   ###############
###
###       METHODS:  load_data()
###                 init_svm()
###                 train_svm()
###                 capa_charge(day,month)
###                 close_db_connections()
###                 compute_sat_mean()
###                 run_svm_training()
###                 run_svm_prediction()
###
###############################################################################
 
# Load the data from other scripts
# Load the library for SVM


load_data_souple <- function() {
  source("satisfaction_version_complet.R")
  source("analyse_debarquement.R")
  source("svm.R")
  library(e1071)
  G_PIETON <<- pieton_with_passager_ss
  G_NAUTIQUE <<- nautique_with_passager_ss
  G_TOTAL <<- total_with_passager_ss
  G_gui = TRUE
  #rm(list=ls(all=TRUE))
  close_db_connections()
  
}


  #close_db_connections()
  
# Format the data in order to fit our SVM model
# We consider data frames with 3 parameters :
# - date    YYYY-MM-DD
# - landing (debarquement..nombre.de.passagers.)
# - result  between -1 and 1
init_svm_parametered <- function(L_date_landing_result) {
  # Deleting data where satisfaction is null
  L_date_landing_result <-
    L_date_landing_result[L_date_landing_result$result != 0,]
  
  # Load satisfaction from data
  satisfaction <<- L_date_landing_result$result
  
  # Load nbr of passengers from data
  nbr_passagers <-L_date_landing_result$debarquement..nombre.de.passagers.
  
  # Load days from data
  days <- as.integer(substr(L_date_landing_result$date,9,10))
  
  # Load months from data
  month <- as.integer(substr(L_date_landing_result$date,6,7))
  
  # Create a data matrix from the extracted days, months and number of passengers
  training_data <<- data.frame(days,month,nbr_passagers)
  
  # Give name to the columns of the previously created matrix
  colnames(training_data) <<- c("days","months","nbr_passagers")
  
  # Computing the satisfaction mean
  compute_sat_mean()
  
  # The maximum number of passengers for SVM training and prediction
  max_passengers <<- 2000
}




# Close the connection with the DB
close_db_connections <- function() {
  source("close_db_connections.R")
}

run_svm_training_c <- function(critere) {

   if (critere==2)
     run_svm_training_parametered(G_NAUTIQUE)
   else if(critere==3)
       run_svm_training_parametered(G_TOTAL)
   else
         run_svm_training_parametered(G_PIETON)
  
    
}


# MAIN TRAINING FUNCTION
run_svm_training_parametered <- function(L_date_landing_results,load=TRUE) {
  if (load)
  load_data_souple()
  
  init_svm_parametered(L_date_landing_results)
  train_svm()
  close_db_connections()
}

run_svm_train_and_predict <- function(L_date_landing_results,day,month) {
  G_gui <<- FALSE
  run_svm_training_parametered(L_date_landing_results)
  run_svm_prediction(day,month)
  G_gui <<- TRUE
}

