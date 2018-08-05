############################################################################
##Peer-graded Assignment: Getting and Cleaning Data Course Project - Week 4
############################################################################

  ##load datasets
  
  ##load training sets
path_xtrain ="C:\\Users\\Andy's Home PC\\Documents\\Coursera Courses\\Data Science\\Getting and Cleaning Data\\Week 4\\UCI HAR Dataset\\train\\X_train.txt"
path_ytrain = "C:\\Users\\Andy's Home PC\\Documents\\Coursera Courses\\Data Science\\Getting and Cleaning Data\\Week 4\\UCI HAR Dataset\\train\\y_train.txt"
path_subject_train = "C:\\Users\\Andy's Home PC\\Documents\\Coursera Courses\\Data Science\\Getting and Cleaning Data\\Week 4\\UCI HAR Dataset\\train\\subject_train.txt"

xtrain <- read.table(path_xtrain, header=FALSE)
ytrain <- read.table(path_ytrain, header=FALSE)
subject_train <- read.table(path_subject_train, header=FALSE)

##load test sets
path_xtest = "C:\\Users\\Andy's Home PC\\Documents\\Coursera Courses\\Data Science\\Getting and Cleaning Data\\Week 4\\UCI HAR Dataset\\test\\X_test.txt"
path_ytest = "C:\\Users\\Andy's Home PC\\Documents\\Coursera Courses\\Data Science\\Getting and Cleaning Data\\Week 4\\UCI HAR Dataset\\test\\y_test.txt"
path_subject_test = "C:\\Users\\Andy's Home PC\\Documents\\Coursera Courses\\Data Science\\Getting and Cleaning Data\\Week 4\\UCI HAR Dataset\\test\\subject_test.txt"

xtest <- read.table(path_xtest, header=FALSE)
ytest <- read.table(path_ytest, header=FALSE)
subject_test <- read.table(path_subject_test, header=FALSE)

##load features data
path_features ="C:\\Users\\Andy's Home PC\\Documents\\Coursera Courses\\Data Science\\Getting and Cleaning Data\\Week 4\\UCI HAR Dataset\\features.txt"
features <- read.table(path_features, header=FALSE)

##load activity labels
path_activity_labels = "C:\\Users\\Andy's Home PC\\Documents\\Coursera Courses\\Data Science\\Getting and Cleaning Data\\Week 4\\UCI HAR Dataset\\activity_labels.txt"
activity_labels <- read.table(path_activity_labels, header=FALSE)


##rename columns to make it more descriptive (part of answer 3)
colnames(xtrain) <- features[,2] #rename columns of "xtrain" with those in col 2 of "features"
colnames(ytrain) <- "activityId" #rename columns of "ytrain"
colnames(subject_train) <- "subjectId" #rename columns of "subject_train"

colnames(xtest) <- features[,2]
colnames(ytest) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <- c("activityId", "activityType")


##1. Merges the training and the test sets to create one data set.
merged_train <- cbind(ytrain, subject_train, xtrain)
merged_test <- cbind(ytest, subject_test, xtest)
merged_master <- rbind(merged_train, merged_test)


##2. Extracts only the measurements on the mean and standard deviation for each measurement.
colNames <- colnames(merged_master)
mean_and_std = (grepl("activityId", colNames) | grepl("subjectId", colNames) | grepl("mean..", colNames) | grepl("std..", colNames))

MeanAndStd_set <- merged_master[, mean_and_std == TRUE]


##3 & 4. Uses descriptive activity names to name the activities in the data set
##Note: MeanAndStd_set has activityId and some parameters; activity_labels has actvityId that 
##maps to activityType. So we need to merge MeanAndStd_set with activity_labels, in order to link parameters 
##in MeanAndStd_set to activity Type. Common linkage is activityId, so we use merge() function.
ActivityNames_set <- merge(MeanAndStd_set, activity_labels, by="activityId", all.x=TRUE)

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
##for each activity and each subject.
secTidySet <- aggregate(. ~subjectId + activityId, ActivityNames_set, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]


##Saving New Data
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)