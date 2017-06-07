Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_121")
#CHCP 65001

library(rvest)
library(httr)
library(KoNLP)
library(stringr)
library(tm)
library(qgraph)
library(XML)
useNIADic()

url_base = "http://movie.daum.net/moviedb/grade?movieId=108944&type=netizen&page="

all.reviews = c()
for(page in 1:1000){
  url = paste0(url_base, page)
  htxt = read_html(url)
  comments = html_nodes(htxt, 'div') %>% html_nodes('p')
  reviews = html_text(comments)
  reviews = repair_encoding(reviews, from='utf-8')
  if(length(reviews) == 0 ) {break}
  reviews = str_trim(reviews)
  all.reviews = c(all.reviews, reviews)
}

all.reviews = all.reviews[!str_detect(all.reviews,"평점")]
all.reviews = all.reviews[nchar(all.reviews)!=0]
Encoding(all.reviews)  <- "UTF-8"

## 명사 / 형용사 추출

ko.words = function(doc){
  d = as.character(doc)
  pos = paste(SimplePos09(d))
  extracted = str_match(pos, '([가-힣]+/[NP]')
  keyword = extracted[,2]
  keyword[!is.na(keyword)]
}

cps = Corpus(VectorSource(all.reviews))

tdm = TermDocumentMatrix(cps, 
                         control=list(tokenize=ko.words,
                                      removePunctuation=T,
                                      removeNumbers=T,
                                      wordLengths=c(2,6),
                                      weighting=weightBin))

dim(tdm)
tdm.matrix = as.matrix(tdm)
rnames = rownames(tdm.matrix)
rownames(tdm.matrix) = iconv(rnames, from = "UTF-8", to = "EUC-KR")
rownames(tdm.matrix)[1:100]


word.count = rowSums(tdm.matrix)
word.order = order(word.count, decreasing = T)
freq.word = tdm.matrix[word.order[1:20],]
co.matrix = freq.word %*% t(freq.word)

co.matrix


qgraph(co.matrix, labels=rownames(co.matrix), diag=F, layout="spring",
       edge.color='blue', vsize=log(diag(co.matrix))*2)
