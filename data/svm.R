# Clear the console
cat("\014")

#package "svm" :
#install.packages('e1071', dependencies = TRUE)

source("satisfaction_version_complet.R")
source("analyse_debarquement.R")

library(e1071)

################### GENERAL STUFF SUCH AS LOADING DATA ############################


#suppresion sauvage des données à 0
#solution provisoire à remplacer asap par une boucle
pieton_with_passager_ss = pieton_with_passager_ss[21:95,]
  
satisfaction <- pieton_with_passager_ss$result
nbr_passagers <- pieton_with_passager_ss$debarquement..nombre.de.passagers.
days <- as.integer(substr(pieton_with_passager_ss$date,9,10))
months <- as.integer(substr(pieton_with_passager_ss$date,6,7))

training_data <- data.frame(days,months,nbr_passagers)



colnames(training_data) <- c("days","months","nbr_passagers")

# Creating 2 labels: one for unsatisfaction, the other for satisfaction
satisfaction[satisfaction <= 0] <- -1
satisfaction[satisfaction > 0] <- 1



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
  #cat(paste("score:", score, "%", sep = " "))
}



################### PREDICT FUNCTION ############################


capa_charge <- function(day, month){
  # Init
  result <- 0
  # We predict the satisfaction for every possible passengers values between 1 and 2000
  for(i in 1:2000) 
  {
    B = matrix(c(day,month,i), nrow=1, ncol=3)
    result[i] <- predict(model,B)
    #incProgress(1/2000, detail = paste(trunc(100*i/2000)," %"))
  }
  
  #result[result <= 0] <- -1
  #result[result > 0] <- 1
  plot(result,xlab="Number of passengers", ylab="Satisfaction")
  abline(h = 0, col = "red")
  title(paste("Prediction of the satisfaction for the",day,"/", month))
  return(result)
}


training_svm();
capa_charge(1,1);

source("close_db_connections.R")
