library(itunesr)
library(udpipe)
library(lattice)
library(tidyverse)

flipkart_reviews <- getReviews("742044692","in",1)

model <- udpipe_download_model(language = "english")
udmodel_english <- udpipe_load_model(file = 'english-ud-2.0-170801.udpipe')
#udmodel_english <- udpipe_load_model(file = 'english-ud-2.0-170801.udpipe')

reviews_only <- flipkart_reviews$Review

s <- udpipe_annotate(udmodel_english, reviews_only)

x <- data.frame(s)

## Using RAKE
stats <- keywords_rake(x = x, term = "lemma", group = "doc_id", 
                       relevant = x$upos %in% c("NOUN", "ADJ"))
stats$key <- factor(stats$keyword, levels = rev(stats$keyword))
barchart(key ~ rake, data = head(subset(stats, freq > 3), 20), col = "red", 
         main = "Keywords identified by RAKE", 
         xlab = "Rake")


## Dictionary

customer_service <- c("customer","service")

app <- c("app","version","update")

order <- c("time","delivery","order")

## creating a new dataframe with categories

flipkart_reviews_categorized <- flipkart_reviews %>% 
  mutate("customer_service" = str_detect(Review, pattern = paste(customer_service,collapse = "|")),
         "app" = str_detect(Review, pattern = paste(app,collapse = "|")),
         "order" = str_detect(Review, pattern = paste(order,collapse = "|"))) 


## just seeing the categories

table(flipkart_reviews_categorized$customer_service)

table(flipkart_reviews_categorized$app)

table(flipkart_reviews_categorized$order)
