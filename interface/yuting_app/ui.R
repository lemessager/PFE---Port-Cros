library(shiny)
#library(datasets)

shinyUI(
  fluidPage(
    titlePanel("Interface Satisfaction"),
    sidebarLayout(
      sidebarPanel(
        selectInput("sat", "Niveau de satisfaction",
                    choices = c("pieton","nautique","remarque")),
        hr(),
        helpText("Data from the questionnaires")
      ),
      mainPanel(
        plotOutput("satPlot")
      )
    )
  )
)