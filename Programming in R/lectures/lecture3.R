(v <- c(0,7,3,4,-5,11,0,10,-18,-9))

v%%3 == 0
which(v%%3 ==0)

any(v%%6 ==0)


any(scores[127:132 >.92 || 456:461 > .92])

trunc(1.874)
x <-(rnorm(5,37,54))
x
trunc(x)

seq(rep(from = letters, to = letters, by = 3),5)

a <- rep(letters[(seq(0,26,3))],each = 5)
a

#matrix stuff

m <- matrix(22341:23340,100,10,byrow=TRUE)
head(m)

mbyrow <- matrix(22341:23340,100,10,byrow = TRUE)

#it uses column major

sum(m[47,])

#Recoding & Transforming Variables
v <- c(2,-4,-2,5,-3)
is_neg <- v < 0
is_neg
v[is_neg] <- 0
v[v<0] <- 0
v

#Data Frames
x <- c(2,NA,3,4,5)
print(x)
x[is.na(x)] <- -1
print(x)

