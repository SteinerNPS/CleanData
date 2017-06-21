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
#Set headers and 
header <- as.list(strsplit(readChar("UCI HAR Dataset/features.txt", file.info("UCI HAR Dataset/features.txt")$size), ' ')[[1]])
header <- c("Subject", "Activity", header[2:length(header)])
for(i in seq(1:length(header))){
  header[i] <- sub("\\n[0-9]*", '', header[i])
}

activity <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

#Merges test and train data and assigns header
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_activity <- read.table("UCI HAR Dataset/test/y_test.txt") 
test_data <-cbind(test_sub, test_activity, test_data)
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt")
train_activity <- read.table("UCI HAR Dataset/train/y_train.txt") 
train_data <-cbind(train_sub, train_activity, train_data)
all_data <- rbind(test_data, train_data)
names(all_data) <- header
activity_names <- all_data$Activity
for(i in seq(1, length(activity_names))){
    activity_names[i] <- activity[all_data$Activity[i]]
}
all_data$Activity <- activity_names
names(all_data[2]) <- header[2]
#Subset data to only include  columns containing mean and standard deviation 
sub_header <- c("Subject", "Activity")
for(i in header){
  if(grepl("mean()", i) | grepl("std()", i)){
    sub_header <- c(sub_header, i)
  }
}
mean_std_data <- all_data[,sub_header]



#Renames variables


#Average data for each activity and subject
subjects <- sort(unique(mean_std_data$Subject))
return_data <- data.frame(matrix(ncol = ncol(mean_std_data), nrow = 0))
names(return_data) <- names(mean_std_data)
for(sub in subjects){
  sub_data<- mean_std_data[mean_std_data$Subject == sub,]
    for(item in activity){
      act_data <- sub_data[sub_data$Activity == item,]
      temp_data <- c(sub, item)
      temp_row <- data.frame(matrix(ncol = ncol(mean_std_data), nrow = 0))
      for (col in seq(3,ncol(act_data))){
        new_mean <- mean(act_data[[col]], na.rm = TRUE)
        temp_data <-c(temp_data, new_mean)
      }
      temp_row <- rbind(temp_row, temp_data)
      names(temp_row) <- names(mean_std_data)
      return_data <- rbind(return_data, temp_row)
      
    }
}
# export data
