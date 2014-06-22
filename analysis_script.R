## Source 'lattice' library
library(lattice)

## Set variables for download
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
weather$Event <- gsub("[[:digit:][:punct:]])"," ", weather$Event)
weather$Event <- gsub("[[:space:]]+)"," ", weather$Event)
weather$Event <- gsub("^[[:space:]]+|[[:space:]]+$ )"," ", weather$Event)

## Clean-up duplicates that will be in top ten.
weather$Event[grep("TSTM WIND|THUNDERSTORM WIND", weather$Event)] <- "TSTM WIND"
weather$Event[grep("WINTER STORM", weather$Event)] <- "BLIZZARD"

## Calculate casualties from injury and fatality statistics
weather$Casualties <- weather$Injuries + weather$Fatalities

## Aggregate casualties by storm type
eventCasualties <- aggregate(Casualties ~ Event, weather, sum)
eventCasualties <- eventCasualties[eventCasualties$Casualties > 0,]
eventCasualties <- eventCasualties[with(eventCasualties, order(-Casualties, Event)), ]

## Pull Top Ten Events by Casualty
topEventsHealth <- head(eventCasualties, 10)

## Graph
barchart(Event, topEventsHealth,xlab=Event,ylab=Casualties)

# Here we convert PROPDMGEXP and CROPDMGEXP to values and add them to the
# respective CROPDMG/PROPDMG
translate <- c(h = 100, k = 1000, m = 1e+06, b = 1e+09)
weather$propdmgexp <- translate[tolower(weather$propdmgexp)]
weather$propdmgexp[is.na(weather$propdmgexp)] = 1

weather$PropertyDamage <- weather$PropertyDamage * weather$propdmgexp

weather$cropdmgexp <- translate[tolower(weather$cropdmgexp)]
weather$cropdmgexp[is.na(weather$cropdmgexp)] = 1

weather$CropDamage <- weather$CropDamage * weather$cropdmgexp

## Aggregate property and crop damage
eventPropDmg <- aggregate(PropertyDamage ~ Event, weather, sum) 
eventCropDmg <- aggregate(CropDamage ~ Event, weather, sum)



