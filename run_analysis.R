#This program was written in R studio running on Windows 10.
#To run in your PC replace dir locations to where UCI HAR Dataset folder is located
#Accessing data from unzipped UCI HAR Dataset folder....
x.train <- read.table("\\UCI HAR Dataset\\train\\X_train.txt")
x.test <- read.table("\\UCI HAR Dataset\\test\\X_test.txt")
sub.train <- read.table("\\UCI HAR Dataset\\train\\subject_train.txt")
sub.test <- read.table("\\UCI HAR Dataset\\test\\subject_test.txt")
y.train <- read.table("\\UCI HAR Dataset\\train\\Y_train.txt")
y.test <- read.table("\\UCI HAR Dataset\\test\\Y_test.txt")
var.names <- read.table("\\UCI HAR Dataset\\features.txt")
#Merging of accessed data and assiginment of variablenames
x <- rbind(x.train, x.test) #Here I have merged x_train and x_test datasets.
names(x) <- var.names[,2] #Here I have assigined names to the variables from data given in features.
y <- rbind(y.train, y.test) #Here I merged y_train and y_test datasets.
names(y) <- "act_labels" 
sub <- rbind(sub.train, sub.test)
names(sub) <- "subject_id"
#Extraction of measurements on mean and std deviation from x.
mean.index <- grep("mean()", var.names[,2]) #Here I have obtained the index aka. locations where mean() is present.
std.index <- grep("std()", var.names[,2]) #Here I have obtained the index aka. locations where std() is present.
x.mean.std <- x[,c(mean.index, std.index)] #Here I extract mean and std variables. 
x.mean.std <- cbind(y, x.mean.std)
act.labels <- read.table("\\UCI HAR Dataset\\activity_labels.txt")
for (val in 1: length(x.mean.std$act_labels)) { #Here using this for loop I replace Activity label with Activity name.
  k <- x.mean.std$act_labels[val]
  x.mean.std$act_labels[val] <- act.labels[k,2]
}
x.mean.std <- cbind(sub,x.mean.std) # Here I join Subject_id col. with x.mean.std.
library(dplyr) #Here I import dplyr package.
#Average of each variable for each activity and each subject.
tidyset <- x.mean.std %>% group_by(subject_id, act_labels) %>% summarise_all(mean)# tidy set
write.table(tidyset, "\\tidyset.txt", row.name=FALSE) #I have written tidy set to a text file. 

