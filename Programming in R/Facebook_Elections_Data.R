##mining facebook data
library(Rfacebook)
library(stringr)
library(reshape2)
library(tm)
library(quanteda)
library(lubridate)

fb_oauth <- fbOAuth(app_id = '320003915053360', app_secret = 'ce63bfdd845ae75a19cf87b5c7ba9d1a', extended_permissions = TRUE)

hillary_data <- getPage(page = 'hillaryclinton',token = fb_oauth, since = '2016/11/08/',until = '2016/11/10')
hillary_data$order <- 1:nrow(hillary_data)

# Function to download the comments
download.maybe <- function(i, refetch = FALSE, path = ".") {
  post <- getPost(post = hillary_data$id[i], comments = TRUE, likes = TRUE, token = fb_oauth)
  post1<- as.data.frame(melt(post)) 
}


# Apply function to download comments
files <- data.frame(melt(lapply(hillary_data$order, download.maybe)))

# Select only comments
files_c<-files[complete.cases(files$message),]

# Split ID to abstract POST_ID
files_c$id2 <- lapply(strsplit(as.character(files_c$id), "_"), "[", 1)
files_c$ch  <- nchar(files_c$id2) 
files_a <- files_c[ which(files_c$ch >12), ]

# Change column name
names(files_a)[11]<-"POST_ID"

# Define date
files_a$date <- lapply(strsplit(as.character(files_a$created_time), "T"), "[", 1)
files_a$date1<-as.character(files_a$date)

# Dine identifier to count comments
files_a$tempID<-1

# Clean Data
dat2<-gsub("[^[:alnum:]///' ]", "", files_a$message)
dat2<-data.frame(dat2)

dat3<-gsub("([.-])|[[:punct:]]", " ", dat2$dat2)
dat3<-data.frame(dat3)
dat4<-iconv(dat3$dat3, "latin1", "ASCII", sub="")
dat4<-data.frame(dat4)

dat5<-gsub('[[:digit:]]+', '',dat4$dat4)
dat5<-data.frame(dat5)

dat6<-tolower(dat5$dat5)
dat6<-data.frame(dat6)

dat7<-gsub("'", " ", dat6$dat6)
dat7<-data.frame(dat7)

dat8<-gsub("/", " ", dat7$dat7)
dat8<-data.frame(dat8)

# Steps to replace empty entries
# Function to replace blanks with missing NA 
blank2na <- function(x){
  z <- gsub("\\s+", "", x)  #make sure it's "" and not " " etc
  x[z==""] <- NA
  return(x)
}

# Replace blanks with 'NA'
dat10<-data.frame(sapply(dat8,  blank2na))
dat10<-data.frame(dat10)

# Define the relevant column as numeric
dat12<-as.numeric(dat10$dat8)
dat12<-data.frame(dat12)

# Define function if entry is numeric(non-numeric) 
f <- function(x) is.numeric(x) & !is.na(x) # Apply function
dat14<-f(dat12$dat12)
dat14<-data.frame(dat14)

# Reverse definition of numeric/character
dat16<-as.character(ifelse(dat14$dat14 == "FALSE", dat8$dat8, 1010101010101010))
dat16<-data.frame(dat16)
dat16<-as.character(dat16$dat16)

# Combine NA and real value !!!!Select a individual Term (here: "Hallo")!!!!
dat8 <-as.character(dat8$dat8)
dat17<-ifelse(dat16 != 1010101010101010, "HALLO", dat8)
dat17<-data.frame(dat17)

# Define Corpus
dat17$ch           <- nchar(as.character(dat17$dat17))
dat17$bb           <- ifelse(dat17$ch<4, "HALLO", as.character(dat17$dat17))
dat18              <- as.data.frame(dat17$bb [ grep("nchar", dat17$bb ) ])
dat17$dat17        <-as.character(dat17$dat17)
dat_r              <-as.data.frame(dat17)
colnames(dat_r)[1] <-"dat_r"
dat_r$dat_r        <-as.character(dat_r$dat_r)
corpus             <- corpus(dat_r$dat_r)

#############################################################################
Load Dictionary (https://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html#lexicon)
# Negative/Positive Words
hu.liu.pos=scan('C:/workspace/positive-words.txt', what='character', comment.char = ';')
hu.liu.neg=scan('file:///C:/workspace/negative-words.txt', what='character', comment.char = ';')
# Optional: Add Words to List
pos.words=c(hu.liu.pos, 'like')
neg.words=c(hu.liu.neg, 'bad')

# Combine Dictionnarys
myDict <- dictionary(list(positive = pos.words,
                          negative = neg.words))

#############################################################################
# Apply Dictionary
fb_liwc <-dfm(corpus, dictionary=myDict)
fb1<-as.data.frame(fb_liwc)

#############################################################################
# Combine Analysis Data and Original Data
ALL<-cbind(files_a,fb1)

#Fix Date-Times
ALL$created_time <- gsub("T"," ",ALL$created_time)
ALL$created_time <- gsub("+0000","",ALL$created_time)
ALL$created_time <- parse_date_time(ALL$created_time,orders = '%y-%m-%d H:M:S')

p <- ggplot(ALL, aes(x = hour(created_time), y = positive))
p + geom_bar(stat = 'identity')
