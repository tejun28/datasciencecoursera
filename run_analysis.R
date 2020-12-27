
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

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:

    filter, lag

The following objects are masked from ‘package:base’:

    intersect, setdiff, setequal, union

Warning message:
package ‘dplyr’ was built under R version 4.0.3 
> #download data
> filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
> #check if file exists
> if (!file.exists(filename)){
+   fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
+   download.file(fileURL, filename, method="curl")
+ }  
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0  0 59.6M    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0  2 59.6M    2 1451k    0     0  1451k      0  0:00:42  0:00:01  0:00:41  910k  6 59.6M    6 3819k    0     0  1909k      0  0:00:31  0:00:02  0:00:29 1455k  7 59.6M    7 4763k    0     0  1587k      0  0:00:38  0:00:03  0:00:35 1325k 10 59.6M   10 6507k    0     0  1626k      0  0:00:37  0:00:04  0:00:33 1416k 18 59.6M   18 10.8M    0     0  2219k      0  0:00:27  0:00:05  0:00:22 2344k 24 59.6M   24 14.8M    0     0  2537k      0  0:00:24  0:00:06  0:00:18 2755k 29 59.6M   29 17.6M    0     0  2586k      0  0:00:23  0:00:07  0:00:16 2866k 34 59.6M   34 20.6M    0     0  2637k      0  0:00:23  0:00:08  0:00:15 3267k 41 59.6M   41 24.5M    0     0  2792k      0  0:00:21  0:00:09  0:00:12 3724k 48 59.6M   48 29.0M    0     0  2978k      0  0:00:20  0:00:10  0:00:10 3737k 56 59.6M   56 33.4M    0     0  3116k      0  0:00:19  0:00:11  0:00:08 3811k 59 59.6M   59 35.6M    0     0  3040k      0  0:00:20  0:00:12  0:00:08 3687k 65 59.6M   65 39.3M    0     0  3101k      0  0:00:19  0:00:13  0:00:06 3843k 72 59.6M   72 43.0M    0     0  3147k      0  0:00:19  0:00:14  0:00:05 3785k 76 59.6M   76 45.5M    0     0  3111k      0  0:00:19  0:00:15  0:00:04 3376k 78 59.6M   78 47.1M    0     0  3014k      0  0:00:20  0:00:16  0:00:04 2730k 85 59.6M   85 50.8M    0     0  3062k      0  0:00:19  0:00:17  0:00:02 3113k 92 59.6M   92 55.2M    0     0  3145k      0  0:00:19  0:00:18  0:00:01 3260k 97 59.6M   97 57.8M    0     0  3119k      0  0:00:19  0:00:19 --:--:-- 3043k100 59.6M  100 59.6M    0     0  3054k      0  0:00:20  0:00:20 --:--:-- 2997k
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
