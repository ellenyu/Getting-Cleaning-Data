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
2. plyr, to aggregate (in step-5) the df.mean dataset.   
   install.packages("plyr") # needed for data frame manipulations
   library(plyr)
   
The methods derived in this script are common R practices. 3 helper functions were coded to help
in the processing of text information and lists: secondElement, zapduplicate and translateElement.

The translateElement is implementing a simple RegEx translation to replace shorthand scientific
labeling of variables with common english full titling.

Throughout the script, attention to variable useage and common tidy data practices were 
implemented. All data in the data frames are properly labeled, and the data aggregated to contain
3 categorical (factors) variables representing subject, activity and a group category.
The group category is introduced to account for the origin of the data, which was originally split
between test and train groups by the authors.

The actual data aggregated by this script is already processed data documented by the authors and 
the raw data. Although available in the dataset and exposed when unzipping, the raw data layer is
not addressed by this script. However, the authors have provided full description of the data reduction method they applied and documented it in the features.txt and features-info.txt files.

The description of the variables was used in the script to establish the ReGex dictionary and 
implement the translation required in step 4.

Because the process of aggregation focused on regrouping similar data structures, similitude
between the train and test data process is evident in the script.

The process of aggregation includes first the retrieval of the data variable names, obtained from
the features datafile. Activities and subject data (factors) are also retrieved. The largest
data chunk is obtained from the instrumented smartphone output, and represents real time and FFT
spectral info documented in details in the features_info.txt file.They account for 561 numeric
variables.

The reader is referred to the codebook.md for full description of all variables used throughout the
script, and full documentation of the datasets obtained.

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
