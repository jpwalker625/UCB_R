library(tidyverse)

library(readxl)
library(gdata)
library(XLConnect)

url <- "http://www.stephansorger.com/content/DataScience_7_Case_Posey.xls"

gdata_bp <-  read.xls(url, perl = "C:/Perl/bin/perl.exe", skip = 20)

read.cs

bp_data <- read_xls("posey.xls", sheet = 2)



rbi <- bp_data$RBI

mean(rbi)

median(rbi)

range(rbi)


linear_model <- lm(data = bp_data, formula = `wRC+` ~ R + H + RBI)

summary(linear_model)

#https://www.beyondtheboxscore.com/2014/5/26/5743956/sabermetrics-stats-offense-learn-sabermetrics
#
#https://hbr.org/2013/03/know-the-difference-between-yo