library(tidyverse)
library(tidyjson)
library(purrr)
library(lubridate)
library(stringr)
library(forcats)

moment <- read_json("data/moment.json")

pickups <- moment %>%
  enter_object('days') %>%
  gather_array() %>%
  enter_object('pickups') %>% 
  gather_array %>% 
  spread_values(location_accuracy_in_meters = jnumber("locationAccuracyInMeters"),
                longitude = jnumber("longitude"),
                end_battery_level = jnumber("endingBatteryLevel"),
                length_in_seconds = jnumber("lengthInSeconds"),
                date = jstring("date"),
                latitude = jnumber("latitude"),
                start_battery_level = jnumber("startingBatteryLevel"))

pickups$date <- str_replace(pickups$date, "T", " ")
pickups$date <- str_replace(pickups$date, "-07:00", "")

pickups <- pickups %>% within({
  date <- parse_date_time(date, "%Y-%m-%d %H:%M:$S")
  length_in_minutes <- round(length_in_seconds/60, digits = 2)
  month <- factor(month(date, label = TRUE, abbr = FALSE))
  day <- factor(day(date))
  weekdays <- factor(weekdays(date))
  weekdays <- fct_relevel(weekdays, "Monday", "Tuesday", "Wednesday", 
                           "Thursday", "Friday", "Saturday", "Sunday")
  battery_use <- (start_battery_level - end_battery_level) * 100
})

time_of_day <- function(x){
  if(x %>% between(0,10)){
    "morning"
  } else if(x %>% between(11, 14)){
    "mid-day"
  } else if(x %>% between(15, 18)){
    "afternoon"
  } else if(x %>% between(19, 23)){
    "evening"
  }
}
#apply function to the new column
pickups$time_of_day <- map_chr(.x = hour(pickups$date), .f = time_of_day)
pickups$time_of_day <- factor(pickups$time_of_day)
pickups$time_of_day <- pickups$time_of_day %>% fct_relevel("morning","mid-day", "afternoon","evening")
pickups$latitude <- round(pickups$latitude, digits = 2)
pickups$longitude <- round(pickups$longitude, digits = 2)

pickups <- pickups %>%
  select(-document.id, -array.index)
pickups <- pickups %>% select(order(colnames(pickups)))
