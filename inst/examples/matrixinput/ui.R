library(shiny)
library(shinyIncubator)

shinyUI(pageWithSidebar(
  headerPanel('Simple matrixInput example'),
  sidebarPanel(
    matrixInput('foo', 'Foo', head(cars))
  ),
  mainPanel(
    plotOutput(outputId='plot')
  )
))
