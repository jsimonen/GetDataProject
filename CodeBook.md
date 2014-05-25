CodeBook.md
========================================================
This file describes how run_analysis.R works, what data it operates on and produces.

## Original data

The code assumes that the original data is in a subfolder called *ACI HAR Dataset* and that the directory structure within is unchanged from the original zip file. The original data, along with the original code book can be downloaded from

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Required files

The original data files required by run_analysis.R are
* UCI HAR Dataset/train/X_train.txt
* UCI HAR Dataset/train/y_train.txt
* UCI HAR Dataset/test/X_test.txt
* UCI HAR Dataset/test/y_test.txt
* UCI HAR Dataset/features.txt
* UCI HAR Dataset/train/subject_train.txt
* UCI HAR Dataset/test/subject_test.txt
* UCI HAR Dataset/activity_labels.txt

## Running run_analysis.R

To run the file, first save it in a folder that contains the required data subfolder as described above. Then execute the file by typing the following on the R command line:
```
source("run_analysis.R")
```

## The transformations

The exact process used by run_analysis.R to produce the tidy data set from the original data files is as follows:

1. The code merges the training and the test sets to create one data set. This is done by rowbinding them as they share the same variables. Moreover, two extra columns are added, one for the subject who perfomed the measurement and one for the activity the subject was performing.
2. The columns are given human-readable names. The variable names are extracted from *features.txt*.
3. Of the 563 variables of the original data only those that summarize the measurements by average or standard deviation are extracted. This is done by finding the columns whose names include "mean()" or "std()". This leaves 79 measured variables, plus two columns for activity and subject.
4. The types of activities the subjects performed are only given as numbers in the original data. The corresponding human-readable names are given in the file *activity_labels.txt*. The activity numbers are replaced by the corresponding text labels.
5. There are multiple measurements of each activity by each subject. The code summarizes these by taking the mean of each variable for each activity and subject. This is the final tidy data set.

## Variable names and descriptions

The column names of the tidy data set come directly from the data file *features.txt*. The detailed descriptions of each variable can be found from the data file *features_info.txt*. As mentioned above, only those variables that contain averages (mean) or standard deviations (std) are used to produce the tidy data.

## The output

The tidy data set, obtained with the transformations described above, is saved as **ProjectData.txt** in text format using `write.table()`
