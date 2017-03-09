# kable_example.R
#
# Demonstrate use of the knitr kable() function
#  which can be used to generate simple tables in RMarkdown
#  see: https://www.rdocumentation.org/packages/knitr/versions/1.12.3/topics/kable
#
# A simple example using the mtcars data frame
#  compute and display mean mpg by cyl

# names(mtcars)
# [1] "mpg"  "cyl"  "disp" "hp"   "drat" "wt"   "qsec" "vs"   "am"   "gear"
# [11] "carb"
#

library(knitr)  # use install.packages('knitr') if not already installed
mean_mpg_by_cyl <- aggregate(list(mean_mpg = mtcars$mpg), list(cyl = mtcars$cyl), mean)

kable(mean_mpg_by_cyl)


