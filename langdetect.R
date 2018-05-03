#library(jsonlite)

library(httr)

access_key <- '2bca6c2a35c9557e5429543425829267'


#query <- 'சென்னை'

query <- '马云'

detect_language <- function(access_key,query, data_frame = TRUE) {

base_url <- 'http://apilayer.net/api/detect?access_key='

response <- httr::GET(paste0(base_url,access_key,'&','query=',query))

#str(content(response))

if(!httr::content(response)$success) {
  stop(paste0('Error: ',httr::content(response)$error$info))
}

#http_status(response)
if(data_frame) {

  return(as.data.frame(httr::content(response)$results))
  
}

else {
  
  return(httr::content(response)$results)

}

}

#detect_language(access_key,query,F)

