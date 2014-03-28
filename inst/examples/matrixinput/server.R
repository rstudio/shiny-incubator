library(shiny)

shinyServer(function(input, output) {
  output$plot <- renderPlot({
    plot(input$foo)
  })
})
