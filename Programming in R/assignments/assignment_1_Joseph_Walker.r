setwd("c:/workspace/UCB_R")
#This is the first assignment
install.packages("Hmisc")
library(Hmisc)

name <- Joseph Walker

email.address <- jpwalker625@gmail.com

class <- Programming with R, UC Berkely, Fall 2016

Assn <- Assignment 1 (Part 3)

set.seed(1211)

x <- rnorm(100,.75,.38)

set.seed(341)
y<-rnorm(100,2.25,1.6)
z <- data.frame( x = x, y= y)

print(describe(z))
# z 
# 
# 2  Variables      100  Observations
# --------------------------------------------------
#   x 
# n missing  unique    Info    Mean     .05 
# 100       0     100       1  0.7044  0.1557 
# .10     .25     .50     .75     .90     .95 
# 0.2862  0.4761  0.6741  0.9455  1.1127  1.1995 
# 
# lowest : -0.07415 -0.02863  0.07915  0.12995  0.15001
# highest:  1.23998  1.39211  1.45345  1.62906  1.85413 
# --------------------------------------------------
#   y 
# n missing  unique    Info    Mean     .05 
# 100       0     100       1   2.241 -0.7679 
# .10     .25     .50     .75     .90     .95 
# 0.1988  1.0500  2.2141  3.5662  4.5863  5.0310 
# 
# lowest : -2.4186 -1.5945 -1.0598 -0.9596 -0.9206
# highest:  5.0594  5.0615  5.1020  5.3586  5.7311
print(round(z[54,],2))
#      x    y
#  54 0.16 2.54