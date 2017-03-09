######Using Twitter to get Presidential nominee Data



library(twitteR)
library(data.table)
library(ggmap)

consumer_key <- "3Tgqk4t78UmODhU3vbTWamElD"
consumer_secret <- "44pRNwbR7mVtdLgd9qs7PzlSo4MV1a1wYifglvLXhZ0UDmZOkl"
access_token <- "796792938441285632-ujzYF5nrJCTMgl8XresjIHLyT2jVGHa"
access_secret <- "AeeeC6lYIoAUnuDekAiMUQFAOheSkDEYJ15kaTsBmiYIS"
options(httr_oauth_cache = TRUE)

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

HC <- getUser(user = 'HillaryClinton')

HC_Followers <- HC$getFollowers(n = 100000)
hc_df <-rbindlist(lapply(HC_Followers,as.data.frame))

####SAVE DATA In Table
write.csv(x = hc_df, file = 'hillary_twitter_users_data.csv')

####Get rid of cases where no location is listed
hc_df <- subset(hc_df,hc_df$location != "")

hc_df$location <- gsub("%", "",hc_df$location)

###run modified geocode form github to use google map api

source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/geocode_helpers.R")
source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/modified_geocode.R")

geocode_apply<-function(x){
  geocode(x, source = "google", output = "all", api_key="AIzaSyAmvZwr7wHBHKNcoooeRehA5g-m-XkMavU")
}

#geocode locations of Hillary followers, limited to 2500 per day due to google API
geocode_results <- sapply(hc_df$location, geocode_apply, simplify = FALSE)
length(geocode_results)
test<-rbindlist(lapply(geocode_results, as.data.frame))

####parse successful geocodes
condition_a <- sapply(geocode_results, function(x) x["status"]=="OK")
geocode_results <- condition_a

mytable <- data.frame(table(hc_df$location))
