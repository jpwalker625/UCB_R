library(tidyverse)
library(stringr)
library(leaflet)
library(rvest)

#retrieve U.S. Space Failities DataSet
facilities <- read.csv("https://query.data.world/s/cwdvqd4rv7ud4io1hdo46pkg2",header=T)
facilities$location <- str_extract(string = facilities$Location, pattern = "\\(\\d.*\\)")

facilities <- facilities %>% mutate(latitude = substr(facilities$location, start = 2, stop = 10),
                                   longitude = substr(facilities$location, start = 12, stop = 23))

facilities$latitude <- str_replace(facilities$latitude, ',', '')
facilities$longitude <- str_replace(facilities$longitude, '\\)', '')

facilities$latitude <- as.numeric(facilities$latitude)
facilities$longitude <- as.numeric(facilities$longitude)

satellites <- read_csv("UCS_Satellite_Database_7-1-16.csv",col_names = T)

ggplot(satellites, aes(x = `Country of Operator/Owner`)) +
  geom_histogram(stat = 'count') +
  theme(axis.text.x = element_text(angle = 90)) +
  coord_flip()

per_country <- satellites %>%
  group_by(`Country of Operator/Owner`) %>%
  count()
  
USA <-  satellites %>%
  filter(`Country of Operator/Owner` == 'USA') %>%
  group_by(Users, Purpose) %>%
  count() 

ggplot(USA, aes(x = Users, y = n, fill = Purpose)) +
  geom_bar(stat = 'identity',position = 'dodge') +
  theme(axis.text.x = element_text(angle = 45,vjust = .9, hjust = 1))

US_Center <- as.numeric(c('39.8282', '-95.5795'))

nasa.icon <- awesomeIcons(library = 'fa', icon = 'space-shuttle',spin = T, squareMarker = T)

m <- facilities %>%
  leaflet() %>%
  addProviderTiles(provider = providers$Esri.NatGeoWorldMap) %>%
  setView(lng = US_Center[2], lat = US_Center[1], zoom = 3) %>%
  setMaxBounds(lng1 =-130, lng2 = -58, lat1 = 49, lat2 =23 ) %>%
  addAwesomeMarkers(icon = nasa.icon, label = paste(facilities$Center))
m

