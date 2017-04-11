library(dplyr)
library(purrr)
library(forcats)
df <- data.frame(x = factor(c(1,1,1,2,2,2,3,3,3)), 
                 district = factor(c("Richmond", "Marina", "Sunset", "Richmond", "Richmond", "Marina", "Marina", "Sunset", "Marina")))


north <- c("Richmond", "Marina")



df <- df %>%
  mutate(direction = for(i in df$district){
    if(df$district[i] %in% north){
    "north" 
    } else {
      "south"
    }
    })

df <-  mutate(df, direction = ifelse(df$district %in% north, "North", "South"))

