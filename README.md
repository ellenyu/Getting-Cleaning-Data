# Getting-Cleaning-Data Assignment Readme.md

This file documents the run_analysis.R script, referred to as 'script' in this document.

The script was developed and run on the following R version:

R-version    3.1.3 (2015-03-09) -- "Smooth Sidewalk"
Copyright (C) 2015 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)

The 'script' is fully annotated to clearly state the various steps developed to meet the goals.
Typical outputs are also included to validate key milestones or goals met for documentation.
        
Notation:       ## indicates a script comment.
                #> is a typical console output recorded during script execution

This document describes:
1.Purpose
2.Inputs and Outputs
3.Packages and Methods used
4.Additional documents (Codebook, Addendum, References)

1.Purpose:
==========  
The script is actually a 5-step process of getting and cleaning data pertinent to a Human Activity
Recognition Using Smartphones and is based on a dataset authored by Jorge L. Reyes-Ortiz, Davide
Anguita, Alessandro Ghio, Luca Oneto. (see Ref.0, Ref.1, Ref.2 and actual dataset readme.txt).
To practice the activity of data gathering, cleaning and tidying, the following 5 steps were set as goals for the script.
The source data was provided in the form of an SSLurl (Ref.3) pointing to the zip compressed data. 

1. Merge the training and the tests sets to create unified data sets (tidy).
2. Extract only the measurements on the mean() and std() for each measurement.
   Note: This implies we are not attempting to dig down into the raw data layer.
3. Use descriptive activity names to name the activities in the data set.
4. Label appropriately the data set with descriptive variable names.
5. From the data set in step 4, create a second, independent, tidy data set
   with the average of each variable for each activity and each subject.

2.Input and Output parameters:
==============================
Given as input are:

1. A user-provided working directory, which can be easily modified (within RStudio).
   This script sets up a fresh directory, using:
   setwd("R:/Getting-Cleaning-Data") R command.
2. A data directory created below the working directory is also used and can be modified thru the
   parameter: 
   datadir<-"./data".
3. The SSL URL is assigned to the parameter:
   SSLurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

As output, this script writes 2 files and produces some console display output:

1. The complete aggregated datafile df.txt is saved for unspecified further processing using the
   write.table() command and saves a copy of the full tidy dataframe df. This file is listed as
   66,028 KB size and corresponds to 10299 observations of 564 variables.
2. A tidy dataset df.mean representing only the mean of all variables processed.Specifically this
   represents means and standard deviations of the data grouped by subject and activities they
   performed. Thi tiny dataset is output as dfmean.txt, using the write.table() command and
   specifying option row.names=FALSE, for evaluation purpose and further processing and analysis.
3. The script also produces console outputs to indicate progress steps towards final goal and
   to validate the data aggregated.

3.Packages and Methods Used:
============================
To execute the script, the following packages are required:

1. RCurl, to handle Certified SSL URL support. This is commonly provided thru
   install.packages("RCurl") 
   library(RCurl)
2. plyr, to aggregate (in step 5) the df.mean dataset.   
   install.packages("plyr")  
   library(plyr)
3. dplyr, to select (in step 4) from df into df.sel dataframe
   install.packages("dplyr")  
   library(dplyr)
   
The methods derived in this script are common R practice. 

Throughout the script, attention to variable useage and common tidy data practices were 
implemented. All data in the data frames are properly labeled, and the data aggregated to contain
3 categorical (factors) variables representing subject, activity and a group category.
The group category is introduced to account for the origin of the data, which was originally split
between test and train groups by the authors.

The actual data aggregated by this script is already processed data documented by the authors. 
The raw data, although available in the dataset and exposed when unzipping below the UCI HAR Dataset directories, corresponds to a data layer that is NOT addressed by this script. 
It can be exposed by reding the corresponding Inertial Signals directory unzipped.
However, the authors have provided full description of the data reduction method they applied and documented it in the features.txt and features-info.txt files. We are dealing in this script with the time and frequency processed data as well as the accelerations (linear and gyroscopic) and adjustment made relative to gravity.

The data is immediately observed with similitudes as it was split by the authors into two groups
(test and train) representing 70/30 cut of the total population and populating test and train directories under the UCI HAR Dataset. There were 30 subjects 
participating in 6 activities monitored.

The script 1st step consists in data retrieval and unziping the data structure from
the provided SSL URL into a data subdirectory.
Then the retrieval is systematically driving to read:
a) the df.activity dataframe is built when reading the activity_labels.txt.
b) the features.txt file which names the 561 data variables corresponding to numeric
data collected is stored into the df.features dataframe.

A sanity check is performed at this stage to insure all features are unique: this is required
since they will become variable names in out tidy set and must therefore be unique.
In case the variables are not unique names, we device a simple strategy to combine index and name
and producing a unique name, by comparing the length of features names and the corresponding
length of unique names. The script also indicates this occurence with a console display:

 [1] "Attention: Applying unique features name by combining features index and entry."

Further observation reveal that the frequency decomposition data had redundant names, which is 
in conflict with the definition of tidy datasets. 

At that point, the process of populating the data collected from the similar data structures
(train and test subdirectories).There are 3 different files that are read:
a) the subject_test.txt file that indicates for each observation which subject was tested
b) the X_test.txt which contains the 561 variables
c) the y_test.txt contains the activity index performed during each observation
The script also appropriatelty renames the x_test and y_test columns with the features and 
activity names resolved from df.features and df.activity.

We then have 2 groups of similar data frames (df.subject_test, df.X_test and df_y.test) for the
test group and  the corresponding (df.subject_train, df.X_train and df.y_train) for the train
group. The script adds another factor variable to these to retain the origin of the data before
merging. We add the factor variable group, populated according to either test or train group
the correspondind df.test and df.train dataframes.

The process of aggregation consists then in aggregating column wise into df.test dataframe:
a) df.test              factor 1 var()
b) df.subject_test      factor 1 var()
c) df.y_test            factor 1 var()
d) df.x_test            numeric 561 var()
and respectively aggregating into df.train dataframe:
a) df.train             factor 1 var()
b) df.suject_train      factor 1 var()
c) df.y_train           factor 1 var()
d) df.x_train           numeric 561 var()

We finsih the aggregation by popultaing the activity variable with the activity name, resolved 
by df.activity and appropriately casting the the subject variable. so the 3 factors
Each df.test and df.train contain 564 va and are then row bound into the df tidy dataset.
we anotate the activity variable in df dataframe using the df.activity information. The script
also performs cleanup and eliminates all redundant dataframes. At this stage df is the tidy set,
and Step 1 goal is reached with 10299 obs of 564 variables placed in the df dataframe.
Although not required, the script saves the tidy dataset in df.txt in the data subdirectory, for
further inspection and analysis.

Step 2 then selects only mean and standard deviation variables, and retains the factors to 
assemble a tidy dataset df.sel. A query is performed on the numeric data colums and is
using a RegEx string querytext<-"[Mm][Ee][Aa][Nn]\\(\\)|[Ss][Tt][Dd]\\(\\)
to extract mean() and std().It returns 66 matching variables.

The script combines the 2 factor variables (subject and activity) and the 66 query results numeric
variables into a tidy set df.sel containing 10299 observations of 68 variables. 

Three functions help in the processing of text information and lists:

a) secondElement, to extract the 2nd element from a list via simple subsetting
b) zapduplicate, use an unlist, unique, paste approach to eliminate redundant patterns. 
c) translateElement is implementing a simple RegEx translation to replace shorthand scientific
labeling of variables with common english full titling. 
The description of the variables was used in the script to establish a ReGex dictionary in a
dataframe df,dict and implement the translation required in step 3 as detailed below:

      from<-to
      "^t"<-"Time domain signal"
      "^f"<-"FFT Frequency domain signal"
      "Acc"<-"Acceleration "
      "Body"<-"Body "             * note we will suppress multiple occurences with zapduplicate
      "Gravity"<-"Gravity "
      "Gyro"<-"Gyroscopic "
      "Jerk"<-"Jerk "
      "mean()"<-"Mean value"        
      "Mag"<-"Magnitude "
      "std()"<-"Standard deviation"
      "-X$"<-" X-axis"
      "-Y$"<-" Y-axis"
      "-Z$"<-" Z-axis"

The script performs in sequence on the proper cv subset extracted from the df.sel columns.:
a) strsplits of the numeric index info, including dash using "^(.*)[0-9]\\-" RegEx
b) selects the 2nd element via sapply secondElement
c) translates it via sapply and translateElement
d) lowercaps 
e) zapduplicates by sapply zapduplicate

All numeric column variables are processed and the factor variables are excluded from this
transformation by subsetting.

Step 4 is a very short process as it only copies back the translated info into the column names of
the tidy dataset df.sel and is complete when the 10299 observations are described by 68 variables:
the two factors (subject and activity) and the 66 plain english described numeric variables
representing means and sd data variables only.

In step 5, ddply is used to aggregate the df.sel data and obtain mean values per subject and
activities. This is performed column wise on the selected groups and the corresponding dataset
df.mean is obtained and written to the dfmean.txt file using the required write.table() with
the specified option (row.names=FALSE). 

The 223KB file contains 180 observations (6 activities performed X by each of the 30 subjects) for
the corresponding 68 variables (2 factors: subject and activity) and 66 numeric variables 
corresponding to the desired mean values. The corresponding labeling update of the dataset
variables was also implemented to keep the description of the tidy dataset accurate.

This completes the description of the script. The reader is referred to the codebook.txt for full
description of all variables used throughout the script, and full documentation of the datasets
obtained.

References:
===========

0.      Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
        Smartlab - Non Linear Complex Systems Laboratory
        DITEN - Università degli Studi di Genova.
        Via Opera Pia 11A, I-16145, Genoa, Italy.
        activityrecognition@smartlab.ws
        www.smartlab.ws

1.      http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/
2.      http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
3.      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
4.      Codebook.md file contains full description of the variables used and data documentation

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
