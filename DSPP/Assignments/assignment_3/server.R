library(shiny)
library(leaflet)
library(spdplyr)
usa.counties.mapping <- readOGR("gz_2010_us_050_00_20m.json")

cal.counties.mapping <- usa.counties.mapping[usa.counties.mapping@data$STATE == '06', ]

employment.stats <- read_tsv("california_counties_monthly_employment_2016.tsv", col_names = T) 

employment.stats$period <- parse_date_time(employment.stats$period, "%Y-%m-%d")

employment.stats$fips_county<- factor(employment.stats$fips_county)

cal.merged <- merge(cal.counties.mapping, employment.stats, by.x = "COUNTY", by.y = "fips_county", duplicateGeoms = TRUE)


shinyServer(function(input, output){
  selectedData <- reactive({cal.merged %>% filter(month(period, label = TRUE) == input$months)
    })
  
  
  })
  
  

  
  