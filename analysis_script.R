url <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

dataDirPath <- "data"
datasetDirPath <- file.path(dataDirPath, "weather.csv.bz2")

## Downloading/Unzipping data *iff* data doesn't already exist
if(!file.exists(dataDirPath)){ 
  dir.create(dataDirPath) 
}

download.file(url,datasetDirPath)

weather <- read.csv(bzfile(datasetDirPath))