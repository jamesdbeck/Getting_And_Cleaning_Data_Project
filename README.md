### Introduction

The goal of this assignment was to take data from an external website
and convert it into a tidy dataset. This is the course project for the
Data Science Specialization - Getting And Cleaning Data on Coursera
given in July 2014.

I have completed the project using 2 R Scripts- 1) "download_data.R"
and 2) "run_analysis.R". If you do not already have the data unzipped
and saved in your working directory you MUST run download_data.R 
first. If you already have the data downloaded and unzipped in your 
working directory you just need to run run_analysis.R. 

The final tidy dataset will be saved as "outcome.csv" in your working 
directory. The description of each column can be found in the code
book named "Tidy_Data_Field_Description.txt"

All files in this can be freely shared but must contain this README.md
file.

### Original Dataset License 
Use of this dataset in publications must be acknowledged by 
referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and 
Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using 
a Multiclass Hardware-Friendly Support Vector Machine. International 
Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, 
Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or 
explicit can be addressed to the authors or their institutions for its 
use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. 
November 2012.

### Project Files
	"README.md" - This file
	"Tidy_Data_Field_Description.txt" - Code Book for the output
	"download_data.R" - R Script to download original data
	"run_analysis.R" - R Script to clean data and create tiday dataset
	"output.csv" - Output from running both R Scripts
	
### Script: "download_data.R"

This script downloads the zipped data file from the original source
("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip".

It then unzips the data files needed:
	1) "X_test.txt" - Observations for the "y_test.txt" activities of
	   the "subject_test.txt" subjects.
	2) "y_test.txt" - Activities used in the "X_test.txt" observations
	   for the "subject_test.txt" subjects.
	3) "subject_test.txt" - Subjects for the "X_test.txt" observations 
	   of the "y_test.txt" activities.
	4) "X_train.txt"- Observations for the "y_train.txt" activities of
	   the "subject_train.txt" subjects.
	5) "y_train.txt" - Activities used in the "X_train.txt" observations
	   of the "subject_train.txt" subjects.
	6) "subject_train.txt" - Table of subjects for the "X_train.txt"
	   observations of the "y_train.txt" activities.
	7) "features.txt" - Table of columns in the "X_test.txt" and
	   "X_train.txt" observation data files.
	8) "activity_labels.txt" - Table to link activity code nuumbers in 
	   the "X_test.txt" and "X_train.txt" observation files actual
	   activities.

Laastly, all unzipped files are written to the current working directory
for use by the "run_analysis.R" script.

### Script: "run_analysis.R"

This script reads in all of the files created by the "download_data.R"
script from the currrent working directory. See above for list of files
read.

"cbind" is used to merge the contents of "subject_test.txt", 
"y_test.txt", and "X_test.txt" into the dataframe "test_data". 

"cbind" is used to merge the contents of "subject_train.txt", 
"y_train.txt", and "X_train.txt" into the datarame "train_data". 

"rbind" is used to combine the contents of "test_data" and 
"train_data" into dataframe "combined_data". The names of all the
columns are updated based upon the information in "features.txt".

"grep" is used to create lists of all the columns containing "mean",
"meanFreq", and "std". The colummns containing "meanFreq" are removed
from those containing "mean" using "setdiff". The first ("Subject") and
second ("Activity") column numbers from "combined_data" are then 
combined with numbers of the columns containing just "mean" and those
containing "std".

Dataframe "new_data" is created by using "subset" to remove all columns
except 1, 2, and those containing "mean" but not "meanFreak" and those
containing "std".

Column 2 ("Activity" is converted from a code number to text activity
label based upon information in "activity_labels.txt"

All remaining column headers are cleaned up to remove the special
characters, "(" and ")". The XYZ axis information is cleaned up by
replacing "_X", "_Y", and "_Z" with ".X", ".Y", and ".Z" respectively.
"Acc" is replaced with "Accelerometer", "Gyro" with "Gyroscope", and
"Mag" with "Magnitude". "_mean" and "_std" are replaced by ".Mean" and
".StandardDeviation" respectively. The leading "t" and "f" are replaced
by "Time" and "FastFourierTransform". Lastly, "BodyBody" is replaced by
"Body". All replacements are done using "gsub".

All data is then split using "split" into a list of datasets 
"grouped_data" by "Subject" and "Activity". 

"Subject" and "Activity" column information is then stored into a new
dataframe "tiny_data_build".

"lapply" is used to create a list "working_data" of dataframes without
the first 3 columns  from dataframe "grouped_data". 

Using "t", "sapply", and "colMeans" the dataframe "final_means_data" 
is created containing the means of each "Subject" and "Activity" 
observation grouping.

Dataframe "output_data" is then created by combining "tiny_data_buid"
and "final_means_data" using "cbind". This datafame is written out
without row headers to file "output.csv" in the current working 
directory using "write.file".
