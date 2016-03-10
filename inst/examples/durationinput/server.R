shinyServer(function(input, output, session) {
  output$durationtxt <- renderPrint({
    input$durationtest
  })
})