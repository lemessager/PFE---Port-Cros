library(shiny)
#library(datasets)

shinyUI(
  navbarPage(
    title = "Dashboard", theme = "main.css",
    
    # TAB 1
    tabPanel(
      "Visualistion donnees satisfaction",
      
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "sat", "Niveau de satisfaction",
            choices = c("nautique","pieton","total")
          ),
          hr(),
          helpText("Donnees des enquetes")
        ),
        mainPanel(plotOutput("satPlot"))
      )
    ),
    
    # TAB 2
    tabPanel(
      "Visualistion donnees satisfaction / frequentation",
      
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "nom", "Niveau de satisfaction en fonction de frequentation",
            choices = c("pieton","nautique","total")
          ),
          hr(),
          helpText("Resultat apres l'analyse")
        ),
        mainPanel(plotOutput("nomPlot"))
      )
    ),
    
    
    # TAB 3
    tabPanel(
      "Prediction satisfaction",
      
      sidebarLayout(
        sidebarPanel(
          sliderInput("day", "Jour", 1, 31, 15),
          selectInput(
            "month", "Mois", c(
              "Janvier" = 1,
              "Fevrier" = 2,
              "Mars" = 3,
              "Avril" = 4,
              "Mai" = 5,
              "Juin" = 6,
              "Juillet" = 7,
              "Aout" = 8,
              "Septembre" = 9,
              "Octobre" = 10,
              "Novembre" = 11,
              "Decembre" = 12
            )
          ),
          selectInput(
            "critere", "critere", c(
              "Pieton" = 1,
              "Nautique" = 2,
              "Total" = 3
            )
          ),
          hr(),
          actionButton("predict", "Lancer la prediction")
        ),
        mainPanel(
          plotOutput("svmPlot"),
          hr(),
          textOutput("dailyMean"),
          textOutput("monthlyMean"),
          textOutput("globalMean"),
          br(),
          textOutput("maxPass"),
          hr(),
          textOutput("explications"),
          br(),
          br()
        )
      )
    )
  
  )
)
