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

#Gives the factors the descriptive codes based on activity type (e.g. 1 = WALKING)
tidy_data$code <- activities[tidy_data$code, 2]

#Tidying/renaming various variables to be more descriptive
names(tidy_data)[2] = "activity"
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))

#Takes the tidied dataset and computes the means
final_data <- group_by(tidy_data, subject, activity)
final_data <- summarise_all(final_data, funs(mean))

#writes the table to a txt file
write.table(final_data, "final_data.txt", row.name=FALSE)