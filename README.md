# Getting_Cleaning_assignment

#Procedure:
1. Read the features data.set and convert to a vector 
2. get a list that contain train and set Y files using getCleanY function
3. use getcleanX function on train and test sets passing the appropiate Y set
4. row bind both x sets
5. use mergeSignals passing the x merged set to add all the inertial signals files as columns
6. select names that contain the key words "mean" or "std"
7. summarise all selected variables using function mean
8. save the new data set.

#Functions:

##getActivityName (activities, actnum)

This functions takes the activities data.set wich relates an integer and the name of the activity and returns the name of the activity related to the input integer(actnum)
This function is used to replace activity codes by activity names in the y file

##getcleanY

This function reads test and train 'y' file an subtitute acitivity numbers by actual string values accorging to activities file. 
Returns a list with the Y file for train and Y file for test

##getFilesNames

This function read all the file names in the Inertial Signals path (test or train)

Removes the file extension an _train or _test from the name to get the Inertial Signal variable names


##getcleanX (file_x,cleanYset,set)

file_x is the root name of the x file. ('x')

cleanYset is a processed Y file obtained by getclenY function

set is "TRAIN" or "SET"

This function perform the following operations:

1. add a column to x set  called set indicating the origin of the set (TRAIN or SET)
2. add the cleanYset to x set as a column called activity.
3. reads the train or test file according to set variable and add it as a column called subject to x set

##mergeSignals (x)

Get de merged X file and add the Inertial signals files in columns

1. read all the inertial signal file names from test using getFilNames
2. for each file name: 
  
  a. read the test file as data.frame using read.table renaming columns as the original signal name plus meas.1 to meas.128 
  
  b.  Proceed as behore with the train file 
  
  c. row bind test and train file 

Add all the Inertial Signals files as new columns to the x set. The final dataset contains 1029 rows and 1152 columns (9 signals with 128 measurements each)
