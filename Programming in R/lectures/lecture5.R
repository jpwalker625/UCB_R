
#Binning Data

f <- cut(rep(1:10,10), breaks = c(0,5,Inf), labels = c("zero to five(excluded)","five to twenty"))

#tabling data
j <-table(mtcars$gear)

#prop.table returns the ratios of each variable as a proportion of the total amount in the table

length(mtcars$gear)

prop.table(j)

#Base Graphics

par(col.main = "Red", bty = "o", col.axis = "blue",  = )
plot(1:100,rnorm(100), main = "This Is A Plot")

curve(x^2, xlim = c(0,5), ylim = c(10,50))
text(.2,1.2, "Hey")

?points

rnb <- rainbow(n = 32)

View(mtcars)
barplot(mtcars$mpg, col = rnb)

numeric_vector <- c(54,19,36,7,66)
f <- factor(numeric_vector)
print(sum(as.numeric(as.character(f))))

unclass(f)
levels(f) <-c("apple", "banana", "orange", "berry", "watermelon")
levels(f)

numeric_vector
