#Lecture 6 - 10/12/2016

v <- 1:10
v[12] <- 12
#NA is a value
v
v[11]

#mean
mean(v) #returns NA because you can't take the average of a vector with an NA
mean(v,na.rm = TRUE)

#median
median(v)
median(v,na.rm = TRUE)

#quanitile
quantile(v, na.rm = TRUE)
quantile(v, probs = (seq(0,1,.01)), na.rm = TRUE)

#max
#min
#diff

attr()

rnorm()

table(??useNA )

prop.table == proportions of your table

st <- read.csv("student_data.csv")

aggregate(list(averagemath score = st$math), list(female = st$female), FUN = mean)

cd <- read.csv("college_distance.csv")
mean.wage <- aggregate(list(wage = cd$wage),c(list(ethnicity = cd$ethnicity),list(urban = cd$urban), list(income_level = cd$income)), FUN = mean, na.rm = TRUE)
mean.wage
wage.gender <- aggregate(list(wage = cd$wage), list(gender = cd$gender), FUN = mean)
wage.gender

cu
#Merge

a<- 3:7
b <- 1:5
intersect(a,b)
setdiff(a,b)
