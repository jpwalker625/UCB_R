library(tidyverse)
library(knitr)

source("~/R_workspace/UCB_R/DSPP/Assignments/assignment_3/fix_column_names.R")
options(scipen = 999, digits = 9)

sf.fd <- read_csv("Fire_Department_Calls_for_Service.csv")

colnames(sf.fd) <- fix_column_names(colnames(sf.fd))

sf.fd <- sf.fd %>% within({
  call_number <- factor(call_number)
  call_type <- factor(call_type)
  
})

#A histogram of the call types - we are filtering by distinct call_number since
#a call_number can have multiple entries in the dataset

sf.fd %>% distinct(call_number, .keep_all = TRUE) %>%
  ggplot(aes(call_type)) + 
  geom_histogram(stat = 'count') +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_y_log10(breaks = c(10, 1000, 10000, 100000, 1000000))

call.type.count <- sf.fd %>% distinct(call_number, .keep_all = TRUE) %>% 
  group_by(call_type) %>%
  summarise(count = n())

call.type.count %>%
  arrange(desc(count)) %>%
  kable
