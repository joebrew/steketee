
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Simplifying the complexity of malaria eradication"),
  h4('Inspired by Rick Steketee'),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      textInput("n",
                "Number of mosquitoes",
                value = 100),
      sliderInput("p",
                  "Daily mosquito survival rate (%)",
                  min = 0, max = 100, value = 85),
      sliderInput("prev",
                  "Human parasitemia rate (%)",
                  min = 0,
                  max = 100,
                  value = 50),
      sliderInput("d",
                  "Days to examine",
                  min = 1, max = 50, value = 30)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot1"),
      plotOutput("plot2")
    )
  ),
  h5("Full code available at", 
     a("https://github.com/joebrew/steketee", href="https://github.com/joebrew/steketee"))
))
