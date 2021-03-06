#Checks for and download data in current working directory
files <- list.files()
if (!"UCI HAR Dataset" %in% files){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  if (Sys.info()['sysname'] == "Windows"){
    method <- "wininet"
  }else{method <- "curl"}
  download.file(url, "RAW_Data.zip", method)
  unzip("RAW_Data.zip")
}

#Set headers 
header <- as.list(strsplit(readChar("UCI HAR Dataset/features.txt", file.info("UCI HAR Dataset/features.txt")$size), ' ')[[1]])
header <- c("Subject", "Activity", header[2:length(header)])
for(i in seq(1:length(header))){
  header[i] <- sub("\\n[0-9]*", '', header[i])
}

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

#Switch activity code to names
activity <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
activity_names <- all_data$Activity
for(i in seq(1, length(activity_names))){
    activity_names[i] <- activity[all_data$Activity[i]]
}
all_data$Activity <- activity_names
names(all_data[2]) <- header[2]

#Subset data to only include  columns containing mean and standard deviation 
sub_header <- c("Subject", "Activity")
for(i in header){
  if(!grepl("meanFreq()", i)){
    if(grepl("mean()", i) | grepl("std()", i)){
      sub_header <- c(sub_header, i)
    }
  }
}
mean_std_data <- all_data[,sub_header]

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

#Renames variables
renamed <- c("Subject", "Activity")
for(item in seq(3,length(sub_header))){
  
  if(grepl("-mean()", sub_header[item])){func <-"Mean of"
  }else if(grepl("-std()", sub_header[item])){func <-"Standard Deviation of the"
  }else {func <-""}
  
  if(grepl("^t", sub_header[item])){
    signal <- "time domain signal"
  }else{signal <- "frequency domain signal"}
  
  if(grepl("Acc", sub_header[item])){ sensor <-"from the accelerometer"
  }else if(grepl("Gyro", sub_header[item])){sensor <-"from the gyroscope"
  }else {sensor <-""}
  
  if(grepl("Gravity", sub_header[item])){ movement <-"caused by gravity"
  }else if(grepl("Body", sub_header[item])){movement <-"caused by the body"
  }else {movement <-""}
  
  if(grepl("-X", sub_header[item])){axis <-"on the X-axis"
  }else if(grepl("-Y", sub_header[item])){axis <-"on the Y-axis"
  }else if(grepl("-Z", sub_header[item])){axis <-"on the Z-axis"
  }else {axis <-""}
  
  renamed <-c(renamed, paste("Mean of:", func, signal, sensor, movement, axis, sep = " "))
}
sub_header <- renamed
names(return_data) <- sub_header

# export data
write.table(return_data, "mean_results_by_subject.txt", row.names = FALSE)

