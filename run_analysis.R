## run_analysis.R
## Getting and Cleaning Data course, Coursera, 2014
# 
# Analyses accelerometer and gyroscope data from a smart phone.
#
# NOTE! Assumes that the Samsung data is in a subfolder called "ACI HAR Dataset"
#
# Merges the training and the test sets to create one data set. Extracts only
# the measurements on the mean and standard deviation for each measurement. Uses
# descriptive activity names to name the activities in the data set 
# Appropriately labels the data set with descriptive activity names. Creates a
# second, independent tidy data set with the average of each variable for each
# activity and each subject.
#
# The data comes from here:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Janne Simonen, 2014

## Read the data

fileTraining_x <- "UCI HAR Dataset/train/X_train.txt"
fileTraining_y <- "UCI HAR Dataset/train/y_train.txt"
fileTest_x <- "UCI HAR Dataset/test/X_test.txt"
fileTest_y <- "UCI HAR Dataset/test/y_test.txt"
train_x <- read.table(fileTraining_x)
train_y <- read.table(fileTraining_y)
test_x <- read.table(fileTest_x)
test_y <- read.table(fileTest_y)

# read the column names a.k.a features of the data sets
fileFeatures <- "UCI HAR Dataset/features.txt"
features <- read.table(fileFeatures,stringsAsFactors=FALSE)
features <- features[,2] # second column is the name of the feature

# read subjects who performed each measurements
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt",stringsAsFactors=FALSE)
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt",stringsAsFactors=FALSE)

## Merges the training and the test sets to create one data set. 

# combine data with subject and activity colums
trainFull <- cbind(trainSubject,train_y,train_x)
testFull <- cbind(testSubject,test_y,test_x)

# row bind trainging and test sets into one data frame
data <- rbind(trainFull,testFull)

# name the columns properly, taking the names from the features.txt file
colnames(data) <- c("Subject","Activity",features)

## Extracts only the measurements on the mean and standard deviation for each measurement. 
# find the columns for mean and std - the column names with "mean()" or "std()"
meanInd <- grep("mean()",colnames(data))
stdInd <- grep("std()",colnames(data))
meanstdInd <- sort(c(meanInd,stdInd))

# extract only the desired columns, plus the Subject and Activity columns
data2 <- data[,c(1,2,meanstdInd)]

## Uses descriptive activity names to name the activities in the data set 
## Appropriately labels the data set with descriptive activity names. 

# get activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)

# loop though the labels, change activity numbers in data to descriptive labels
# (there must be a loopless way, but I couldn't find it)
activities <- data2[,"Activity"]  # easier this way
for(i in 1:nrow(activityLabels)){
  activities[activities == activityLabels[i,1]] <- activityLabels[i,2]
}
data2[,"Activity"] <- activities # put the modified activity data back in the data

## Creates a second, independent tidy data set with the average of each variable for each
## activity and each subject.

# get the mean for each activity and subject
dataAverage <- aggregate(data2[,3:81],list(Activity = data2$Activity, Subject = data2$Subject),mean)

# save the data file as text
write.table(dataAverage,"ProjectData.txt",row.names=FALSE)

# output the data
dataAverage