library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("My First Shiny App"),
  sidebarLayout(sidebarPanel(
    sliderInput("Diamonds_Data","Carats:",
              min = min(diamonds$carat),
              max = max(diamonds$carat),
              value = min(diamonds$carat))
  ),
  mainPanel(
    textOutput("Diamonds_Data"),
    plotOutput("ShowMeAPlot")
    ))))
