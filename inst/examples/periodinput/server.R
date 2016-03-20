shinyServer(function(input, output, session) {
  output$periodtxt <- renderPrint({
    input$periodtest
  })
})