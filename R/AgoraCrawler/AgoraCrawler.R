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

body_content <- NULL
body_table <- NULL

for (i in 1:length(contents)){
  url <- xpathSApply(contents[[i]], "dt/a/@href")
  date <- xpathSApply(contents[[i]],"dt/span/text()")
  title <- xpathSApply(contents[[i]],"dd/text()")
  body_content <- cbind(url[[1]], xmlValue(date[[1]]), xmlValue(title[[1]]))
  body_table <- rbind(body_table, body_content)
}

write.csv(body_table, savefile, fileEncoding = "UTF-8")

