library(shinyIncubator)

shinyUI(basicPage(
  progressInit(),
  plotOutput('plot'),
  actionButton('go', 'Go')
))