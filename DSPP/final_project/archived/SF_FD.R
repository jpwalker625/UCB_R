library(tidyverse)
library(knitr)
library(lubridate)

source("~/R_workspace/UCB_R/DSPP/Assignments/assignment_3/fix_column_names.R")
options(scipen = 999, digits = 9)

sf.fd <- read_csv("Fire_Department_Calls_for_Service.csv")

#fix column names to snake case
colnames(sf.fd) <- fix_column_names(colnames(sf.fd))

#filter data for only 2016 records
sf.fd$call_date <- parse_date_time(sf.fd$call_date, "%m-%d-%Y")

sf.2016 <- sf.fd %>% filter(year(call_date) == '2016')

#function to more easily posixtime the date-time variables
parse.date <- function(x){
  x <- parse_date_time(x, "%m-%d-%Y %H:%M:%S %p")
}


sf.2016 <- sf.2016 %>% within({
  call_number <- factor(call_number)
  call_type <- factor(call_type)
  received_dt_tm <- parse.date(received_dt_tm)
  entry_dt_tm <- parse.date(entry_dt_tm)
  dispatch_dt_tm <- parse.date(dispatch_dt_tm)
  response_dt_tm <- parse.date(response_dt_tm)
  on_scene_dt_tm <- parse.date(on_scene_dt_tm)
  transport_dt_tm <- parse.date(transport_dt_tm)
  hospital_dt_tm <- parse.date(hospital_dt_tm)
  available_dt_tm <- parse.date(available_dt_tm)
  battalion <- factor(battalion)
  neighborhood_district <- factor(neighborhood_district)
})
  

#Average length of time between call received and dispatch time

sf.2016 <- sf.2016 %>%
  mutate(dispatch_time = difftime(dispatch_dt_tm, received_dt_tm, units = "mins"),
         response_time = difftime(response_dt_tm, dispatch_dt_tm, units = "mins"),
         on_scene_time = difftime(on_scene_dt_tm, dispatch_dt_tm, units = "mins"),
         total_time = difftime(on_scene_dt_tm, received_dt_tm, units = "mins"))


#Many of the records contain errors on the fire department record entry side.
#There appears to be a system glitch in which "04/25/2016 is entered.

#example

sf.2016 %>% filter(row_id %in% c('160010009-KM06', '160010015-E09')) %>%
  select(call_type, received_dt_tm, dispatch_dt_tm,response_dt_tm, on_scene_dt_tm, transport_dt_tm)

sf.2016 %>% ggplot(aes(x = call_type, y = total_time)) +
  geom_point()

by.unit_type <- sf.2016 %>%
  filter(total_time > 0, total_time < 360) %>%
  group_by(call_type, unit_type) %>%
  summarise(mean_response_time = mean(total_time))


#proportion of erroneous records
(erroneous.records/count(sf.2016)) * 100

test <- sf.2016 %>% group_by(call_type) %>%
  filter(total_time > 0)

#Average Dispatch Time for 2016
sf.2016 %>%
  summarise(mean_dispatch_time = round(mean(dispatch_time, na.rm = TRUE), digits = 2))

#Average Dispatch Time by call_type
 sf.2016 %>%
  group_by(call_type) %>%
  summarise(mean_dispatch_time = round(mean(dispatch_time), digits = 2)) %>%
  arrange(mean_dispatch_time) %>%
  kable(digits = 2, align = "c", col.names = c("Call Type", "Average Dispatch Time"), caption = "Average Dispatch Time (in minutes) by Call Type")



mean.table <- sf.2016 %>%
  group_by(call_type) %>%
  summarise(mean_dispatch_time = round(mean(dispatch_time, na.rm = TRUE), digits = 2),
            mean_response_time = round(mean(response_time, na.rm = TRUE), digits = 2),
            mean_on_scene_time = round(mean(on_scene_time, na.rm = TRUE), digits = 2),
            mean_total_time = round(mean(total_time, na.rm = TRUE), digits = 2))

mean.table





#######################

#A histogram of the call types - we are filtering by distinct call_number since
#a call_number can have multiple entries in the dataset

sf.2016 %>% distinct(call_number, .keep_all = TRUE) %>%
  ggplot(aes(call_type)) + 
  geom_histogram(stat = 'count') +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_y_log10(breaks = c(10, 1000, 10000, 100000))

call.type.count <- sf.2016 %>% distinct(call_number, .keep_all = TRUE) %>% 
  group_by(call_type) %>%
  summarise(count = n())

call.type.count %>%
  arrange(desc(count)) %>%
  kable
