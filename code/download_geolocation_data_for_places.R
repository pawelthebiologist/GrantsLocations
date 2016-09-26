#### This script uses RCurl and RJSONIO to download data from Google's API:
#### Latitude, longitude, location type (see explanation at the end), formatted address
#### Notice ther is a limit of 2,500 calls per day

library(RCurl)
library(RJSONIO)
library(plyr)

# you need the google api key to use Google Places API 
# you can get one for free here https://developers.google.com/places/web-service/get-api-key
key="AIzaSyA7g8H3aib72IRu-fkN8lPtR5nr5QVSkY0"

url <- function(address, return.call = "json") {
  root <- "https://maps.googleapis.com/maps/api/place/textsearch/"
  u <- paste(root, return.call, "?query=", address, "&key=", key, sep = "")
  return(URLencode(u))
}

geoCode <- function(address,verbose=FALSE) {
  if(verbose) cat(address,"\n")
  u <- url(address)
  doc <- getURL(u)
  x <- fromJSON(doc,simplify = FALSE)
  if(x$status=="OK") {
    lat <- x$results[[1]]$geometry$location$lat
    lng <- x$results[[1]]$geometry$location$lng
    formatted_address <- x$results[[1]]$formatted_address
    return(c(lat, lng, formatted_address))
  } else {
    print (paste("failed:",list(x)))
    return(c(NA,NA,NA))
  }
}

# this will fail if you exceed request quotas due to API limitations
# check https://developers.google.com/places/web-service/usage for more info
adresy <- lapply(paste(grants$wydzial, grants$jednostka.gl,sep=","), geoCode) 
adresy.matrix <- matrix(unlist(adresy),ncol=3,byrow=T)

grants$szer.geog <- as.numeric(adresy.matrix[,1])
grants$dl.geog <- as.numeric(adresy.matrix[,2])
grants$adres <- adresy.matrix[,3]
# extract city name from address
grants$miasto <- sub("(.*), Poland","\\1",grants$adres,perl=T)
grants$miasto <- sub(".*[0-9,]","",miasto)

write.csv(grants,"../results/2013_parsed_with_geolocation.csv", row.names=F)
