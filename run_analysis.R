
run <-function(){
    library(dplyr)
    
    #define train, test and Inertial Signals paths
    mypaths<-list(test="./test/",train="./train/")
    signalspath<-"Inertial Signals/"
    
    
    getActivityName <- function(activities, actnum){
      #returns the activity related to the number
      a<-filter(activities,V1==actnum)%>%select(V2)
      a$V2[1]
    }
    
    getcleanY <-function(){
      #read y file an subtitute acitivity numbers by actual string values accorging to activities file
      #returns a list with the Y file for train and Y file for test
      
      cleanY<-function(file_y,activities){
        y<-read.table(file_y)
        y<-y[,1]
        oy<-sapply(y,getActivityName,activities=activities)
        oy
      }
      
    
      file_y_train<-("./train/y_train.txt")
      file_y_test<-("./test/y_test.txt")
      
      activities<-read.table("activity_labels.txt",stringsAsFactors = FALSE)
      
      y<-list(test=cleanY(file_y_test,activities), train=cleanY(file_y_train,activities))
      
    }
    
    cleanX <-function(file_x,cleanYset,set){
      
      if (set=="TEST"){
        file_subject<-("./test/subject_test.txt")    
        file_x<-paste0(mypaths$test,file_x,"_test.txt")
        
      }else if (set=="TRAIN"){
        file_subject<-("./train/subject_train.txt") 
        file_x<-paste0(mypaths$train,file_x,"_train.txt")
        
      }else {
        break("Wrong SET")
      }
    
      x<-read.table(file_x,col.names = features)
      
      subject<-read.table(file_subject)
      subject<-subject[,1]
      
      x<-mutate(x,activity=cleanYset,subject=subject,set=set)
    
    }
    
    getFilesNames <- function (path=NULL){
      # returns all the files in the signalspath
      
      if (is.null(path)){
        path<-paste0(mypaths[1],signalspath)
      }
      
      myfiles<-list.files(path)
      myfiles<-grep(".txt$",myfiles,value = TRUE) 
      myfiles<-gsub("_test.txt","",myfiles)
      myfiles
    }
    
    mergeSignals<-function (x){
      # Get de merged X file and add the Inertial signals files in columns
      # Test rows before train rows 
      
      result<-x
      for (i in getFilesNames()){
        
        testsignal<-read.table(paste0(mypaths$test,signalspath,i,"_test.txt"),col.names = paste0(i,".meas.",1:128))
        trainsignal<-read.table(paste0(mypaths$train,signalspath,i,"_train.txt"),col.names = paste0(i,".meas.",1:128))
        
        #append testsginals with train signals  set
        signal<-rbind(testsignal,trainsignal)
        
        #append measurements as columns
        result<-cbind(result,signal)
      }
      result
    }
    
    
    #read features file
    features<-read.table("features.txt", stringsAsFactors = FALSE)
    features<-features[,2]
    
    #read and clean Y file
    y<-getcleanY()
    #append cleanned X file from TEST set wih X file from TRAIn set
    x<-rbind(cleanX(file_x = "x",cleanYset = y$test,set="TEST"),cleanX(file_x = "x",cleanYset = y$train,set="TRAIN"))
    # add the Inertial Signals measurements as columns
    
    x<-mergeSignals(x)
    
    #select columnswith mean or std values
    selectedvalues<-grep(pattern = ".mean.|.std.",names(x))
    
    #calculate the requested means group by activity and subject
    sm<-select(x,activity,subject,selectedvalues)%>%group_by(activity,subject)%>%summarise_each(funs(mean),c(-activity,-subject))
    sm<-tbl_df(sm)
    
    #write.table(sm,"summary",row.names = FALSE)
    sm
}

summary<-run()