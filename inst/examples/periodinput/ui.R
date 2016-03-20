library(shinyIncubator)
shinyUI(fluidPage(
  fluidRow(
    periodInput(
      inputId = "periodtest", 
      label = "label", 
      step = 5,
      value = list(
        hour = 1,
        minute = 10,
        seconds = 55
      )
    ),
    verbatimTextOutput("periodtxt")
  )
))