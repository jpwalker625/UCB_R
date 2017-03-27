library(tidyverse)
library(lubridate)
library(rgdal)
library(shiny)
library(leaflet)
library(spdplyr)

usa.counties.mapping <- readOGR("gz_2010_us_050_00_20m.json")

cal.counties.mapping <- usa.counties.mapping[usa.counties.mapping@data$STATE == '06', ]

employment.stats <- read_tsv("california_counties_monthly_employment_2016.tsv", col_names = T) 

employment.stats$period <- parse_date_time(employment.stats$period, "%Y-%m-%d")

employment.stats$fips_county<- factor(employment.stats$fips_county)

cal.merged <- merge(cal.counties.mapping, employment.stats, by.x = "COUNTY", by.y = "fips_county", duplicateGeoms = TRUE)

bins <- c(0, 2.7, 6, 9, 12, 15, 18, 21, 24, 27, Inf)

shinyServer(function(input, output){
  by.month <- reactive({cal.merged[month(cal.merged$period, label = TRUE) == input$months, ]
    })
  
    output$county.map <- renderLeaflet({
      leaflet(cal.merged) %>%
        addProviderTiles(provider = providers$CartoDB) %>%
        setView(lng = -119.417931, lat = 36.778259, zoom = 5)
      })
    observe({
      
      pal <- colorBin(reverse = TRUE, palette = 'RdBu', domain = by.month()$unemployed_rate, bins = bins, pretty = TRUE)
      
      labels <-paste(by.month()$NAME," ", by.month()$unemployed_rate)
      
      leafletProxy('county.map', data = by.month()) %>%
        clearShapes() %>%
        addPolygons(fillColor = ~pal(unemployed_rate),
                    weight = 2,
                    opacity = 1,
                    color = "white",
                    dashArray = "3",
                    fillOpacity = .7,
                    highlight = highlightOptions(weight = 2,
                                                 fillColor = 'silver',
                                                 color = 'blue',
                                                 fillOpacity = 0.7,
                                                 bringToFront = TRUE),
                    label = labels,
                    labelOptions = labelOptions(style = list("font-weight" = "normal",
                                                              padding = "3px 8px"),
                                                 textsize = "12px",
                                                 direction = "auto")
        ) #end of add Polygons
       
      observe({
          proxy <- leafletProxy("county.map", data = cal.merged)
          
          proxy %>% clearControls()
            pal <- pal
            proxy %>% addLegend(position = "topright",
                                pal = pal,
                                opacity = .7,
                                values = ~unemployed_rate,
                                title = paste('Unemployment Rate for', input$months)
                                )
      })
  
    })
})
  
  