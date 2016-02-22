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
#satisfaction[satisfaction <= 0.2] <- 0
#satisfaction[satisfaction > 0.2] <- 1

# satisfaction[satisfaction < 0] <- -1
# satisfaction[satisfaction >= 0 & satisfaction < 0.2] <- 0
# satisfaction[satisfaction >= 0.2] <- 1


################### TRAINING FUNCTION ############################

#satmod <- cbind(satisfaction,nbr_passagers)
satmod <- cbind(satisfaction,training_data)

training_svm <- function () {
  # Training SVM
  
  model <<- svm(satisfaction ~ . ,satmod )
  
  # Prediction
  prediction <- predict(model, satmod)
  
  #points(nbr_passagers, prediction, col = "red", pch=4)
  
  plot(x=satmod$months,y=prediction,xlab="Number of passengers", ylab="Satisfaction")
  abline(h = 0, col = "red")
}



################### PREDICT FUNCTION ############################




training_svm();


source("close_db_connections.R")


