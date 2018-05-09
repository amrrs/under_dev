library(rvest)

url <- 'https://www.tiobe.com/tiobe-index/'

content <- read_html(url)

all_tables <- content %>% html_table()

top_20 <- function(){
  
  all_tables[[1]][,c(1,2,4,5,6)] 
  
}

#top_20_min <- all_tables[[1]][,c(1,4,5)]



top_50 <- function() {
  
  top_20_min <- top_20()[,c(1,3,4)]
  
  names(top_20_min) <- names(all_tables[[2]])
  
  rbind(top_20_min, all_tables[[2]])
  
}

long_term_history <- function() {
  
  all_tables[[3]]

}


hall_of_fame <- function() {
  
  all_tables[[4]]

}
