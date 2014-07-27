#    Getting And Cleaning Data Project
#    James D. Beck
#    7/21/2014
#
#    This script is written to take the Samsung project data and create
#    a tidy data set out of it. This script requires you to have the
#    Samsung data in your current working directory. If you do not have
#    the Samsung data, then you MUST run download_data.R prior to
#    running this script. This script will create a file titled
#    output.csv in the working directory containing the tiday dataset.
#
#    Read separate tables back for re-use
test_data <- read.table("X_test.txt")
test_label <- read.table("y_test.txt")
test_subject <-read.table("subject_test.txt")
train_data <- read.table("X_train.txt")
train_label <- read.table("y_train.txt")
train_subject <- read.table("subject_train.txt")
features <- read.table("features.txt")
labels <- read.table("activity_labels.txt")

#    1. Merge the training and the test sets to create one data set.
#    First add the labels into the separate datasets
test_data <- cbind(test_subject, test_label, test_data)
train_data <- cbind(train_subject, train_label, train_data)

#    Now combine the two datasets into one
combined_data<-rbind(test_data, train_data)
dim(combined_data)

#    Create column headers and re-name column names in data.
column_headers<-cbind("Subject", "Activity", t(as.data.frame(features$V2)))
names(combined_data) <- column_headers

#    2. Extract only the measurements on the mean and standard 
#    deviation for each measurement.
#    Identify all the columns containing the text "mean"
mean_columns <- grep("mean", features[[2]])

#    Identify all the columns containing the test "meanFreq"
meanFreak_columns <- grep("meanFreq", features[[2]])

#    remove all columns containing "meanFreak" instead of just "mean"
mean_final_columns <- setdiff(mean_columns, meanFreak_columns)

#    Idenfity all the columns containing the text "std"
std_columns <- grep("std", features[[2]])

#    Combine "mean" and "std" column lists
final_columns <- c(1, 2, mean_final_columns+2, std_columns+2)

#    Get rid of everything that is not a mean or standard deviation
new_data <- subset(combined_data, select=final_columns)

#    3. Use descriptive activity names to name the activities in the
#    data set.
new_data$Activity <- labels$V2[new_data$Activity]

#    4. Appropriately label the data set with descriptive variable
#    names.
#    Start by getting the headers based upon the existing column names
headers<-names(new_data)

#    Remove all special characters and expand abbreviations
headers<-gsub("\\(", "", headers)
headers<-gsub("\\)", "", headers)
headers<-gsub("-X", ".X", headers)
headers<-gsub("-Y", ".Y", headers)
headers<-gsub("-Z", ".Z", headers)
headers<-gsub("Acc", "Accelerometer", headers)
headers<-gsub("Gyro", "Gyroscope", headers)
headers<-gsub("Mag", "Magnitude", headers)
headers<-gsub("-mean", ".Mean", headers)
headers<-gsub("-std", "StandardDeviation", headers)
headers<-gsub("tBody", "TimeBody", headers)
headers<-gsub("fBody", "FastFourierTransformBody", headers)
headers<-gsub("tGravity", "TimeGravity", headers)
headers<-gsub("fGravity", "FastFourierTransformGravity", headers)
headers<-gsub("BodyBody", "Body", headers)

#    Set the names to our modified column headers now
names(new_data) <- t(as.data.frame(headers))

#    #################################################################
#    
#    This section is here to write data temporarily to aid in coding
#    and debugging the code. I have left it here on purpose. The file
#    created is just a working file and does NOT contain the final
#    tidy dataset.
#
#    Write our first tidy data set out as CSV file for later re-use.
write.csv(new_data, "temp_file.csv")

#    Read back our first tidy data set for reuse.
new_data <- read.csv("temp_file.csv")

#    #################################################################

#    5. Create a second, independent tidy data set with the average of
#    each variable for each activity and each subject.
#    First let's separate out by subject and activity
grouped_data <- split(new_data, list(new_data$Subject, new_data$Activity))

#    Create empty data frame for our means
tiny_data_build <- as.data.frame(matrix(ncol=2,nrow=length(grouped_data)))
names(tiny_data_build) <- c(names(grouped_data[[1]])[[2]],
                            names(grouped_data[[1]])[[3]])

#    Save nececessary data for Subject and Activity columns
for (i in 1:nrow(tiny_data_build)) {
     tiny_data_build$Subject[[i]] <- as.integer(grouped_data[[i]]$Subject[[1]])
     tiny_data_build$Activity[[i]] <- as.character(grouped_data[[i]]$Activity[[1]]) 
}

#    Remove Subject and Activity columns from our working dataset
working_data <- lapply(grouped_data, subset, select=4:69)

#    Calculate means by column for every item in working_data list
final_means_data <- t(sapply(working_data, colMeans))

#    Combine 
output_data <- cbind(tiny_data_build, final_means_data)

#    Now write our output without labels so we don't have extraneous
#    information in our tidy data set.
write.csv(output_data, "output.csv", row.names=FALSE)
