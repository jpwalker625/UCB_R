library(tidyverse)
library(lubridate)

df <- read_csv("Fire_Incidents.csv")

source("C:/workspace/UCB_R/DSPP/Assignments/assignment_3/fix_column_names.R")
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
})

sf.fd <- sf.fd %>%
  mutate(response_time = difftime(arrival_dt_tm, alarm_dt_tm, units = "mins"))



range(sf.fd$response_time, na.rm = TRUE)
#It appears we have some outliers in the data
#It appears that there are cases when the unit has arrived on scene before being dispatched which could lead to the negative values we see, as well as many of the 0's.
#We also see cases where there is a large gap in time between a unit is dispatched and has arrived on the scene.


