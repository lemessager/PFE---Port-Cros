####################   Script for SVM training and prediction   ###############
###
###       METHODS:  load_data()
###                 init_svm()
###                 train_svm()
###                 capa_charge(day,month)
###                 close_db_connections()
###
###############################################################################

# Load the data from other scripts
# Load the library for SVM
load_data <- function(){
  source("satisfaction_version_complet.R")
  source("analyse_debarquement.R")
  library(e1071)
}

# Format the data in order to fit our SVM model
init_svm <- function(){
  # Deleting data where satisfaction is null
  pieton_with_passager_ss <- pieton_with_passager_ss[pieton_with_passager_ss$result != 0,]
  
  # Load satisfaction from data
  satisfaction <<- pieton_with_passager_ss$result
  
  # Load nbr of passengers from data
  nbr_passagers <- pieton_with_passager_ss$debarquement..nombre.de.passagers.
  
  # Load days from data
  days <- as.integer(substr(pieton_with_passager_ss$date,9,10))
  
  # Load months from data
  months <- as.integer(substr(pieton_with_passager_ss$date,6,7))
  
  # Create a data matrix from the extracted days, months and number of passengers
  training_data <<- data.frame(days,months,nbr_passagers)
  
  # Give name to the columns of the previously created matrix
  colnames(training_data) <- c("days","months","nbr_passagers")
  
  # Computing the satisfaction mean
  sat_mean <<- mean(satisfaction)
  
  # The maximum number of passengers for SVM training and prediction
  max_passengers <<- 2000
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
  score <- round(100*(1-(sum(prediction_error)/2)/length(prediction)))
  
  # Display the score
  cat(paste("score:", score, "%", sep = " "))
}

# SVM prediction given a date
capa_charge <- function(day, month){
  # Init
  result <- 0
  
  # We predict the satisfaction for every possible passengers values between 1 and max_passengers
  for(i in 1:max_passengers){
    B = matrix(c(day,month,i), nrow=1, ncol=3)
    result[i] <- predict(model,B)
    
    # For Shiny App displaying the progress of the prediction
    #incProgress(1/max_passengers, detail = paste(trunc(100*i/max_passengers)," %"))
  }
  
  # Displaying the result
  plot(result,type = "p", xlab="Number of passengers", ylab="Satisfaction")
  
  # Drawing the 0 line (actually corresponds to the mean)
  abline(h = sat_mean, col = "red")
  
  # Some title
  title(paste("Prediction of the satisfaction for the",day,"/", month))
  
  # Returning the result object for further use
  return(result)
}

# Close the connection with the DB
close_db_connections <- function(){
  source("close_db_connections.R")
}

# MAIN TRAINING FUNCTION
run_svm_training <- function(){
  load_data()
  init_svm()
  train_svm()
  close_db_connections()
}

# MAIN PREDICTION FUNCTION
run_svm_prediction <- function(day, month){
  # We run the prediction function and store
  my_result <- capa_charge(day, month)
  
  # We initialize the crossing_mean vector
  crossing_mean <- character(0)
  
  # We take the max_passengers minus one
  max_pass_minus_one <- max_passengers - 1
  
  # We go through the result and check for values that cross the mean
  for(i in 1:max_pass_minus_one){
    if(my_result[i] >= sat_mean && my_result[i+1] < sat_mean){
      crossing_mean <- c(crossing_mean, i)
    }
  }
  
  # Drawing vertical lines when we cross the mean
  abline(v = crossing_mean, col = "blue")
}