library(dplyr)
#Frist, let's work on the "test" data
#subject (person) for each line in xtest
subject.test<-read.table(file = 
    "./UCI HAR Dataset/test/subject_test.txt")
colnames(subject.test)<-"Subject"
#the actual data file
feature.names<-read.table(file = 
    "./UCI HAR Dataset/features.txt")
f.names<-feature.names[,2]
#xtest<-read.table(file = "./test/X_test.txt")
xtest<-read.table(file = 
    "./UCI HAR Dataset/test/X_test.txt", col.names = f.names)
#the activity for each line in xtest
ytest<-read.table(file = 
    "./UCI HAR Dataset/test/y_test.txt")

#get the file that links activity number to the actual description
activity<-read.table(file = 
    "./UCI HAR Dataset/activity_labels.txt")

#replace the activity number with the description
ytest$V1<-as.factor(activity$V2[ytest$V1])
colnames(ytest)<-"Activity"

#combine the data so that the columns of test_data will be in the
#order of subject, activity, features (1 - 561)
test.data<-cbind(subject.test,ytest,xtest)

#Now let's work on the "train" data
#This is the same sequence of commands as the test section, but all variable names will
#have "train" instead of "test" in them
subject.train<-read.table(file = 
    "./UCI HAR Dataset/train/subject_train.txt")
colnames(subject.train)<-"Subject"
xtrain<-read.table(file = 
    "./UCI HAR Dataset/train/X_train.txt", col.names = f.names)
ytrain<-read.table(file = 
    "./UCI HAR Dataset/train/y_train.txt")
ytrain$V1<-as.factor(activity$V2[ytrain$V1])
colnames(ytrain)<-"Activity"
train.data<-cbind(subject.train,ytrain,xtrain)

#Now to add the rows of the test and train datasets together
all.data<-rbind(test.data, train.data)

#To remove all feature data that is not related to a mean or standard deviation
#we will search for all features with "mean" and "std" in the feature name.
columns.to.keep<-grep("mean|std", f.names)
#Since all.data has Subject and Activity columns already, we need
#to add 2 to  columns.to.keep so that we can subset all.data right
columns.to.keep<-2+columns.to.keep
columns.to.keep<-c(1,2,columns.to.keep)
all.std.mean.data<-all.data[,columns.to.keep]

#Now to summarize the data into a tidy data set
data.by.subject.activity<-group_by(all.std.mean.data, Subject, Activity)
tidy<-data.by.subject.activity %>% summarise_each(funs(mean))
tidy
