#averaging the data for a learner using sql
cleandatawithmean<- sqldf("SELECT learner_id, enrolled_at, detected_country, avg(time_taken) Mean_Time_spent_on_step
      FROM cleandata  
      GROUP BY learner_id")
cleandatawithmean$month<- month(cleandatawithmean$enrolled_at)




#counting the enrollments in separate months
count_month<- cleandatawithmean %>%
  count(month)
#plotting the number of enrollments in a month
ggplot(data = count_month, mapping = aes(x=month))+
  geom_point(mapping = aes(y=n))+
  geom_line(mapping = aes(y=n))



#extracting countries data with number of learners in the country
count_country<- cleandatawithmean %>%
  count(detected_country)
C<-sqldf("select detected_country, n from count_country order by n desc")
ggplot(C,aes(x="", y=n, fill=detected_country))+
  geom_bar(stat="identity",width = 1,color="white")+
  coord_polar("y",start=0)



#calculating average time spent by learners in a month
TotalTimeSpentInAMonth<-sqldf("SELECT month, (Mean_Time_spent_on_step)/count(learner_id) avgtimespent
      FROM cleandatawithmean 
      GROUP BY month")
#plotting  the data of average time spent in a month
ggplot(data = TotalTimeSpentInAMonth, mapping = aes(x=month))+
  geom_point(mapping = aes(y=avgtimespent))+
  geom_line(mapping = aes(y=avgtimespent))


#calculating total time spent by a country with respect to total number of people in that country
(TotalTimeSpentByACountry<-sqldf("SELECT detected_country, count(learner_id) totalpeople, Mean_Time_spent_on_step as total_time_spent 
      FROM cleandatawithmean 
      GROUP BY detected_country
      order by Mean_Time_spent_on_step desc"))


ggplot(data = E,mapping = aes(fill=as.character(week_number),x= as.character(question_number), y=avgaccuracy))+
  geom_bar(position = "dodge",stat = "identity")