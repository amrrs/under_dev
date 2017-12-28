coindeskAPI <- "http://api.coindesk.com/v1/bpi/"

current_bitcoin_price <- function(currency = 'usd'){
  df <- data.frame(jsonlite::fromJSON(httr::content(httr::GET(paste0(coindeskAPI,'currentprice.json')),'text'), flatten = T))
  return(df)
}

current_bitcoin_price()




