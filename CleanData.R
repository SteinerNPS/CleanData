setwd("~/R/CleanData/CleanData")
wd <- getwd()
#Check for and download data in current working directory
files <- list.files()
if (!"RAW_Data.zip" %in% files){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  if (Sys.info()['sysname'] == "Windows"){
    method <- "wininet"
  }else{method <- "curl"}
  download.file(url, "RAW_Data.zip", method)
}
unzip("RAW_Data.zip")

header <- as.list(strsplit(readChar("UCI HAR Dataset/features.txt", file.info("features.txt")$size), ' ')[[1]])
header <-header[2:length(header)]
for(i in seq(1:length(header))){
  header[i] <- sub("\\n[0-9]*", '', header[i])
}

test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
all_data <- rbind(test_data, train_data)
names(all_data) <- header
