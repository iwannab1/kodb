library(KoNLP)
useNIADic()

top50 = read.csv("~/top50.csv")  
head(top50)
colnames(top50)
dim(top50)

title = top50[,"title"]
title

lyrics = top50[,"lyrics"]
lyrics[1]

# 특수 문자 제거
library(stringr)

lyrics <- str_replace_all(lyrics, "\\W", " ")
lyrics


# 가사에서 명사 추출 
nouns <- extractNoun(lyrics)
nouns

# 추출한 명사 list 를 문자열 벡터로 변환 , 단어별 빈도표 생성 
wordcount <- table(unlist(nouns))
wordcount

# 데이터 프레임으로 변환 
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word

# 변수명 수정 
df_word <- rename(df_word,  word = Var1,  freq = Freq)
head(df_word)
dim(df_word)

library(dplyr)
df_word <- filter(df_word, nchar(word) >= 2)
dim(df_word)


## 가장 많이 사용한 20개 단어
top_20 <- df_word %>%  arrange(desc(freq)) %>%  head(20)
top_20


## plot
library(ggplot2)

order <- arrange(top_20, freq)$word               # 빈도 순서 변수 생성
ggplot(data = top_20, 
       aes(x = word, y = freq)) + ylim(0, 100) +  geom_col() + coord_flip() +scale_x_discrete(limit = order) +              # 빈도순 막대 정렬  
       geom_text(aes(label = freq), hjust = -0.3)     

## word cloud
library(wordcloud) 
library(RColorBrewer)

wordcloud(words = df_word$word,  # 단어          
          freq = df_word$freq,   # 빈도          
          min.freq = 2,          # 최소 단어 빈도          
          max.words = 200,       # 표현 단어 수          
          random.order = F,      # 고빈도 단어 중앙 배치          
          rot.per = .1,          # 회전 단어 비율          
          scale=c(4, 0.3),       # 단어 크기 범위          
          colors = pal)          # 색상 목록
          


