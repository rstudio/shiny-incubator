shinyUI(fluidPage(
  fluidRow(
    durationInput(inputId = "durationtest", label = "unused label", step = 5),
    verbatimTextOutput("durationtxt")
  )
))