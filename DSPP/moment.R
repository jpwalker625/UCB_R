library(tidyjson)
library(jsonlite)
library(purrr)
moment <- read_json("moment.json")

df <- moment %>% 
  enter_object('days') %>% 
  gather_array() %>% 
  spread_values(minuteCount = jnumber('minuteCount'),
                pickupCount = jnumber('pickupCount'),
                date = jstring('date'),
                sessions = jstring('sessions'),
                pickups = jstring('pickups'),
                appusages = jstring('appUsages'))


sessions <- moment %>%
  enter_object('days') %>%
  gather_array() %>%
  spread_values(minuteCount = jnumber('minuteCount'),
                pickupCount = jnumber('pickupCount'),
                date = jstring('date')) %>%
  enter_object('sessions') %>% 
  gather_array %>%
  spread_values(location_accuracy_in_meters = jnumber("locationAccuracyInMeters"),
                length_mins = jnumber("lengthInMinutes"),
                lat = jnumber("latitude"),
                long = jnumber("longitude"),
                date_sessions = jstring("date"))

pickups <- moment %>%
  enter_object('days') %>%
  gather_array() %>%
  spread_values(minuteCount = jnumber('minuteCount'),
                pickupCount = jnumber('pickupCount'),
                date = jstring('date')) %>%
  enter_object('pickups') %>% 
  gather_array %>% 
  spread_values(location_accuracy_in_meters = jnumber("locationAccuracyInMeters"),
                long = jnumber("longitude"),
                end_battery_level = jnumber("endingBatteryLevel"),
                length_in_seconds = jnumber("lengthInSeconds"),
                date_pickups = jstring("date"),
                lat = jnumber("latitude"),
                start_battery_level = jnumber("startingBatteryLevel"))


app_usages <-  moment %>%
  enter_object('days') %>%
  gather_array() %>%
  spread_values(minuteCount = jnumber('minuteCount'),
                pickupCount = jnumber('pickupCount'),
                date = jstring('date')) %>%
  enter_object('appUsages') %>%
  gather_array() %>%
  spread_values(app_name = jstring("appName"),
                on_screen = jnumber("onScreen"))

