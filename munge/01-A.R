# Example preprocessing script.
#importing the enrollment data
enroldata<- read.csv("./data/cyber-security-7_enrolments.csv") 
#Selecting the desired columns
A<-enroldata %>% select(learner_id, enrolled_at ,detected_country)

#importing the step activity data
totalcompletiondata<- read.csv("./data/cyber-security-7_step-activity.csv")
#Selecting the desired columns
B<-totalcompletiondata %>% select(learner_id, first_visited_at, last_completed_at)

#merging the data set
fulldata<-merge(A, B, by="learner_id", all = TRUE)
#cleaning the dataset
cleandata=na.omit(fulldata)
#converting the values who are null n a diferent way
cleandata[cleandata == ""] = NA
cleandata[cleandata == "--"] = NA
cleandata=na.omit(cleandata)

#changing the date format
cleandata <- mutate(cleandata, first_visited_at=lubridate::as_datetime(first_visited_at))
cleandata <- mutate(cleandata, last_completed_at=lubridate::as_datetime(last_completed_at))
cleandata <- mutate(cleandata, enrolled_at=lubridate::as_datetime(enrolled_at))
#calculating the time spent by a specific learner on a specific step
cleandata$time_taken<- (cleandata$last_completed_at - cleandata$first_visited_at)










#importing the data set of question response 
quesrespdata<- read.csv("./data/cyber-security-7_question-response.csv")
#transforming the data
C<-quesrespdata %>% select(learner_id,week_number,step_number, question_number ,correct)
#cleaning the data
C[C == ""] = NA
C<-na.omit(C)
#getting the data in order
C<-sqldf("select  * from C order by learner_id")
#transforming the data from character to numeric
C$correct[C$correct== "true"]<-1
C$correct[C$correct== "false"]<-0
#calculating the accuracy of a learner
D<-sqldf("select learner_id, week_number, question_number, avg(correct) accuracy from C group by question_number, learner_id, week_number order by learner_id")
#calculating accuracy in a particular question and in a particular week
E<-sqldf("select question_number,week_number, avg(accuracy) avgaccuracy from D group by question_number, week_number")
