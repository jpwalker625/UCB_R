library(tidyjson)
library(jsonlite)
library(tidyverse)
library(lubridate)

df <- stream_in(file("US_expenditure.json"))


budget.df <- gather(data = df, key = 'year', value = 'value', 13:73)

budget.df$year <- gsub(pattern = "y", replacement = "", x = budget.df$year)

budget.df$year <- parse_date(x = budget.df$year, format = "%Y")
budget.df$year <- year(budget.df$year)
