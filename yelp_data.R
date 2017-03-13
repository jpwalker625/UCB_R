
library(tidyverse)
library(tidyjson)
library(jsonlite)
library(stringr)

############# Business ##############
business <- stream_in(file("yelp_academic_dataset_business.json"))
biz <- as_tibble(head(business, 100))
glimpse(biz)

bizz <- biz %>% unnest(categories)


p <- ggplot(biz, aes(x = state, fill = as.factor(stars))) +
  geom_bar() +
  coord_flip()
p
############# Check-In ##############
checkin <- stream_in(file("yelp_academic_dataset_checkin.json"))
chkin <- checkin %>% head(100) %>% as_tibble()

############# Reviews ##############
review <- stream_in(file("yelp_academic_dataset_review.json"), verbose = TRUE)
rvw <- rvw %>% head(100) %>% as_tibble()

############# Users ##############
user_data <- stream_in(file("yelp_academic_dataset_user.json"))
user <- user_data %>% head(100) %>% as_tibble()

############# Tips ##############
tip_data <- stream_in(file("yelp_academic_dataset_tip.json"))
tips <- tip_data %>% head(100) %>% as_tibble
