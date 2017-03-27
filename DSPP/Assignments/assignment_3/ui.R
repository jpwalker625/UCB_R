library(shiny)
library(leaflet)



shinyUI(fluidPage(
  titlePanel("California Counties Employment Statistics - 2016"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "months", label = "select month", choices = sort(month(cal.merged$period, label = TRUE))
                  )# end of select input
      ), #end of side bar panel
      mainPanel("This is where the map goes",
                textOutput('text'),
                leafletOutput('counties.map'))
    )))

