library(tidyjson)
library(jsonlite)
library(tidyverse)

events <- read_lines("berkeley_event-export.json")

rm(event_keys)


prettify(events)


events <- "berkeley_event-export.json" %>% gather_array() %>%
  spread_values(name = jstring("name"),
                distinct_id = jstring("distinct_id"),
                time = jstring("time"),
                sampling_factor = jnumber("sampling_factor"),
                browser = jstring("properties", "$browser"),
                browser_version = jnumber("properties", "$browser_version"),
                city = jstring("properties", "$city"),
                current_url = jstring("properties", "$current_url"),
                initial_referrer = jstring("properties", "initial_referrer"),
                initial_referring_domain = jstring("properties", "$initial_referring_domain"),
                lib_version = jstring("properties", "$lib_version"),
                os = jstring("properties", "$os"),
                referrer = jstring("properties", "$referrer"),
                referring_domain = jstring("properties", "$referring_domain"),
                region = jstring("properties", "$region"),
                screen_height = jnumber("properties", "$screen_height"),
                screen_width = jnumber("properties", "$screen_width"),
                page_name = jstring("properties", "Page Name"),
                Plan = jstring("properties", "Plan"),
                mp_country_code = jstring("properties", "mp_country_code"),
                mp_lib = jstring("properties", "mp_lib")) %>%
                  enter_object("labels") %>%
                  spread_values(labels = jstring("labels"))

people <- read_lines("berkeley_people-export.txt")
prettify(people)

people <- "berkeley_people-export.txt" %>% 
  gather_array() %>% 
  spread_values(distinct_id = jstring("distinct_id"),
                time = jnumber("time"),
                last_seen = jnumber("last_seen"),
                browser = jstring("properties", "$browser"),
                browser_version = jnumber("properties", "$browser_version"),
                city = jstring("properties", "$city"),
                country_code = jstring("properties", "$country_code"),
                email = jstring("properties", "$email"),
                initial_referrer = jstring("properties", "$initial_referrer"),
                initial_referring_domain = jstring("properties", "$initial_referring_domain"),
                name = jstring("properties", "$name"),
                os = jstring("properties", "$os"),
                region = jstring("properties", "$region"),
                timezone = jstring("properties", "$timezone"),
                favorite_genre = jstring("properties", "Favorite Genre"),
                first_login_date = jstring("properties", "First Login Date"),
                lifetime_song_play_count = jnumber("properties", "Lifetime Song Play Count"),
                lifetime_song_purchase_count = jnumber("properties", "Lifetime Song Purchase Count"),
                Plan = jstring("properties", "Plan")) %>%
  enter_object('properties') %>% 
  enter_object("$transactions") %>%
  gather_array() %>% 
  spread_values(transactions_amount = jnumber("$amount"),
                transactions_time = jstring("$time"))

#when the empty 'labels' array is included, the data frame returns null values 
#enter_object('labels') %>%
# spread_values(labels = jstring("labels"))

  #######################################
  
events_people <- full_join(events, people, by = "distinct_id")




people <- "berkeley_people-export.txt" %>% 
  gather_array() %>% 
  spread_values(distinct_id = jstring("distinct_id")) %>%
  enter_object("properties") %>%
  spread_values(browser = jstring("$browser")) %>%
  enter_object("$transactions") %>%
  gather_array() %>%
  spread_values(amount = jnumber("$amount"))
