# Getting and Cleaning Data WK4 project

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

getwd()

## Data Preparation

# load activity and features
activity<- read.table("activity_labels.txt")
features <- read.table("features.txt")

# data Preparation
activityLabel <- read.table("activity_labels.txt")[,2]

# grep the mean and standard deviation from features
featuresMeanStd <- grepl("mean|std", features$V2)

# load test Data
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
names(X_test) = features$V2

# extract only with the names the mean and standard deviation.
X_test = X_test[,featuresMeanStd]

# load activity labels
y_test[,2] = activityLabel[y_test[,1]]
names(y_test) = c("ActivityID", "ActivityLabel")
names(subject_test) = "subject"

#testdata column bind
testData <- cbind(subject_test, y_test, X_test)

#train data load
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
names(X_train) = features$V2

#extract only with the names the mean and standard deviation.
X_train = X_train[,featuresMeanStd]

#activity data
y_train[,2] = activityLabel[y_train[,1]]
names(y_train) = c("ActivityID", "ActivityLabel")
names(subject_train) = "subject"

# cbind train data
trainData <- cbind(subject_train, y_train, X_train)

# rbind test and train data
combinedData = rbind(testData, trainData)

idLabels   = c("subject", "ActivityID", "ActivityLabel")
dataLabels = setdiff(colnames(combinedData), idLabels)
meltedData   = melt(combinedData, id = idLabels, measure.vars = dataLabels)

# Apply mean function to dataset using dcast function
tidyData   = dcast(meltedData, subject + ActivityLabel ~ variable, mean)

write.table(tidyData, file = "./tidydata.txt")
