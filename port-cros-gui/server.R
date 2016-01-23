library(shiny)

shinyServer(function(input, output){
  
  setwd("../data/")
  source("satisfaction_version_complet.R")
  source("analyse_debarquement.R")
  source("svm.R")
  
  training_svm()
  
  output$satPlot <- renderPlot({
    
    # supplementaire a satisfaction_version_complet.R
    
    colnames(sat_result_remarque) <- c("date", "remarque")
    colnames(sat_result_pieton) <- c("date", "pieton")
    colnames(sat_result_nautique) <- c("date", "nautique")
    
    sat_result <- merge(sat_result_remarque, sat_result_nautique, all = T, by="date")
    sat_result <- merge(sat_result, sat_result_pieton, all = T, by = "date")
    
    #####
    
    result <- sat_result[,input$sat]
    result <- data.frame(sat_result$date, result)
    result <- result[-which(is.na(result$result)),]    
    plot(x = result$sat_result.date, y = result$result, xlab = "Date d'enquete", ylab = "Niveau de satisfaction", main = "Satisfaction", ylim=c(-1,1))
  })
  

  observeEvent(input$predict, {

    withProgress(message = 'Calcul en cours...', value = 0, {
      
      result <- capa_charge(as.numeric(input$day), as.numeric(input$month))
      max_h <<- max(result)
      max_v <<- match(max_h,result)
      
    })
    
    output$svmPlot <- renderPlot({
      plot(result,xlab="Number of passengers", ylab="Satisfaction")
      abline(h = max_h, col = "red")
      abline(v = max_v, col = "red")
      title(paste("The optimal number of visitors is: ",max_v))
    })
  })
  
  output$disPlot <- renderPlot({
    
  
    colm <- as.numeric(input$deb)
    hist(iris[,colm], breaks=seq(0,max(iris[,colm], l=input$jour)))   
    
})
})
  