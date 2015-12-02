# CODE A COMPLETER
# VOIR QUELLES DONNEES UTILISER

# Clear the console
cat("\014")

# Connection with the database
source("readTable.R")
channel =  readMyTable();

library(e1071)

# Training SVM
# model <- svm(DATA, LABELS)
# HINT: subset(x, select = c(columns to choose))

# Prediction
# prediction = predict(model, MATRIX TO PREDICT)

# Comparison between predicted values and real values
# table(prediction, LABELS)