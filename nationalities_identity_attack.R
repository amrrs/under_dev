library(dplyr)
library(stringr)
library(ggplot2)
library(ggthemes)

train <- read.csv('../input/jigsaw-toxic-comment-classification-challenge/train.csv',header = T,stringsAsFactors = F)

nationalities <- read.csv('../input/nationalities/nationalities.csv',header = F,stringsAsFactors = F)

nationalities$V1 <- tolower(nationalities$V1)

train$row_sum <- rowSums(train[,-c(1,2)])


train_n <- train %>% filter(row_sum>=1)

#to_lower

train_n$comment_text <- tolower(train_n$comment_text)

nat_pattern <- paste(nationalities$V1,collapse = '|')


list_nats <- train %>% filter(identity_hate == 1) %>% select(comment_text) %>% str_match_all(nat_pattern) %>% unlist()

list_nats <- data.frame(table(list_nats))

list_nats %>% ggplot() + geom_bar(aes(reorder(list_nats,-Freq),Freq),stat='identity') + 
  theme_solarized() + ggtitle('Nationalities facing Identity Hate') + 
  theme(axis.text = element_text(size = 9),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) +
  xlab('Nationalities') + ylab('Frequency of Appearance')
