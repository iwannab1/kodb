setwd("D:/kodb/R/TwitterCrawler")

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

keyword = enc2utf8("야구")

KS = searchTwitter(keyword, lang='ko', n=100)
KS.df = twListToDF(KS)
write.csv(KS.df, "KS.csv")
