###Merges the training and the test sets to create one data set
setwd("/Users/abbieho/Documents/CoursearR")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="./test.zip",method="curl")
untar("test.zip")
features <- read.table("UCI HAR Dataset/features.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
# Read test set
test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("id"))
test_x <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=features$V2, check.names=F)
test_y <- read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("activity"))
test <- data.frame(test_sub, test_y, test_x, check.names=F)

# Read Train set
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("id"))
train_x <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=features$V2, check.names=F)
train_y <- read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("activity"))
train <- data.frame(train_sub, train_y, train_x, check.names=F)

# Merge
d <- rbind(test, train)
d$activity <- factor(d$activity, labels=activity$V2)

### Extracts only the measurements on the mean and standard deviation for each measurement.
v <- grep(".*mean\\(\\)|.*std\\(\\)", colnames(d))
d_sub <- d[,c(1,2,v)]

### creates a second, independent tidy data set with the average of each variable for each activity and each subject.
d_sub_avg <- aggregate(.~ id+activity, data=d_sub, mean)
write.table(d_sub_avg,"UCI HAR Dataset/out.txt", row.name=F)
