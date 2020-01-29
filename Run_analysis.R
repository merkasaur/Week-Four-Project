#load prereqs and download dataset
library(dplyr)
filename <- "Coursera_DS3_Final.zip"

if (!file.exists(filename)){
      fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
      unzip(filename) 
}

#One: Merge training/test
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)
#Two: STD/Mean extraction
Selection <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
#Three: Description activities
Selection$code <- activities[Selection$code, 2]
#Four: Labels
names(Selection)[2] = "activity"
names(Selection)<-gsub("Acc", "Accelerometer", names(Selection))
names(Selection)<-gsub("Gyro", "Gyroscope", names(Selection))
names(Selection)<-gsub("BodyBody", "Body", names(Selection))
names(Selection)<-gsub("Mag", "Magnitude", names(Selection))
names(Selection)<-gsub("^t", "Time", names(Selection))
names(Selection)<-gsub("^f", "Frequency", names(Selection))
names(Selection)<-gsub("tBody", "TimeBody", names(Selection))
names(Selection)<-gsub("-mean()", "Mean", names(Selection), ignore.case = TRUE)
names(Selection)<-gsub("-std()", "STD", names(Selection), ignore.case = TRUE)
names(Selection)<-gsub("-freq()", "Frequency", names(Selection), ignore.case = TRUE)
names(Selection)<-gsub("angle", "Angle", names(Selection))
names(Selection)<-gsub("gravity", "Gravity", names(Selection))
#Five: Average
ProjectOut <- Selection %>%
      group_by(subject, activity) %>%
      summarise_all(funs(mean))
write.table(ProjectOut, "ProjectOut.txt", row.name=FALSE)
#Six: Check
str(ProjectOut)
print(ProjectOut)
