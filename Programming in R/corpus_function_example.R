#test function

create_corpus <- function(x){
  wordcorpus <- Corpus(VectorSource(x))
  #Utilize tm_map to clean up the text. The functions are fairly straightforward.
  wordcorpus <- tm_map(wordcorpus, removePunctuation)
  wordcorpus <- tm_map(wordcorpus, content_transformer(tolower))
  
  # 'stopwords' do not contain contextual significance and will be removed. These are words like: 'the', 'as', 'from' 'no', etc...
  wordcorpus <- tm_map(wordcorpus, removeWords,stopwords("english"))
  
  wordcorpus <- tm_map(wordcorpus, stripWhitespace)
}

j <- create_corpus(all_tweets$text)
