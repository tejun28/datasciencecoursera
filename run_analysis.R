
R version 4.0.2 (2020-06-22) -- "Taking Off Again"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> library(dplyr)

Attaching package: �dplyr�

The following objects are masked from �package:stats�:

    filter, lag

The following objects are masked from �package:base�:

    intersect, setdiff, setequal, union

Warning message:
package �dplyr� was built under R version 4.0.3 
> #download data
> filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
> #check if file exists
> if (!file.exists(filename)){
+   fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
+   download.file(fileURL, filename, method="curl")
+ }  
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

> 
> # Checking if folder exists
> if (!file.exists("UCI HAR Dataset")) { 
+   unzip(filename) 
+ 
+ }
> #assign data frames
> features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
> activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
> subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
> x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
> y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
> subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
> x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
> y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
> 
> #merge the training and test sets to create one data set
> X <- rbind(x_train, x_test)
> Y <- rbind(y_train, y_test)
> Subject <- rbind(subject_train, subject_test)
> Merged_Data <- cbind(Subject, Y, X)
> 
> #extracts only the measurments on the mean and standard deviation for each measurments
> TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
> 
> #naming activities in the data set
> TidyData$code <- activities[TidyData$code, 2]
> 
> #label the data set with variable names
> names(TidyData)[2] = "activity"
> names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
> names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
> names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
> names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
> names(TidyData)<-gsub("^t", "Time", names(TidyData))
> names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
> names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
> names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
> names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
> names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
> names(TidyData)<-gsub("angle", "Angle", names(TidyData))
> names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
> 
> #create 2nd independent data set with the average of each variable for each activity and each subject
> FinalData <- TidyData %>%
+     group_by(subject, activity) %>%
+     summarise_all(funs(mean))
Warning message:
`funs()` is deprecated as of dplyr 0.8.0.
Please use a list of either functions or lambdas: 

  # Simple named list: 
  list(mean = mean, median = median)

  # Auto named with `tibble::lst()`: 
  tibble::lst(mean, median)

  # Using lambdas
  list(~ mean(., trim = .2), ~ median(., na.rm = TRUE))
This warning is displayed once every 8 hours.
Call `lifecycle::last_warnings()` to see where this warning was generated. 
> write.table(FinalData, "FinalData.txt", row.name=FALSE)