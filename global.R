library(tm)
library(wordcloud)
library(memoise)
library(data.table)
library(RColorBrewer)
library(SnowballC)
library(ggplot2)
library(lsa)
#library(topicmodels)
#library(devtools)
#unload(inst("topicmodels"))
#library(dendextend)

# The list of valid books
books <<- list("PlikM" = "M",
               "PlikN" = "N",
               "PlikO" = "O")

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(book) {
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  if (!(book %in% books))
    stop("Unknown book")
  
  text <- readLines(sprintf("./%s.txt.gz", book),encoding="UTF-8")
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, tolower)
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, PlainTextDocument)
  #myCorpus = tm_map(myCorpus, removeWords, c(stopwords("SMART"), "ach", "aj", "albo"))
  stopwords <- readLines(sprintf("./stoplista_PL.txt.gz"),encoding = "UTF-8")
  myCorpus = tm_map(myCorpus,removeWords,stopwords)
  myCorpus = tm_map(myCorpus,stripWhitespace)
  
  #----------LEMMATIZATION "naiwna" PL
  lemma <- readLines(sprintf("./shortlemmatization.txt.gz"), encoding="UTF-8")
  lemma <- tolower(lemma)
  lemmat <- data.table(
    lemmats = as.character(lapply(strsplit(as.character(lemma), split="\t"), "[", 1)),
    tolemmat = as.character(lapply(strsplit(as.character(lemma), split="\t"), "[", 2))
  )
  
  for(i in 1:760) 
  {
    myCorpus <- tm_map(myCorpus, (gsub),
                       pattern = paste("", lemmat$tolemmat[i],""),
                       replacement = paste("", lemmat$lemmats[i],"")
    )
  }
  
  #writeLines(as.character(myCorpus[[3]]))
  #TDM which reflects the number of times each word in the corpus is found in each of the documents
  myTDM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myTDM)
  
  sort(rowSums(m), decreasing = TRUE)
})

getDocumentsMatrix <- function() {

  katalog<-"./Aforyzmy/"    #textmining_1" #forma podstawowa
  docsCorpus<-VCorpus(DirSource(katalog,encoding = "UTF-8"),readerControl = list(reader=readPlain))
  
  
  #docsCorpus = Corpus(VectorSource(text))
  docsCorpus = tm_map(docsCorpus, tolower)
  docsCorpus = tm_map(docsCorpus, removePunctuation)
  docsCorpus = tm_map(docsCorpus, removeNumbers)
  docsCorpus = tm_map(docsCorpus, PlainTextDocument)
  #myCorpus = tm_map(docsCorpus, removeWords, c(stopwords("SMART"), "ach", "aj", "albo"))
  stopwords <- readLines(sprintf("./stoplista_PL.txt.gz"),encoding = "UTF-8")
  docsCorpus = tm_map(docsCorpus,removeWords,stopwords)
  docsCorpus = tm_map(docsCorpus,stripWhitespace)
  
  #----------LEMMATIZATION "naiwna" PL
  lemma <- readLines(sprintf("./shortlemmatization.txt.gz"), encoding="UTF-8")
  lemma <- tolower(lemma)
  lemmat <- data.table(
    lemmats = as.character(lapply(strsplit(as.character(lemma), split="\t"), "[", 1)),
    tolemmat = as.character(lapply(strsplit(as.character(lemma), split="\t"), "[", 2))
  )
  
  for(i in 1:760) 
  {
    docsCorpus <- tm_map(docsCorpus, (gsub),
                         pattern = paste("", lemmat$tolemmat[i],""),
                         replacement = paste("", lemmat$lemmats[i],"")
    )
  }
  
  
  return(docsCorpus)
}


