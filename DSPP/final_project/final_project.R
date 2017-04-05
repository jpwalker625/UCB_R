library(tidyjson)
library(jsonlite)
library(tidyverse)
library(lubridate)
library(stringr)

df <- stream_in(file("US_expenditure.json"))


budget.df <- gather(data = df, key = 'year', value = 'value', 13:73)

budget.df <- within(budget.df, {
  year <- gsub(pattern = "y", replacement = "", x = year)
  year <- parse_date(x = year, format = "%Y")
  year <- year(year)
  value <- str_replace(string = value, pattern = ",", replacement = "")
  value <- as.numeric(value)
  }) 
  

agency.spending <- budget.df %>% 
  group_by(agency_name, year) %>% 
  summarise(spending = sum(value, na.rm = TRUE)) %>% 
  ungroup() %>%
  group_by(agency_name)


ggplot(agency.spending, aes(x = year, y = spending, color = agency_name, group = agency_name)) +
  geom_point() +
  geom_line()
