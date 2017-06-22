# run_analysis.R

## Get data

Data is checked for in the working directory. If not found, the data is downloaded and the zipped folder is saved as "RAW_data.zip".

## Set Headers 
Reads through the "features.txt" file and adds each item to the header vector. This is assigned as the header to the test and train data sets.  

## Merge test and train data
Reads test and train data from .txt files within approriate folders. Subject numbers, activity codes, and accelerometer/gyroscope data are combined to both test and train data, then both sets are merged using rbind() to create a data frame called "all_data". Header is assigned to all_data.

## Convert Activity code to activity names
Takes the activity code number and converts it to a descriptiv activity name based on the "activity_labels.txt".

## Subset data 
Only includes subject number, activity name, columns containing mean data, and columns containing standard devaition data. Does not include data estimated using the meanFreq() function.  


## Average data for each subject and activity
Subsets the data by subject number then by activity. Takes average of each column then adds it to "return_data" data frame. 

## Rename variables
Takes the header provided by the "features.txt" file and deciphers it into a descriptive variable name. The variable names are described in the codebook. 

## Export Data
Writes the exported data as a .txt file named "mean_results_by_subject.txt"