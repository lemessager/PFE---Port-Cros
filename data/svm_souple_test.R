
#
# tests du svm
# svm_souple.R
#
# Benjamin CLAQUIN
# 25/02/16
#

source("svm_souple.R")


test_data_svm <- function(L_date_landing_results, table_name ="") {
   Error_Tab <<- c()
   int_ten_percents = as.integer(length(L_date_landing_results[,1])/10)
  int_ninety_percents = length(L_date_landing_results[,1])-int_ten_percents
   
  for (i in 1:10){
    L_data_test <<- L_date_landing_results[c((i-1)*int_ten_percents+1:int_ten_percents*i),]
    L_data_train <<-L_date_landing_results[-c((i-1)*int_ten_percents+1:int_ten_percents*i),]
    
    run_svm_training_parametered(L_data_train,FALSE)
    
    
    nbr_passagers <-L_data_test$debarquement..nombre.de.passagers.
    days <- as.integer(substr(L_data_test$date,9,10))
    month <- as.integer(substr(L_data_test$date,6,7))
    sat <- L_data_test$result
    test_data <<- data.frame(days,month,nbr_passagers,sat)
    
    for (j in 1:length(test_data[,1])){
      L_day <<- as.integer(test_data[j,][1])
      L_month <<- as.integer(test_data[j,][2])
      L_pass <<- as.integer(test_data[j,][3])
      L_sat <<- as.integer(test_data[j,][4])
      
       B = matrix(c(L_day,L_month,L_pass), nrow = 1, ncol = 3)
       error = predict(model,B)
       Error_Tab <<- cbind(Error_Tab,abs(error-L_sat))
      
    }
    
  }
   Mean_Error_Tab <<- mean(Error_Tab)
   Mean_Error_Tab_Percent <<- Mean_Error_Tab*50
   L_display <<- paste("\n ",table_name," (error) : ",Mean_Error_Tab," soit ",Mean_Error_Tab_Percent," %")
   cat(L_display)
}


load_data_souple()
test_data_svm(G_NAUTIQUE,"table nautique ")
test_data_svm(G_PIETON, " table pieton")
test_data_svm(G_TOTAL," table totale")
