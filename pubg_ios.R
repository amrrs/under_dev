library(itunesr)

pubg <- getReviews("1330123889","in",1)

head(pubg)

write.csv(pubg,"pubg_reviews.csv",row.names = F)
