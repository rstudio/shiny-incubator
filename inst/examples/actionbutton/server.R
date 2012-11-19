shinyServer(function(input, output) {
  output$plot <- reactivePlot(function() {
    input$button1
    hist(rnorm(20))
  })
})