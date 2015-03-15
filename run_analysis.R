## Description: run-analysis.R script
##
## R-version    3.1.3 (2015-03-09) -- "Smooth Sidewalk"
## Copyright (C) 2015 The R Foundation for Statistical Computing
## Platform: x86_64-w64-mingw32/x64 (64-bit)
##
## purpose:     1. Merge the training and the tests sets to create unified data sets (tidy)
##              2. Extracts only the measurements on the mean() and std() for each measurement
##                 Note: This implies we are not attempting to dig down into the raw data layer
##              3. Uses descriptive activity names to name the activities in the data set
##              4. Label appropriately the data set with descriptive variable names
##              5. From the data set in step 4, create a second, independent, tidy data set
##                 with the average of each variable for each activity and each subject
##
## Reference:   1. http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/
##              2. http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##              3. https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
## Input parameters section
## 
setwd("R:/Getting-Cleaning-Data")       # start with a fresh working directory first
datadir<-"./data"                       # sub-directory where the data will be placed
SSLurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
querytext<-"[Mm][Ee][Aa][Nn]\\(\\)|[Ss][Tt][Dd]\\(\\)"  # to extract mean() and std()
##
## packages needed for this script
##
# install.packages("RCurl") # needed to handle Certified (SSL) URL
library(RCurl)
# install.packages("dplyr") # needed for data frame manipulations
library(dplyr)
# install.packages("tidyr") # needed for tidy data frame support
library(tidyr)
##
##
## Step 1 - Merge the training and the tests sets to create unified data sets (tidy)
##
## To extract the filename from the SSLurl and extract in a fresh datadir structure, first
## create a data subdirectory below working directory to import the datafile
if (!file.exists(datadir)) {dir.create(datadir)} 
filename<-paste(datadir,strsplit(SSLurl,"%20")[[1]][length(strsplit(SSLurl,"%20")[[1]])],sep="/")
download.file(SSLurl, dest=filename, mode="wb") 
#> trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
#> Content type 'application/zip' length 62556944 bytes (59.7 MB)
#> opened URL
#> downloaded 59.7 MB
unzip (filename, exdir = datadir)       # unzip creates and populates the data structure 
unlink(filename)                        # cleanup after
dateDownloaded<-date() %>% print()      # save and print file datestamp to enable back tracking
#> [1] "Sat Mar 14 16:16:18 2015"

## inspect the directory structure created and obtain the dataset directory name
list.dirs(datadir, full.names=TRUE,recursive=TRUE)
#> [1] "./data"                                        "./data/UCI HAR Dataset"                       
#> [3] "./data/UCI HAR Dataset/test"                   "./data/UCI HAR Dataset/test/Inertial Signals" 
#> [5] "./data/UCI HAR Dataset/train"                  "./data/UCI HAR Dataset/train/Inertial Signals"
datasetdir<-list.dirs(datadir,recursive=F)

## inspect the dataset directory and obtain the dataset file names
list.files(datasetdir,recursive=FALSE,include.dirs=FALSE)
#> [1] "activity_labels.txt" "features.txt"        "features_info.txt"   "README.txt"         
#> [5] "test"                "train"           

## extract activity filename and read into dataframe
filename<-list.files(datasetdir)[[1]]
filepath<-paste(datasetdir,filename,sep="/")
df.activity<-data.frame()
df.activity<-read.csv(filepath,header=FALSE,sep=" ",stringsAsFactors=TRUE)
## extract column headers from filename
colnames(df.activity)<-c("Index",strsplit(filename,"_")[[1]][1])

## repeat for the features filename
filename<-list.files(datasetdir)[[2]]
filepath<-paste(datasetdir,filename,sep="/")
df.features<-data.frame()
df.features<-read.csv(filepath,header=FALSE,sep=" ",stringsAsFactors=FALSE)
colnames(df.features)<-c("Index",strsplit(filename,"\\.")[[1]][1])

## run sanity check to insure the features names are unique
## this step is needed since the features entries will become column names
## and unique names are required in a tidy data set
## the names will also capture all the shorthand information the authors included
if (length(df.features[,2])!=length(unique(df.features[,2]))){
        # make it unique by combining index and name
        df.features[,2]<-paste(df.features[,1],df.features[,2],sep="-")
        print("Attention: Applying unique features name by combining features index and entry.")
}
#>[1] "Attention: Applying unique features name by combining features index and entry."

##
## inspect the test dataset directory and obtain the dataset file names
##
datasetdir<-list.dirs(datadir)[3]
#> [1] "./data/UCI HAR Dataset/test"
## Explore the filenames in test directory
list.files(datasetdir)
#> [1] "Inertial Signals" "subject_test.txt" "X_test.txt"       "y_test.txt"     
## extract subject_test filename into df.subject_test dataframe
filename<-list.files(datasetdir)[[2]]
filepath<-paste(datasetdir,filename,sep="/")
df.subject_test<-data.frame()
df.subject_test<-read.csv(filepath,header=FALSE,sep=" ",stringsAsFactors=TRUE)
colnames(df.subject_test)<-strsplit(filename,"\\_")[[1]][1]

## extract X_test filename into df.X_test dataframe
filename<-list.files(datasetdir)[[3]]
filepath<-paste(datasetdir,filename,sep="/")
df.X_test<-data.frame()
df.X_test<-read.table(filepath,header=FALSE,stringsAsFactors=FALSE)
colnames(df.X_test)<-df.features[,2]

## extract y_test filename into df.y_test dataframe
filename<-list.files(datasetdir)[[4]]
filepath<-paste(datasetdir,filename,sep="/")
df.y_test<-data.frame()
df.y_test<-read.table(filepath,header=FALSE,stringsAsFactors=FALSE)
colnames(df.y_test)<-colnames(df.activity[2])

##
## inspect the train dataset directory and obtain the dataset file names
##
datasetdir<-list.dirs(datadir)[5]
#> [1] "./data/UCI HAR Dataset/train"
list.files(datasetdir)
#> [1] "Inertial Signals"  "subject_train.txt" "X_train.txt"       "y_train.txt"   

## extract subject_train filename into df.subject_train dataframe
filename<-list.files(datasetdir)[[2]]
filepath<-paste(datasetdir,filename,sep="/")
df.subject_train<-data.frame()
df.subject_train<-read.csv(filepath,header=FALSE,sep=" ",stringsAsFactors=FALSE)
colnames(df.subject_train)<-strsplit(filename,"\\_")[[1]][1]

## extract X_train filename into df.X_train dataframe
filename<-list.files(datasetdir)[[3]]
filepath<-paste(datasetdir,filename,sep="/")
df.X_train<-data.frame()
df.X_train<-read.table(filepath,header=FALSE,stringsAsFactors=FALSE)
colnames(df.X_train)<-df.features[,2]

## extract y_train filename into df.y_train dataframe
filename<-list.files(datasetdir)[[4]]
filepath<-paste(datasetdir,filename,sep="/")
df.y_train<-data.frame()
df.y_train<-read.table(filepath,header=FALSE,stringsAsFactors=FALSE)
colnames(df.y_train)<-colnames(df.activity[2])

## prior to combine the datasets, we need to retain their origin information
## build a factor variable group=c("test","train") with corresponding levels
group<-factor(c("test","train"),levels=c("test","train"))

## populate corresponding dataframes df.test with corresponding factor=group[1]
## name the column "group" 
df.test<-data.frame(rep(group[1],times=nrow(df.X_test)),stringsAsFactors=TRUE)
colnames(df.test)<-"group"

## populate corresponding dataframes df.train with corresponding factor=group[2] 
## name the column "group" 
df.train<-data.frame(rep(group[2],times=nrow(df.X_train)),stringsAsFactors=TRUE)
colnames(df.train)<-"group"

## assemble the test datasets using cbind
df.test<-cbind(df.test,df.subject_test)
df.test<-cbind(df.test,df.y_test)
df.test<-cbind(df.test,df.X_test)

## cleanup and remove the redundant data frames
rm(df.subject_test,df.X_test,df.y_test)

## assemble the train datasets using cbind
df.train<-cbind(df.train,df.subject_train)
df.train<-cbind(df.train,df.y_train)
df.train<-cbind(df.train,df.X_train)

## cleanup and remove the redundant data frames
rm(df.subject_train,df.X_train,df.y_train)

## now assemble the df.test and df.train parts by rbind into tidy df
df<-data.frame()
df<-rbind(df.test,df.train)

## cleanup and remove the redundant data frames
rm(df.test,df.train)

## now we will populate df with the activity data (this answers step 3 requirement)
df$activity<-df.activity$activity[df$activity]

## cleanup
##
rm(df.activity)

## to complete the tidy requirement we need to cast the subject variable as a factor 
df$subject<-as.factor(df$subject)

## save the tidy dataset df for later use and document its features
write.table(df,file=paste0(datadir,"/df.txt"))

## document we reached goal #1 (tidy data set df)
str(df)
#> 'data.frame':        10299 obs. of  564 variables:
#> $ group                                   : Factor w/ 2 levels "test","train": 1 1 1 1 1 1 1 1 1 1 ...
#> $ subject                                 : int  2 2 2 2 2 2 2 2 2 2 ...
#> $ activity                                : chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
#> $ 1-tBodyAcc-mean()-X                     : num  0.257 0.286 0.275 0.27 0.275 ...
#> $ 2-tBodyAcc-mean()-Y                     : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
#>  ...
#> $ 94-tBodyAccJerk-min()-Y                 : num  0.95 0.968 0.976 0.976 0.98 ...
#> $ 95-tBodyAccJerk-min()-Z                 : num  0.946 0.966 0.966 0.97 0.985 ...
#> $ 96-tBodyAccJerk-sma()                   : num  -0.931 -0.974 -0.982 -0.983 -0.987 ...
#> [list output truncated]


## Step-2 Only keep the variables (columns) that pertain to mean() and std() using grep

selected<-vector()
selected<-grep(querytext,df.features$features)
rm(df.features)         ## cleanup

## offset the selected vector for the 3 columns (group,subject,activity) we had cbound to df dataset
selected<-selected+3
## also include the subject and activity variables that are needed for step 5
## subset from df to get the required dataset and document its features
df.sel<-data.frame()
df.sel=select(df,subject,activity,selected)
## document we reached goal #2 (tidy data set df.sel)
str(df.sel)
#> 'data.frame':        10299 obs. of  68 variables:
#> $ subject                        : Factor w/ 30 levels "1","2","3","4",..: 2 2 2 2 2 2 2 2 2 2 ...
#> $ activity                       : Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 3 3 3 3 ...
#> $ 1-tBodyAcc-mean()-X            : num  0.257 0.286 0.275 0.27 0.275 ...
#> $ 2-tBodyAcc-mean()-Y            : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
#> ...
#> $ 530-fBodyBodyGyroMag-std()     : num  -0.797 -0.917 -0.974 -0.971 -0.97 ...
#> $ 542-fBodyBodyGyroJerkMag-mean(): num  -0.89 -0.952 -0.986 -0.986 -0.99 ...
#> $ 543-fBodyBodyGyroJerkMag-std() : num  -0.907 -0.938 -0.983 -0.986 -0.991 ...

## Step-3 Uses descriptive activity names to name the activities in the data set

## features_info.txt provides description to translate the short hand labels
## 
## "^t"<-"Time domain signal$"
## "^f"<-"FFT Frequency domain signal$"
## "Acc"<-"Acceleration "
## "Body"<-"Body "                      * note we will suppress multiple occurences
## "Gravity"<-"Gravity "
## "Gyro"<-"Gyroscopic "
## "Jerk"<-"Jerk "
## "mean()"<-"Mean value"        
## "Mag"<-"Magnitude "
## "std()"<-"Standard deviation"
##
## and the directional data suffixes will be translated as follows:
##
## "-X$"<-" X-axis"
## "-Y$"<-" Y-axis"
## "-Z$"<-" Z-axis"
##
firstElement<-function(x){x[1]}
secondElement<-function(x){x[2]}
zapduplicate<-function(x,...){
        ## to eliminate duplicates in a string
        x<-unlist(strsplit(x, split=" "))
        x<-paste(unique(x), collapse = ' ')
        x
}
translateElement<-function(x,...){
        ## let's build the dictionary dict to use in substitution
        from<-c("^t","^f","Acc","Body","Gravity","Gyro","Jerk","-mean\\(\\)","Mag","-std\\(\\)","\\-X$","\\-Y$","\\-Z$")
        to<-c("Time domain signal ","FFT Frequency domain signal ","Acceleration ","Body ","Gravity ",
              "Gyroscopic ","Jerk ","Mean value","Magnitude ","Standard deviation"," along X-axis"," along Y-axis",
              " along Z-axis")
        dict<-data.frame(from,to,stringsAsFactors=FALSE)
        for(i in 1:nrow(dict))
                x<-gsub(dict$from[i],dict$to[i],x,...)
        x
}
## first capture the column header in cv vector of type chr
## and remove the numeral indexes from all variables
##
cv<-vector()
cv<-colnames(df.sel)
cv<-strsplit(cv,"^(.*)[0-9]\\-")
cv<-sapply(cv,secondElement)
cv<-sapply(cv,translateElement)
cv<-as.list(cv)
cv<-tolower(cv)
##
## Eliminate duplicates
cv<-sapply(cv,zapduplicate)
##

## and add the column names for the subject and activity
cv<-as.vector(cv)
cv[1]<-colnames(df[2])
cv[2]<-colnames(df[3])
## verify the description is now in 'plain english' to complete step 3
cv
#> [1] "subject"                                                                           
#> [2] "activity"                                                                          
#> [3] "time domain signal body acceleration mean value along x-axis"                      
#> [4] "time domain signal body acceleration mean value along y-axis"                      
#> ...        
#> [67] "fft frequency domain signal body gyroscopic jerk magnitude mean value"             
#> [68] "fft frequency domain signal body gyroscopic jerk magnitude standard deviation"     ##
##
## Step 4 - Label appropriately the data set with descriptive variable names
##
colnames(df.sel)<-cv
##
## Step 5 - From the data set in step 4, create a second, independent, tidy data set
##          with the average of each variable for each activity and each subject
##
