library(shiny)
#library(datasets)

shinyUI(
  navbarPage(
    title = "Dashboard", theme = "main.css",
    
    
    
    # TAB 1
    tabPanel(
      "Correlation entre satisfaction et visiteurs",
      
      sidebarLayout(sidebarPanel(
        selectInput(
          "nom", "Type de visiteurs",
          choices = c("pieton","nautique","total")
        )
      ),
      mainPanel(plotOutput("nomPlot")))
    ),
    
    
    
    
    
    # TAB 2
    tabPanel(
      "Estimer la satisfaction",
      
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
          hr(),
          selectInput(
            "critere", "Type de visiteurs", c(
              "Pieton" = 1,
              "Nautique" = 2,
              "Total" = 3
            )
          ),
          helpText(
            "PIETON : la satisfaction est estimee a partir des enquetes effectuees aupres des pietons."
          ),
          helpText(
            "NAUTIQUE : la satisfaction est estimee a partir des enquetes effectuees aupres des plaisanciers."
          ),
          helpText(
            "TOTAL : la satisfaction est estimee a partir de la moyenne des deux criteres precedents et de criteres bases sur la gestion (poubelles, sanitaires, interdiction de fumer)."
          ),
          hr(),
          actionButton("predict", "Lancer l'estimation")
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
    ),
    
    
    
    
    
    # TAB 3
    tabPanel(
      "Evolution de la satisfaction",
      
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "month_sat", "Mois", c(
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
          hr(),
          selectInput(
            "crit_sat", "Type de visiteurs", c(
              "Pietons" = 1,
              "Plaisanciers" = 2,
              "Total" = 3
            )
          ),
          helpText(
            "PIETONS : la satisfaction est estimee a partir des enquetes effectuees aupres des pietons."
          ),
          helpText(
            "PLAISANCIERS : la satisfaction est estimee a partir des enquetes effectuees aupres des plaisanciers."
          ),
          helpText(
            "TOTAL : la satisfaction est estimee a partir de la moyenne des deux criteres precedents et de criteres bases sur la gestion (poubelles, sanitaires, interdiction de fumer)."
          )
        ),
        mainPanel(plotOutput("evo_sat"),
                  br(),
                  textOutput("zero_sat"))
      )
    ),
    
    
    
    
    
    # TAB 3
    tabPanel(
      "Evolution de la frequentation",
      
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "month_freq", "Mois", c(
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
          hr(),
          selectInput(
            "type_freq", "Type de frequentation", c("Debarquements" = "debarquements",
                                                    "Plaisanciers" = "bateaux")
          )
        ),
        mainPanel(plotOutput("evo_freq"),
                  br(),
                  textOutput("zero_freq"))
      )
    )
    
    
    
    
    
  )
)
