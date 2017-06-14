library(twitteR)
library(ROAuth)
library(plyr)
library(stringr)
library(ggplot2)

consumer_key = "psGG42l9DFZSTVijML6u2pFHb"
consumer_secret = "tn9Ma0RSSSEwA4gu1XzfMgqgtSiUunPAgoXEYx1MkZxQxNcSDa"
access_token = "17185110-XsunnUvJISlx6LqicCwxgFrtARlBEkEy6oFXZtix6"
access_token_secret = "Pi5uaCENNaDp3wTVnCMIgHcRzUr8bZhqsUaXC2soLYOS6"

setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_token_secret)

keyword = enc2utf8("문재인")

tweets = searchTwitter(keyword, lang='ko', n=1000)

Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_121")
library(KoNLP)
library(tm)
# 사전지정
useNIADic()


nDocs <- length(tweets)
## data frame 으로 변환 
df <- twListToDF(tweets)
head(df)

## 불필요한 단어 제거
removeTwit <- function(x) {gsub("@[[:graph:]]*", "", x)}
df$ptext <- sapply(df$text, removeTwit)
removeURL <- function(x) { gsub("http://[[:graph:]]*", "", x)}
df$ptext <- sapply(df$ptext, removeURL)
removeURL <- function(x) { gsub("https://[[:graph:]]*", "", x)}
df$ptext <- sapply(df$ptext, removeURL)

# 명사 추출
df$ptext <- sapply(df$ptext, function(x) {paste(extractNoun(x), collapse=" ")}) 

# 한글만 추출
df$ptext <- sapply(df$ptext, function(x) {str_match_all(x, '[가-힣]+')}) 
df$ptext <- sapply(df$ptext, function(x){paste(x, collapse = " ")})

# corpus 생성
myCorpus <- Corpus(VectorSource(df$ptext))
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, removeNumbers)
myCorpus <- tm_map(myCorpus, tolower)
myStopwords <- c(stopwords('english'), "rt")
myCorpus <-tm_map(myCorpus, removeWords, myStopwords)
#myCorpus <- tm_map(myCorpus_, PlainTextDocument)

myCorpus[[1]]$content

# TDM 생성
myTdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(2,Inf)))
myTdm$dimnames$Terms = iconv(myTdm$dimnames$Terms, from = "UTF-8", to = "EUC-KR")


inspect(myTdm[100:105, 1:5])

# Term Frequency
(freq.terms <- findFreqTerms(myTdm, lowfreq=50))

term.freq <- rowSums(as.matrix(myTdm))
term.freq <- subset(term.freq, term.freq >=100)
term.freq.df <- data.frame(term=names(term.freq), freq=term.freq)
ggplot(term.freq.df, aes(x=term, y=freq)) + geom_bar(stat="identity") + xlab("Terms") + ylab("Count") + coord_flip()


# Association
findAssocs(myTdm,c('인사','정부','김상조'),c(0.5,0.5,0.3))


#Word Cloud 

library(wordcloud)
m <- as.matrix(myTdm)
wordFreq <- sort(rowSums(m),decreasing=TRUE)
set.seed(375)
pal <- brewer.pal(8,"Dark2")
wordcloud(words=names(wordFreq),freq=wordFreq,min.freq=10,random.order=F, rot.per=.1,colors=pal)


## hclust
myTdm2<-removeSparseTerms(myTdm,sparse=0.95)
m2<-as.matrix(myTdm2)
distMatrix<-dist(scale(m2))
fit<-hclust(distMatrix,method="ward.D2")
#dendrogram
plot(fit)
rect.hclust(fit,k=10)


## Clustering(KMeans)
m3 <- t(m2)
k <- 4
kmres <- kmeans(m3, k)

round(kmres$centers, digits=3)


for(i in 1:k){
  cat(paste("cluster ", i, " : ", sep=""))
  s <- sort(kmres$centers[i, ], decreasing=T)
  cat(names(s)[1:3], "\n")
}

## clustering plot
require(vegan)
# distance matrix
m3_dist <- dist(m3)
# Multidimensional scaling
cmd <- cmdscale(m3_dist)

groups <- levels(factor(kmres$cluster))
ordiplot(cmd, type = "n")
cols <- c("steelblue", "darkred", "darkgreen", "pink")
for(i in seq_along(groups)){
  points(cmd[factor(kmres$cluster) == groups[i], ], col = cols[i], pch = 16)
}
# add spider and hull
ordispider(cmd, factor(kmres$cluster), label = TRUE)
ordihull(cmd, factor(kmres$cluster), lty = "dotted")


myDtm <- as.DocumentTermMatrix(myTdm)
library(topicmodels)
lda <- LDA(myDtm, k=8)
(term <- terms(lda, 4))
(term <- apply(term, MARGIN=2, paste, collapse=", "))