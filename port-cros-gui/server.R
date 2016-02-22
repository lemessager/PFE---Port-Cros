library(shiny)

shinyServer(function(input, output){
  
  setwd("../data/")
  source("svm.R")
  source("analyse_meteo.R")
  
  training_svm()
  
  # TAB1 : Affichage des points de satisfaction 
  output$satPlot <- renderPlot({
    result <- data.frame(sat_result$date, sat_result[,input$sat])
    colnames(result) <- c("date", "result")
    rows <- which(!is.na(result$result))
    result <- result[rows,]    
    plot(x = result$date, y = result$result, xlab = "Date d'enquete", ylab = "Niveau de satisfaction", main = "Satisfaction", ylim=c(-1,1))
  })
  
  # TAB2 : Affichage des liens entre la satisfaction et la frequentation
  output$nomPlot <- renderPlot({
    eval(parse(text = paste(
      "final_result <- ",input$nom,"_with_passager",sep = ""
    )))
    show_res(mat_res = final_result, mark = paste("frequentation",input$nom))
  })

  # TAB 3 : Pr??diction avec SVM
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
  
  # TAB 4 : Analyse de meteo
  output$metPlot <- renderPlot({
    eval(parse(text = paste(
      "meteo_result <- .meteo_sat_",input$met,sep = ""
    )))
    show_sat_meteo(sat_mat = meteo_result, mark = input$met)  })
})
  