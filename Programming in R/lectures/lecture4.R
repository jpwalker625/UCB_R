# Lecture 4 
# 09/28/2016

ages <- runif(runif(n=10, min = 20, max = 29))
wgts <- rnorm(10,168,10)
score <- rnorm(10,70,10)

df <- data.frame(age_yrs = ages, wgt_lbs = wgts, scr_nrm = score)
print(df)

#Give 3 ways to refer to col 2

df$wgt_lbs
df[,2]
df[,"wgt_lbs"]

df2 <- df[,c(1,3)]

df$wgt_lbs[7] <- 0
df

df$wgt_lbs[df$wgt_lbs > 160 & df$wgt_lbs < 180]
which(df$wgt_lbs >160 & df$wgt_lbs < 180)

m <- matrix(seq(2,20, by = 2),2,5)
m


m1 <- rbind(m[,c(2,4)],m[,1],m[,3])
m1

flist <- list(c('a','b','c'), c(1,2,3),-1)
flist
flist[[2]][3]
