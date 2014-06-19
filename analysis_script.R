url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

datasetDirPath <- file.path("weather.csv.bz2")

## Downloading/Unzipping data *iff* data doesn't already exist
if(!file.exists(datasetDirPath)){ 
  download.file(url,datasetDirPath)
}

## Read in csv file and delete bz2 file.
weather <- read.csv(bzfile(datasetDirPath), na.strings = c("NA", ""), stringsAsFactors = FALSE)

## Clean EVTYPE field
weather$EVTYPE <- sapply(weather$EVTYPE, toupper)
weather$EVTYPE <- gsub("[[:digit:][:punct:]])"," ", weather$EVTYPE)
weather$EVTYPE <- gsub("[[:space:]]+)"," ", weather$EVTYPE)
weather$EVTYPE <- gsub("^[[:space:]]+|[[:space:]]+$ )"," ", weather$EVTYPE)

## 

evtype <- unique(weather$EVTYPE)

for (i in evtype) {
  agrep(i, weather$EVTYPE)
}