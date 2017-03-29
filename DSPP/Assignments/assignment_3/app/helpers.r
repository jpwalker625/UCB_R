#helpers for the california counties shiny app
source("helpers.r")

library(tidyverse)
library(forcats)
library(lubridate)
library(rgdal)
library(leaflet)
library(sp)
library(htmltools)


usa.counties.mapping <- readOGR("~/gz_2010_us_050_00_20m.json")

cal.counties.mapping <- usa.counties.mapping[usa.counties.mapping@data$STATE == '06', ]


employment.stats <- read_tsv("california_counties_monthly_employment_2016.tsv", col_names = T) 

employment.stats$period <- parse_date_time(employment.stats$period, "%Y-%m-%d")

employment.stats$fips_county<- factor(employment.stats$fips_county)

cal.merged <- merge(cal.counties.mapping, employment.stats, by.x = "COUNTY", by.y = "fips_county", duplicateGeoms = TRUE)


##we want to visaulize the unemployment rate data for month of december
#map the data
range(cal.merged$unemployed_rate)

bins <- c(0, 2.7, 6, 9, 12, 15, 18, 21, 24, Inf)

pal <- colorBin(palette = topo.colors(10), domain = cal.merged$unemployed_rate, bins = bins)

labels <- sprintf("<strong>%s</strong><br/>%g%%", cal.merged$NAME, cal.merged$unemployed_rate) %>%
  lapply(htmltools::HTML)


counties.map <- leaflet(cal.merged) %>%
  addProviderTiles(provider = providers$CartoDB) %>%
  addPolygons(fillColor = ~pal(cal.merged$unemployed_rate),
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
                                          direction = "auto")) %>%
  addLegend(position = 'topright', 
            pal = pal, 
            values = ~cal.merged$unemployed_rate,
            title = 'Unemployment Rate',
            opacity = 0.7)

counties.map
