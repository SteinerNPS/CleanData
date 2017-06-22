#run_analysis.R

## Get data

Data is checked for in the working directory. If not found, the data is downloaded and the zipped folder is saved as "RAW_data.zip".

## Set Headers 
Reads through the "features.txt" file and adds each item to the header vector. This is assigned as the header to the test and train data sets.  

## Merge test and train data
Reads test and train data from .txt files within approriate folders. Subject numbers, activity codes, and accelerometer/gyroscope data are combined to both test and train data, then both sets are merged using rbind() to create a data frame called "all_data". Header is assigned to all_data.

##Convert Activity code to activity names


##Subset data 
Only includes subject number, activity name, columns containing mean data, and columns containing standard devaition data. 

##Rename variables


##Average data for each subject and activity


##Export Data
Writes the exported data as a .txt file named "mean_results_by_subject.txt"