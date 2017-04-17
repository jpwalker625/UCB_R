library(tidyverse)
library(tidyjson)
library(jsonlite)
library(purrr)
library(lubridate)
library(stringr)
library(forcats)

moment <- tidyjson::read_json("moment.json")

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

######Pick Ups#######



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
  date <- parse_date_time(date, "%Y-%m-%d %H:%M:S")
  length_in_minutes <- length_in_seconds/60
  month <- factor(month(date, label = TRUE, abbr = TRUE))
  day <- factor(day(date))
  weekdays <- factor(weekdays(date))
  weekdays <- fct_relevel(weekdays, "Monday", "Tuesday", "Wednesday", 
                           "Thursday", "Friday", "Saturday", "Sunday")
})

daily_pickups <- pickups %>%
  group_by(month, day, weekdays) %>%
  summarise(pickups = n(),
            length_in_minutes = sum(length_in_minutes)) %>% 
  ungroup

#This index will allow me to arrange the dates in order when I plot them.
daily_pickups <- daily_pickups %>%
  mutate(row.index = seq(from = 1, to = length(pickups), by = 1))

# avg. number of pickups per day
avg.pickups <- mean(daily_pickups$pickups)

#plot pickups by day
daily_pickups %>% ggplot(aes(x = fct_reorder(interaction(month,day,sep = " - "),x = row.index), y = pickups, group = weekdays)) +
    geom_bar(stat = 'identity', aes(fill = weekdays)) +
  geom_line(y = avg.pickups, linetype = 3) +
  labs(title = "Total Pickups per Day", 
       subtitle = "dashed line = global average",
       x = "Date",
       y = "Pickups") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, face = "bold"),
        axis.text.y = element_text(face = "bold"),
        axis.title = element_text(face = "bold"),
        legend.title = element_text(face = "bold"))



#pickups by weekday
pickups.by.weedkay <- daily_pickups %>%
  group_by(weekdays) %>%
summarise(pickups = sum(pickups))

#avg. pickups by weekday
avg_by_weekday <- daily_pickups %>%
  group_by(weekdays) %>%
  summarise(avg_pickups = mean(pickups))

pickups.by.weedkay%>%
  ggplot(aes(x = weekdays, y = pickups)) +
  geom_bar(stat= "identity", aes(fill = weekdays)) +
  geom_point(data = avg_by_weekday, 
             aes(x= weekdays, y = avg_pickups), 
             shape = 23,
             size = 2,
             color = 'black',
             fill = 'red') +
  scale_y_continuous(breaks = c(0,25,50,75,100,125)) +
  labs(title = "Total Number of Pickups Aggregated by Weekday", 
       subtitle = "Red Diamonds denote Averages",
       x = "Weekdays", y = "Pickups") +
  theme(axis.text.x = element_text(face = "bold"),
        axis.text.y = element_text(face = "bold"),
        axis.title = element_text(face = "bold"),
        legend.title = element_text(face = "bold"))


####time
#calculate avg length of time spent on phone per day
avg.time.per.day <- mean(daily_pickups$length_in_minutes)

#calculate avergae time spent per pickup
avg.time.per.pickup <- sum(daily_pickups$length_in_minutes)/sum(as.numeric(daily_pickups$pickups))

#calculate average time spent per pickup, per day
daily_pickups <- daily_pickups %>%
  mutate(avg = length_in_minutes/pickups)

daily_pickups %>% ggplot(aes(x = fct_reorder(interaction(month,day,sep = " - "),x = row.index),
                             y = length_in_minutes, 
                             group = weekdays)) +
  geom_bar(stat = 'identity', aes(fill = weekdays)) +
  geom_line(y = avg.time.per.day, linetype = 3) +
  geom_point(aes(y = avg)) +
  labs(title = "Time Spent on Phone Each Day", 
       #subtitle = "dashed line = global average",
       x = "Date",
       y = "Pickups") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, face = "bold"),
        axis.text.y = element_text(face = "bold"),
        axis.title = element_text(face = "bold"),
        legend.title = element_text(face = "bold"))


avg.time.per.pickup.per.day %>%
  ggplot(aes(x = fct_reorder(interaction(month,day,sep = " - "),x = row.index), 
             y = avg)) +
  geom_point()



##plot sum lentgth_time pickups by weekday

####Avg. length of pickups
pickup_time <- pickups %>%
  group_by(month = month(date, label = TRUE, abbr =TRUE), day = day(date), weekdays = weekdays(date)) %>%
  summarise(average_pickup_time = mean(length_in_seconds)/60) %>%
  ungroup()

pickup_time <- pickup_time %>%
  mutate(row.index = seq(from = 1, to = length(average_pickup_time), by = 1))

pickup_time <- pickup_time %>% within({
  month <- factor(month)
  day = factor(day)
  weekdays <- factor(weekdays)
  weekdays <- fct_relevel(weekdays, "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
})

# plot avg. pickup time by day
pickup_time %>% ggplot(aes(x = fct_reorder(interaction(month,day,sep = " - "),x = row.index), y = average_pickup_time)) +
  geom_bar(stat = 'identity', aes(fill = weekdays)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

# plot avg. pickuptime by weekday
pickups %>% group_by(weekdays = weekdays(date)) %>%
  summarise(mean_pickup_time = mean(length_in_seconds)/60) %>%
  ggplot(aes(x = weekdays, y = mean_pickup_time)) +
  geom_bar(stat = 'identity', aes(fill = weekdays)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

  