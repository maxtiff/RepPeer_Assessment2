url <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

datasetDirPath <- file.path("weather.csv.bz2")

## Downloading/Unzipping data *iff* data doesn't already exist
if(!file.exists(datasetDirPath)){ 
  download.file(url,datasetDirPath)
}

## Read in csv file and delete bz2 file.
weather <- read.csv(bzfile(datasetDirPath), na.strings = c("NA", ""), stringsAsFactors = FALSE)

## Remove excess columns
weather <- data.frame(Event = weather$EVTYPE, Fatalities = weather$FATALITIES, 
                 Injuries = weather$INJURIES, PropertyDamage = weather$PROPDMG, propdmgexp = weather$PROPDMGEXP, 
                 CropDamage = weather$CROPDMG, cropdmgexp = weather$CROPDMGEXP, Remarks = weather$REMARKS)

## Clean Event field
weather$Event <- sapply(weather$Event, toupper)
weather$Event <- gsub("[[:digit:][:punct:]])"," ", weather$Event)
weather$Event <- gsub("[[:space:]]+)"," ", weather$Event)
weather$Event <- gsub("^[[:space:]]+|[[:space:]]+$ )"," ", weather$Event)

## Clean-up top duplicates
weather$Event[grep("TSTM WIND|THUNDERSTORM WIND", weather$Event)] <- "TSTM WIND"
weather$Event[grep("WINTER STORM", weather$Event)] <- "BLIZZARD"

## Calculate casualties from injury and fatality statistics
weather$Casualties <- weather$Injuries + weather$Fatalities

## Aggregate casualties by storm type
eventCasualties <- aggregate(Casualties ~ Event, weather, sum)
eventCasualties <- eventCasualties[eventCasualties$Casualties > 0,]
eventCasualties <- eventCasualties[with(eventCasualties, order(-Casualties, Event)), ]

topEventsHealth <- head(eventCasualties, 10)



