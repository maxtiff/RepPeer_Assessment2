url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

datasetDirPath <- file.path("weather.csv.bz2")

## Downloading/Unzipping data *iff* data doesn't already exist
if(!file.exists(datasetDirPath)){ 
  download.file(url,datasetDirPath)
}

weather <- read.csv(bzfile(datasetDirPath))
unlink(datasetDirPath)