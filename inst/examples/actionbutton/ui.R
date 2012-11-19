shinyUI(pageWithSidebar(
  headerPanel("Action button example"),
  sidebarPanel(
    actionButton("button1", "New samples")
  ),
  mainPanel(
    plotOutput("plot")
  )
))