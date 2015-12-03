setwd("D:/kodb/R/AgoraCrawler")

library(RCurl)
library(XML)

naver = getURL("http://www.naver.com")
doc = htmlTreeParse(naver)
top = xmlRoot(doc)
cat("Top Element : ",xmlName(top))
cat("Children of Root node : ", names(top))
cat(sprintf("Children of the %s : ", xmlName(top[[1]])), names(top[[1]]))
cat(sprintf("Children of the %s : ", xmlName(top[[2]])), names(top[[2]]))

div = top[[2]][["div"]]
names(div)
names(div[[1]])

xmlAttrs(div[[1]])
xmlValue(div[[1]])

xmlChildren(div[[1]])
xmlNamespaceDefinitions(div[[1]])
