#helpers for the california counties shiny app

library(shiny)
library(tidyverse)
library(forcats)
library(lubridate)
library(rgdal)
library(leaflet)
library(sp)
library(spdplyr)
library(htmltools)

#Snake Case Function
fix_column_names <- function(x){
  s <- gsub("properties\\.\\$", "", x) # remove the 'properties.$' from beginning of colname
  s <- gsub("\\<properties\\>(.)", "", s) # remove properies(.) jargon where
  s <- gsub("\\.", "_", s) # replace '.' with '_'
  s <- gsub("(.)([A-Z][a-z]+)", "\\1_\\2", s) # separate with underscores on capitalization
  s <- tolower(gsub("([a-z0-9])([A-Z])", "\\1_\\2", s)) # lowercase
  s <- gsub("__", "_", s) # double underscore to single underscore
  s <- gsub("^[_, .]", " ", s, fixed = TRUE) # delete first char underscore "_" or period "."
  s <- gsub(' ', '', s) # remove spaces
}

usa.counties.mapping <- readOGR(dsn = "data/gz_2010_us_050_00_20m.json")

colnames(usa.counties.mapping@data) <- fix_column_names(colnames(usa.counties.mapping@data))

cal.counties.mapping <- usa.counties.mapping[usa.counties.mapping@data$state == '06', ]

employment.stats <- read_tsv("data/california_counties_monthly_employment_2016.tsv", col_names = T) 
colnames(employment.stats) <- fix_column_names((colnames(employment.stats)))

employment.stats$period <- parse_date_time(employment.stats$period, "%Y-%m-%d")

employment.stats$fips_county<- factor(employment.stats$fips_county)

cal.merged <- sp::merge(cal.counties.mapping, 
                        employment.stats, by.x = "county", 
                        by.y = "fips_county",
                        duplicateGeoms = TRUE)

cal.merged$period <- month(cal.merged$period, label = TRUE)
