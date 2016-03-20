library(shinyIncubator)
shinyUI(fluidPage(
  fluidRow(
    durationInput(
      inputId = "durationtest", 
      label = "label", 
      step = 5,
      value = 100
    ),
    verbatimTextOutput("durationtxt")
  )
))