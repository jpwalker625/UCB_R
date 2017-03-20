library(tidyverse)
library(forcats)
library(lubridate)

df <- read_csv("sf_oak_metro.csv", col_names = T)

sf_oak <- gather(df, Date, Value, 2:325)
sf_oak$Date <- parse_date_time2(sf_oak$Date,'%b %Y')
sf_oak$month <- month(sf_oak$Date,label = TRUE)
sf_oak$year <- as.factor(year(sf_oak$Date))

sf_oak$`Series ID` <- as.factor(sf_oak$`Series ID`)
sf_oak$`Series ID` <- fct_recode(sf_oak$`Series ID`, 
                     first = 'LAUMT064186000000003')

first_sf_oak <- sf_oak %>% filter(`Series ID` == 'first')

first_sf_oak %>%
  ggplot(aes(x = month, y = Value)) +
  geom_line(aes(group = year, color = year))
  



