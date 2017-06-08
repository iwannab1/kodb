## 데이터 생성

text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

text

text_kr <- c("왜냐하면 나는 죽음을 막을 수 없었기 때문에 -",
             "그는 나를 위해 친절히 멈췄다",
             "캐리지가 개최되었지만 우리 자신 -",
             "불멸")

library(dplyr)
text_df <- data_frame(line = 1:4, text = text)
text_kr_df <- data_frame(line = 1:4, text = text_kr)

text_df
text_kr_df


## 공백 기준 토큰 

library(tidytext)

text_df %>%
  unnest_tokens(word, text)

text_kr_df %>%
  unnest_tokens(word, text)


## 데이터 생성
library(janeaustenr)
library(stringr)

head(austen_books())
tail(austen_books())

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()

original_books

tidy_books <- original_books %>%
  unnest_tokens(word, text)

tidy_books


## stop word 제거
data(stop_words)

tidy_books <- tidy_books %>%  anti_join(stop_words)

tidy_books


## 단어 개수 
(tidy_books_count = tidy_books %>%  count(word, sort = TRUE))

library(ggplot2)

tidy_books_count %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


## 소설 다운로드
library(gutenbergr)
View(gutenberg_metadata) 
View(gutenberg_authors) 

gutenberg_works(author == "Wells, H. G. (Herbert George)")

hgwells <- gutenberg_download(c(35, 36, 5230, 159))

tidy_hgwells <- hgwells %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_hgwells %>%
  count(word, sort = TRUE)

bronte <- gutenberg_download(c(1260, 768, 969, 9182, 767))
tidy_bronte <- bronte %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_bronte %>%
  count(word, sort = TRUE)


library(tidyr)

frequency_bind <- bind_rows(mutate(tidy_bronte, author = "Brontë Sisters"),
                       mutate(tidy_hgwells, author = "H.G. Wells"), 
                       mutate(tidy_books, author = "Jane Austen")) 

frequency_bind

frequency_bind_count <- frequency %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) 

frequency_bind_count


frequency <- frequency_bind_count %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  spread(author, proportion) %>% 
  gather(author, proportion, `Brontë Sisters`:`H.G. Wells`)

frequency

library(scales)

ggplot(frequency, aes(x = proportion, y = `Jane Austen`, color = abs(`Jane Austen` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Jane Austen", x = NULL)

cor.test(data = frequency[frequency$author == "Brontë Sisters",],  ~ proportion + `Jane Austen`)
cor.test(data = frequency[frequency$author == "H.G. Wells",],    ~ proportion + `Jane Austen`)
