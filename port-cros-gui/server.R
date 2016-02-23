library(shiny)

shinyServer(function(input, output) {
  setwd("../data/")
  source("svm.R")
  source("analyse_meteo.R")
  
  # TAB1 : Affichage des points de satisfaction
  output$satPlot <- renderPlot({
    result <- data.frame(sat_result$date, sat_result[,input$sat])
    colnames(result) <- c("date", "result")
    rows <- which(!is.na(result$result))
    result <- result[rows,]
    plot(
      x = result$date, y = result$result, xlab = "Date d'enquete", ylab = "Niveau de satisfaction", main = "Satisfaction", ylim =
        c(-1,1)
    )
  })
  
  # TAB2 : Affichage des liens entre la satisfaction et la frequentation
  output$nomPlot <- renderPlot({
    eval(parse(
      text = paste("final_result <- ",input$nom,"_with_passager",sep = "")
    ))
    show_res(mat_res = final_result, mark = paste("frequentation",input$nom))
  })
  
  # TAB 3 : Prediction avec SVM
  observeEvent(input$predict, {
    withProgress(message = 'Chargement du modele', value = 0, {
      run_svm_training()
      day <<- as.numeric(input$day)
      month <<- as.numeric(input$month)
      withProgress(message = 'Estimation de la satisfaction', value = 0, {
        result <<- run_svm_prediction(day, month)
      })
    })
    
    output$svmPlot <- renderPlot({
      # Displaying the result
      plot(
        result$my_result,type = "p", xlab = "Nombre de passagers", ylab = "Satisfaction"
      )
      
      # Some title
      title("Resultat des estimations")
      
      # Drawing the daily mean live
      abline(h = result$sat_mean[day, month], col = "red")
      
      # Drawing the monthly mean live
      abline(h = result$sat_mean_by_month[month], col = "green")
      
      # Drawing the global mean live
      abline(h = result$sat_mean_global, col = "blue")
      
      # Drawing vertical lines when we cross the mean
      abline(v = result$crossing_mean, col = "gray")
    })
    
    output$dailyMean <- renderText({
      paste(
        "Satisfaction moyenne pour le ", day, "/", month, " : ", round(result$sat_mean[day, month], digits = 2)
      )
    })
    
    output$monthlyMean <- renderText({
      paste(
        "Satisfaction moyenne mensuelle : ", round(result$sat_mean_by_month[month], digits = 2)
      )
    })
    
    output$globalMean <- renderText({
      paste("Satisfaction moyenne globale : ", round(result$sat_mean_global, digits = 2))
    })
    
    output$maxPass <- renderText({
      paste(
        "Nous vous conseillons de limiter le nombre de visiteurs a ", result$crossing_mean, "."
      )
    })
    
    output$explications <- renderText({
      paste(
        "Pour vous fournir ce chiffre, nous regardons quand notre estimation de la satisfaction des visiteurs passe en dessous de la moyenne pour le jour que vous avez choisi. Si la moyenne du jour est trop basse, nous comparons avec la moyenne mensuelle. Si la moyenne mensuelle est trop basse, nous comparons avec la moyenne globale."
      )
    })
  })
  
  # TAB 4 : Analyse de meteo
  output$metPlot <- renderPlot({
    eval(parse(text = paste(
      "meteo_result <- .meteo_sat_",input$met,sep = ""
    )))
    if (input$check) {
      if (input$para == "total") {
        show_sat_meteo(sat_mat = meteo_result, mark = input$met)
      } else {
        show_det_meteo(
          sat_mat = meteo_result, mark = input$met, detail = input$para
        )
      }
    } else {
      if (input$para != "total") {
        show_res_meteo(
          sat_mat = meteo_result, mark = input$met, detail = input$para
        )
      }
    }
  })
})
