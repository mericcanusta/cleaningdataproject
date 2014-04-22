getTidySamsungData<- function(){
# Download and unzip the file into the working directory if it doesn't exist
if(!file.exists("./UCI HAR Dataset")){
    DownloadMethods<-c("internal","curl")
    file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(file,"samsungdata.zip",mode="wb",method=DownloadMethods[2-as.numeric(.Platform$OS.type=="windows")]) 
    unzip("samsungdata.zip")
}
message("Generating summary data...")
#Read X_train labels and activity labels
features<-read.table("./UCI HAR Dataset/features.txt",colClasses=c("numeric","character"))
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",colClasses=c("numeric","character"))
# Merge training data with proper column and activity labels
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt",colClasses="numeric")
names(X_train)<-features[,2]
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt",colClasses="numeric")
y_trainchar<-character(nrow(y_train))
for (i in 1:nrow(y_train)) y_trainchar[i]<- activity_labels[y_train[i,1],2]
s_train<-read.table("./UCI HAR Dataset/train/subject_train.txt",col.names="subjectID",colClasses="numeric")
X_train<-cbind(s_train,activity=y_trainchar,X_train)
rm(y_train,s_train,y_trainchar,i)
# Merge test data
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt",colClasses="numeric")
names(X_test)<-features[,2]
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt",colClasses="numeric")
y_testchar<-character(nrow(y_test))
for (i in 1:nrow(y_test)) y_testchar[i]<- activity_labels[y_test[i,1],2]
s_test<-read.table("./UCI HAR Dataset/test/subject_test.txt",col.names="subjectID",colClasses="numeric")
X_test<-cbind(s_test,activity=y_testchar,X_test)
rm(y_test,s_test,y_testchar,i)
# Append the above two data to generate one large data.frame DataSet, ordered in 
# SubjectID and activity
DataSet<-rbind(X_train,X_test)
rm(X_train,X_test,activity_labels,features)
DataSet<-DataSet[order(DataSet$subjectID,DataSet$activity),]
rownames(DataSet)<-seq(to=nrow(DataSet))
# From X, extract only the columns for the mean and the standard deviation 
# of measurements and discard the large dataset
SummaryData<- DataSet[,c(1:2,grep("mean()", colnames(DataSet),fixed=TRUE),grep("std()", colnames(DataSet)))]
SummaryData<<- SummaryData[,order(names(SummaryData))]
rm(DataSet)
# Gather means of each variable by activity subject pairs
message("Generating activity-subject means...")
pairs<-interaction(SummaryData$activity,SummaryData$subjectID,lex.order=TRUE)
ActivitySubjectMeans<-as.data.frame(sapply(split(SummaryData,pairs),function(x) colMeans(x[3:ncol(x)])))
ActivitySubjectMeans<<- t(ActivitySubjectMeans[order(rownames(ActivitySubjectMeans)),])
message("done!")
}