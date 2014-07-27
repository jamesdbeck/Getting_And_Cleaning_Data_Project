#
#    Getting And Cleaning Data Project
#    James D. Beck
#    7/21/2014
#
#    This R Scripit will download the project data from the UCI website
#    and save it into my working directory for the project. I have
#    split this from run_analysis.R because the assignment specifically
#    stated that run_analysis.R should "run as long as the Samsung data
#    is in your working directory." If you do not have the Samsung data
#    you should change to your working directory and run this script
#    followed by run_analysis.R.
#

#    Start by downloading the zipped file.
fileURL <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI HAR Dataset.zip"
temp <- tempfile()
download.file(fileURL,temp)

#    Unzip the datasets into test_data, test_label, train_data, and train_label.
test_data <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
test_label <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
test_subject <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
train_data <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
train_label <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
train_subject <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
features <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
labels <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))

#    Unlink the temporary file to release our hold on the website.
unlink(temp)

#    Write separate tables back for re-use.
setwd("C:/Users/James/Copy/Programming/R/Getting_Data/Project")
write.table(test_data, "X_test.txt")
names(test_label) <- "Activity"
write.table(test_label, "y_test.txt")
names(test_subject) <- "Subject"
write.table(test_subject, "subject_test.txt")
write.table(train_data, "X_train.txt")
names(train_label) <- "Activity"
write.table(train_label, "y_train.txt")
names(train_subject) <- "Subject"
write.table(train_subject, "subject_train.txt")
write.table(features, "features.txt")
write.table(labels, "activity_labels.txt")
