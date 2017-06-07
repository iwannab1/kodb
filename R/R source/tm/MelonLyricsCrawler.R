library(RCurl)
library(httr)
library(XML)

chartUrl = "http://www.melon.com/chart/day/index.htm"
chart <- htmlTreeParse(chartUrl, useInternalNodes = T, trim = T) 
contents <- xpathSApply(chart, "//*[@id='lst50']")

top50 <- NULL
top50Column <- NULL
  
for(i in 1:length(contents)){
  id = xpathSApply(contents[[i]], 'td[1]/div/input/@value')
  title = xpathSApply(contents[[i]], 'td[4]/div/div/div[1]/span/strong/a/text()')
  singer = xpathSApply(contents[[i]], 'td[4]/div/div/div[2]/div[1]/a/text()')
  
  lyricsUrl <- paste("http://www.melon.com/song/popup/lyricPrint.htm?songId=", id[[1]], sep="")
  response <- GET(lyricsUrl)
  
  lyricsDoc <- htmlParse(response, encoding="UTF-8")
  lyrics <- xpathSApply(lyricsDoc, "//div[@class='box_lyric_text']", xmlValue)
  lyrics <- gsub("[\r\n\t]", " ", lyrics) 
  
  top50Column <- cbind(id=id[[1]], title=xmlValue(title[[1]]), singer=xmlValue(singer[[1]]), lyrics=lyrics)
  top50 <- rbind(top50, top50Column)
}

write.csv(top50, "~/top50.csv")
