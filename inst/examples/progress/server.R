library(ggplot2)
library(shinyIncubator)

shinyServer(function(input, output, session) {
  
  output$plot <- renderPlot({
    input$go
    
    progress <- Progress$new(session)
    Sys.sleep(1)
    progress$set(message = 'Step one', value = 0.2)
    Sys.sleep(1)
    progress$set(detail = 'frobincating...', value = 0.3)
    Sys.sleep(1)
    progress$set(value = 0.5)

    withProgress(session, {
      setProgress(message = 'Also this', detail = "It's really important")
      Sys.sleep(1)
      setProgress(value = 0)
      for (i in 1:10) {
        setProgress(value = 0.1 * i)
        Sys.sleep(0.1)
      }
    })
    withProgress(session, {
      setProgress(message = 'And this also', detail = "It's super critical")
      Sys.sleep(1)
      setProgress(value = 0)
      for (i in 1:10) {
        setProgress(value = 0.1 * i)
        withProgress(session, {
          setProgress(message = paste('me too', i))
          Sys.sleep(0.1)
        })
      }
    })

    Sys.sleep(1)
    progress$set(value = 0.75)
    Sys.sleep(1)
    progress$set(value = 1)
    progress$close()
    
    print(qplot(cars$speed, cars$dist))
  })
})