# Clear the console
cat("\014")

#package "svm" :
#install.packages('e1071', dependencies = TRUE)

source("satisfaction_version_complet.R")
source("analyse_debarquement.R")

library(e1071)

#Benjamin CLAQUIN
#26/01/16
#################################################################
################### Testing the SVM  ############################
#################################################################



#suppresion sauvage des données à 0
#solution provisoire à remplacer asap par une boucle
pieton_with_passager_ss = pieton_with_passager_ss[21:95,]


satisfaction_brut <- pieton_with_passager_ss$result
nbr_passagers <- pieton_with_passager_ss$debarquement..nombre.de.passagers.
days <- as.integer(substr(pieton_with_passager_ss$date,9,10))
months <- as.integer(substr(pieton_with_passager_ss$date,6,7))

full_data <- data.frame(days,months,nbr_passagers)

# full_data with the satisfaction
full_data_results <- cbind(full_data,satisfaction_brut)

colnames(training_data) <- c("days","months","nbr_passagers")

# Creating 2 labels: one for unsatisfaction, the other for satisfaction
satisfaction[satisfaction_brut <= 0] <- -1
satisfaction[satisfaction_brut > 0] <- 1

full_data_dec = dim(full_data)[1]/10;

test_data = full_data_results[1:full_data_dec,];


training_data = full_data[(full_data_dec):(10*full_data_dec),];


################### TRAINING FUNCTION ############################

training_svm <- function () {
  # Training SVM
  model <<- svm(training_data, satisfaction)
  # HINT: subset(x, select = c(columns to choose))
  
  # Prediction
  prediction <- predict(model, training_data)
  
  # If the predicted value is negative or 0, then it's -1 otherwise it's 1
  prediction[prediction <= 0] <- -1
  prediction[prediction > 0] <- 1
  
  # Comparison between predicted values and real values
  prediction_error <- abs(prediction - satisfaction)
  
  # Compute how many good predictions we have
  score <- round(100*(1-(sum(prediction_error)/2)/length(prediction)))
  
  # Display the score
  cat(paste("score:", score, "%", sep = " "))
}



################### PREDICT FUNCTION ############################


capa_charge_test <- function(day, month, nbOfPassenger){
  # Init
  result <- 0
  
  # We predict the satisfaction for the value in parameter
  B = matrix(c(day,month,nbOfPassenger), nrow=1, ncol=3);
  result <- predict(model,B)

  return(result)
}


for (i in 1:nrow(test_data)){
  
  L_day = test_data[i,1]
  L_months = test_data[i,2]
  L_passengers = test_data[i,3]
  L_satisfaction = test_data[i,4]
  print(paste(" satisfaction (vraie:calculée) ", L_satisfaction, ":", capa_charge_test(L_day,L_months,L_satisfaction),sep=" "))
  L_erreur = abs(L_satisfaction - capa_charge_test(L_day,L_months,L_satisfaction))
  print(paste("erreur ",L_erreur))
}


source("close_db_connections.R")
