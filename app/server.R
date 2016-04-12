
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source('helpers.R')

shinyServer(function(input, output) {
  
  df <- reactive({
    survival(n = as.numeric(input$n), 
             p = as.numeric(input$p), 
             prev = as.numeric(input$prev), 
             d = as.numeric(input$d))
  })

  output$plot1 <- renderPlot({
    x <- df()
    visualize_survival(df = x)
  })
  
  output$plot2 <- renderPlot({
    x <- df()
    visualize_bites(df = x)
  })

})
