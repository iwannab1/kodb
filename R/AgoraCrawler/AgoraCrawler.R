setwd("D:/kodb/R/AgoraCrawler")

library(RCurl)
library(XML)

baseUrl = "http://agora.daum.net/nsearch/total?query="
sortType = "&sort_type=1"
searchword = "두산베어스"
savefile = "result.csv"

url = gsub(" ","", paste(baseUrl,searchword,sortType))
page <- getURL(url)
doc = htmlTreeParse(page, useInternalNodes = T)

contents <- xpathSApply(doc, "//*[@class='sResult']//dl")

body_content <-NULL
getContent <- function(subdoc){
  url <- xpathSApply(subdoc, "dt/a/@href")
  cat("url : ",url); cat("\n")
  date <- xpathSApply(subdoc,"dt/span/text()")
  #cat("date : ",date); cat("\n")
  #iconv(sent, localeToCharset()[1], "UTF-8")
  title <- xpathSApply(subdoc,"dd/text()")
  #cat("title : ",title); cat("\n")
  body_content <- cbind(url, date, title)
  write.csv(body_content, savefile, append=TRUE)
}

lapply(contents, getContent)
