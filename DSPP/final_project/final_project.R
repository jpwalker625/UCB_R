library(tidyverse)
library(lubridate)
library(knitr)
library(stringr)

df <- read_csv("Fire_Incidents.csv")

fix_column_names <- function(x){
  s <- gsub("properties\\.\\$", "", x) # remove the 'properties.$' from beginning of colname
  s <- gsub("\\<properties\\>(.)", "", s) # remove properies(.) jargon where
  s <- gsub("\\.", "_", s) # replace '.' with '_'
  s <- gsub("(.)([A-Z][a-z]+)", "\\1_\\2", s) # separate with underscores on capitalization
  s <- tolower(gsub("([a-z0-9])([A-Z])", "\\1_\\2", s)) # lowercase
  s <- gsub("__", "_", s) # double underscore to single underscore
  s <- gsub("^[_, .]", "", s) # delete first char underscore "_" or period "."
  s <- gsub(' ', '', s) # remove spaces
}

#Fix Column Names of DF by converting to snake case
colnames(df) <- fix_column_names(colnames(df))

#cache
sf.fd <- df

parse.date <- function(x){
  x <- parse_date_time(x, "%m/%d/%Y %H:%M:%S %p!")
}


sf.fd <- sf.fd %>% within({
  incident_date <- parse_date_time(incident_date, "%m/%d/%Y")
  alarm_dt_tm <- parse.date(alarm_dt_tm)
  arrival_dt_tm <- parse.date(arrival_dt_tm)
  close_dt_tm <- parse.date(close_dt_tm)
  primary_situation <- factor(primary_situation)
  neighborhood_district <- factor(neighborhood_district)
})

####separate location into lat & long
sf.fd <- sf.fd %>% separate(location, into = c("longitude", "latitude"), ", ")
sf.fd$longitude <- str_replace(sf.fd$longitude, pattern = "\\(", replacement = "")
sf.fd$latitude <- str_replace(sf.fd$latitude, pattern = "\\)", replacement = "")

calls.by.year <- sf.fd %>%
  group_by(month(incident_date, label = TRUE), year(incident_date)) %>%
  summarise(count = n())

calls.by.year <- calls.by.year %>% rename(month = `month(incident_date, label = TRUE)`, year = `year(incident_date)`)

calls.by.year$year <- factor(calls.by.year$year)
calls.by.year %>%
  ggplot(aes(x = month, y = count, group = year, color = year)) +
  geom_point() +
  geom_line()

#2014 appears to be an odd year with lower than average calls at the beginning of the year and a sharp spike toward the end


#####Explore Primary_Situations
length(levels(sf.fd$primary_situation))
#Whoa! That's a lot of unique call types. Let's see if we can pick out the most frequent types of calls for each year

sf.fd %>% 
  group_by(year = year(incident_date), primary_situation) %>%
  summarise(count = n()) %>%
  group_by(year) %>%
  top_n(n = 1) %>% 
  kable(align = "c", caption = 'Most Frequent Call Types per Year')
  
#####Explore Neighborhoods
#Bin by Direction or Bin by Amount of Calls (most, least, average)
levels(sf.fd$neighborhood_district)
North <- 
South <-
East <- 
West <-
Central <- 

#####investigate response times
mutate(response_time = difftime(arrival_dt_tm, alarm_dt_tm, units = "mins"))



range(sf.fd$response_time, na.rm = TRUE)
#It appears we have some outliers in the data
#It appears that there are cases when the unit has arrived on scene before being dispatched which could lead to the negative values we see, as well as many of the 0's.
#We also see cases where there is a large gap in time between a unit is dispatched and has arrived on the scene.


