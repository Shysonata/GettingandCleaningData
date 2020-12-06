#Ensure Samsung data is in wd
library(dplyr)

#Reads in all dfs
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

#Merges training and test sets into unified dfs
x_complete <- rbind(x_train, x_test)
y_complete <- rbind(y_train, y_test)
subject_complete <- rbind(subject_train, subject_test)
samsung_data <- cbind(subject_complete, x_complete, y_complete)

#Tidies up dataset
tidy_data <- select(samsung_data, subject, code, contains("mean"), contains("std"))
