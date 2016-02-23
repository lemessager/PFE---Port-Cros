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
load_data <- function() {
  source("satisfaction_version_complet.R")
  source("analyse_debarquement.R")
  library(e1071)
  G_PIETON = pieton_with_passager_ss
  G_NAUTIQUE = nautique_with_passager_ss
  G_TOTAL = total_with_passager_ss
  names(G_PIETON)[names(G_PIETON)=="debarquement..nombre.de.passagers."]="landing"
  names(G_NAUTIQUE)[names(G_NAUTIQUE)=="debarquement..nombre.de.passagers."]="landing"
  names(G_TOTAL)[names(G_TOTAL)=="debarquement..nombre.de.passagers."]="landing"
  
}

#rm(list=ls(all=TRUE))
  load_data()
  G_PIETON = pieton_with_passager_ss
  G_NAUTIQUE = nautique_with_passager_ss
  G_TOTAL = total_with_passager_ss
  names(G_PIETON)[names(G_PIETON)=="debarquement..nombre.de.passagers."]="landing"
  names(G_NAUTIQUE)[names(G_NAUTIQUE)=="debarquement..nombre.de.passagers."]="landing"
  names(G_TOTAL)[names(G_TOTAL)=="debarquement..nombre.de.passagers."]="landing"
  
  #close_db_connections()
  
# Format the data in order to fit our SVM model
# We consider data frames with 3 parameters :
# - date    YYYY-MM-DD
# - landing 
# - result  between -1 and 1
init_svm <- function(L_date_landing_result) {
  # Deleting data where satisfaction is null
  L_date_landing_result <-
    L_date_landing_result[L_date_landing_result$result != 0,]
  
  # Load satisfaction from data
  satisfaction <<- L_date_landing_result$result
  
  # Load nbr of passengers from data
  nbr_passagers <-
    L_date_landing_result$landing
  
  # Load days from data
  days <- as.integer(substr(L_date_landing_result$date,9,10))

  # Load months from data
  months <- as.integer(substr(L_date_landing_result$date,6,7))
  
  # Create a data matrix from the extracted days, months and number of passengers
  training_data <<- data.frame(days,months,nbr_passagers)
  
  # Give name to the columns of the previously created matrix
  colnames(training_data) <<- c("days","months","nbr_passagers")
  
  # Computing the satisfaction mean
  compute_sat_mean()
  
  # The maximum number of passengers for SVM training and prediction
  max_passengers <<- 2000
}

# Compute several means about satisfaction
compute_sat_mean <- function() {
  # Init the satisfaction as a matrix (size 31 days and 12 months)
  sat_mean <<- matrix(numeric(1), nrow = 31, ncol = 12)
  
  # Append data and satisfaction
  big_matrix <<- data.frame(training_data, satisfaction)
  
  # Iterate for each day of year
  # We compute the mean of the satisfaction per day
  # If the mean is defined we keep it
  for (i in 1:31) {
    for (j in 1:12) {
      tmp = mean(subset(big_matrix[,4], big_matrix[,1] == i &
                          big_matrix[,2] == j))
      if (is.finite(tmp)) {
        sat_mean[i,j] <<- tmp
      }
    }
  }
  
  # We put NA value for each 0 (because 0 is not very representative for mean computation)
  sat_mean[sat_mean == 0] <<- NA
  
  # We compute the mean for each month
  sat_mean_by_month <<- colMeans(sat_mean, na.rm = TRUE)
  
  # We compute the global mean
  sat_mean_global <<- mean(sat_mean_by_month, na.rm = TRUE)
}

# Train the SVM model
train_svm <- function () {
  # Training SVM
  model <<- svm(training_data, satisfaction)
  
  # Prediction on training dataset
  prediction <- predict(model, training_data)
  
  # Comparison between predicted values and real values
  prediction_error <- abs(prediction - satisfaction)
  
  # Compute how many good predictions we have
  score <-
    round(100 * (1 - (sum(prediction_error) / 2) / length(prediction)))
  
  # Display the score
  cat(paste("score:", score, "%", sep = " "))
}

# SVM prediction given a date
capa_charge <- function(day, month) {
  # Init
  result <- 0
  
  # We predict the satisfaction for every possible passengers values between 1 and max_passengers
  for (i in 1:max_passengers) {
    B = matrix(c(day,month,i), nrow = 1, ncol = 3)
    result[i] <- predict(model,B)
    
    # For Shiny App displaying the progress of the prediction
    #incProgress(1/max_passengers, detail = paste(trunc(100*i/max_passengers)," %"))
  }
  
  # Displaying the result
  plot(result,type = "p", xlab = "Number of passengers", ylab = "Satisfaction")
  
  # Some title
  title(paste("Prediction of the satisfaction for the",day,"/", month))
  
  # Returning the result object for further use
  return(result)
}

# Close the connection with the DB
close_db_connections <- function() {
  source("close_db_connections.R")
}

run_svm_training_c <- function(critere) {

   if (critere==2)
     run_svm_training(G_NAUTIQUE)
   else if(critere==3)
       run_svm_training(G_TOTAL)
   else
         run_svm_training(G_PIETON)
  
    
}


# MAIN TRAINING FUNCTION
run_svm_training <- function(L_date_landing_results) {
  load_data()
  init_svm(L_date_landing_results)
  train_svm()
  close_db_connections()
}

run_svm_train_and_predict <- function(L_date_landing_results,day,month) {
  run_svm_training(L_date_landing_results)
  run_svm_prediction(day,month)
}

# MAIN PREDICTION FUNCTION
run_svm_prediction <- function(day, month) {
  # We run the prediction function and store
  my_result <- capa_charge(day, month)
  
  # We initialize the crossing_mean vector
  crossing_mean <<- numeric()
  
  # We take the max_passengers minus one
  max_pass_minus_one <- max_passengers - 1
  
  # We go through the result and check for values that cross the mean
  if (is.finite(sat_mean[day,month])) {
    for (i in 1:max_pass_minus_one) {
      if (my_result[i] >= sat_mean[day,month] &&
          my_result[i + 1] < sat_mean[day,month]) {
        crossing_mean <<- c(crossing_mean, i)
      }
    }
  }
  
  # If we don't have daily mean, We do the same but for monthly mean
  if (length(crossing_mean) == 0) {
    if (is.finite(sat_mean_by_month[month])) {
      for (i in 1:max_pass_minus_one) {
        if (my_result[i] >= sat_mean_by_month[month] &&
            my_result[i + 1] < sat_mean_by_month[month]) {
          crossing_mean <<- c(crossing_mean, i)
        }
      }
    }
  }
  
  # If we don't have monthly mean, We do the same but for global mean
  if (length(crossing_mean) == 0) {
    for (i in 1:max_pass_minus_one) {
      if (my_result[i] >= sat_mean_global &&
          my_result[i + 1] < sat_mean_global) {
        crossing_mean <<- c(crossing_mean, i)
      }
    }
  }
  
  # Drawing the daily mean live
  abline(h = sat_mean[day,month], col = "red")
  
  # Drawing the monthly mean live
  abline(h = sat_mean_by_month[month], col = "green")
  
  # Drawing the global mean live
  abline(h = sat_mean_global, col = "blue")
  
  # Drawing vertical lines when we cross the mean
  abline(v = crossing_mean, col = "gray")
  
  big_result = list(
    "my_result" = my_result, "sat_mean" = sat_mean, "sat_mean_by_month" = sat_mean_by_month, "sat_mean_global" = sat_mean_global, "crossing_mean" = crossing_mean
  )
  
  return(big_result)
}