

---
title: "Gentle EDA of Kiva Loans Dataset"
output: 
  html_document:
  toc: true
  code_folding: hide
---

## What is Kiva:

Kiva is an international nonprofit, founded in 2005 and based in San Francisco, with a mission to connect people through lending to alleviate poverty. We celebrate and support people looking to create a better future for themselves, their families and their communities.

## What makes Kiva unqiue:

* It's a loan, not a donation
* You choose where to make an impact
* Pushing the boundaries of a loan
* Lifting one, to lift many

## Kiva highlights

```{r}
knitr::opts_chunk$set(echo = TRUE, warning=FALSE, message=FALSE, include = FALSE)

```

![Kiva by Numbers](https://i.imgur.com/Uo3x929.png)

## Being part of Kiva Community

These are the following roles you could play to be part of Kiva's community:

* lender, 
* borrower, 
* volunteer, 
* fellow, 
* employee, 
* Trustee, 
* Field Partner, 
* supporter


```{r}
loans <- read.csv('../input/data-science-for-good-kiva-crowdfunding/kiva_loans.csv', header = T, stringsAsFactors = F)
```

## Some boring summary statistics

The loans data has got 671205 Observations and 20 Variables with a mix of both numeric and categorical. 


```{r}
library(dplyr)
library(ggplot2)
library(ggthemes)
library(plotly)
str(loans)

```
### Agriculture leads the list of sectors in which loan is posted

```{r}
loans %>% group_by(sector) %>% count() %>% 
  ggplot() + geom_bar(aes(reorder(sector,n),n), stat = 'identity') + coord_flip() +
  theme_solarized_2() + xlab('Sectors in which the loan was posted') + ylab('Count') +
  ggtitle('Sector Distribution - Loan Activity') 

```

### Activity within the Sector

While overall, It's `Agriculture` that's winning, it's also important for us to know what within those overall sectors are doing good. 


```{r}

ys <- unique(loans$sector)

library(purrr)

grouped <- loans %>% group_by(sector,activity) %>% count()

ys %>% map(function(y)
  grouped %>% filter(sector %in% y) %>% ggplot() + geom_bar(aes(activity,n),stat = 'identity') + coord_flip() + ggtitle(paste0('Distribution of',y))) + theme_fivethirtyeight()

```


### Philippines leading in the top 10 countries in Loans data

It's quite astonishing that Philippines leads the entire country list with the second country, Kenya is less than 50% of Philippines count. The top 10 list makes it very obvious that it's all developing nations that are looking for this help from Kiva.


```{r}


loans %>% group_by(country) %>% count() %>% arrange(desc(n)) %>% head(10) %>% 
  ggplot() + geom_bar(aes(country,n), stat = 'identity') 

```

With top countries in the list, let us try to understand how their repayment pattern is:


```{r}

loans %>% group_by(country, repayment_interval) %>% count() %>% 
  ggplot() + geom_bar(aes(country,n, fill = repayment_interval), stat = 'identity') + 
   theme(axis.text.x = element_text(angle = 90, hjust = 1))

```


It looks interesting that only a few countries have weekly repayment pattern and the country is Kenya.

```{r}
library(tidyr)


loans %>% group_by(country, repayment_interval) %>% count() %>% 
  spread(repayment_interval,n) %>% filter(weekly >= 1) %>% knitr::kable() 
```

And, the country that is leading in irregularity is, Philippines - not to forget that it's also leading overall, hence this could be expected. 


```{r}

loans %>% group_by(country, repayment_interval) %>% count() %>% 
  spread(repayment_interval,n) %>% arrange(desc(irregular)) %>% head(10) %>%  knitr::kable() 
```


It's also important to note that `Cambodia` that made to the overall top 10 list hasn't made it here in the irregularity top 10 list which means, they've got a very good repayment interval.

```{r}

loans %>% group_by(country, repayment_interval) %>% count() %>% 
  spread(repayment_interval,n) %>% filter(country %in% 'Cambodia') %>%  knitr::kable() 
```

This is how the country wise split with respect to the sector is distributed. 


```{r}

loans %>% group_by(country, sector) %>% count() %>% 
  ggplot() + geom_bar(aes(reorder(country,n),n, fill = sector), stat = 'identity') +
  coord_flip() + theme_solarized()

```



```{r}

regions <- read.csv('../input/data-science-for-good-kiva-crowdfunding/loan_themes_by_region.csv',header = T, stringsAsFactors = F)

```


### What's with the use? 

```{r}

library(udpipe)
#model <- udpipe_download_model(language = "english")
udmodel_english <- udpipe_load_model(file = '../input/udpipe-english-model-pretrained/english-ud-2.0-170801.udpipe')


x <- udpipe_annotate(udmodel_english, x = loans$use, doc_id = loans$id)
x <- as.data.frame(x)

## NOUNS
stats <- subset(x, upos %in% c("NOUN")) 
stats <- txt_freq(stats$token)
stats$key <- factor(stats$key, levels = rev(stats$key))
barchart(key ~ freq, data = head(stats, 20), col = "cadetblue", 
         main = "Most occurring nouns", xlab = "Freq")


## ADJECTIVES
stats <- subset(x, upos %in% c("ADJ")) 
stats <- txt_freq(stats$token)
stats$key <- factor(stats$key, levels = rev(stats$key))
barchart(key ~ freq, data = head(stats, 20), col = "cadetblue", 
         main = "Most occurring adjectives", xlab = "Freq")

```



### Understanding the regions of loan field agents

```{r}
library(leaflet)
library(ggmap)
library(jsonlite)
library(rgdal)         # for readOGR(...)
 
one <- regions %>% drop_na(lat) %>%  unite(lat_lon, c('lat','lon'),sep = '_') %>%  group_by(lat_lon) %>% count() %>% arrange(desc(n)) %>% separate(lat_lon, c('lat','lon'), sep = '_') 

one$lat <- as.numeric(one$lat)
one$lon <- as.numeric(one$lon)

map <- get_map("Asia", zoom = 4)

points <- ggmap(map) + geom_point(aes(x = lon, y = lat), data = one, alpha = 0.5)

points


```


