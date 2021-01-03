library(dplyr)
library(tidyr)
library(forcats)
library(naivebayes)
library(ggplot2)
library(gridExtra)
library(arules)
library(arulesViz)
library(cluster)
library(factoextra)
library(Rtsne)
library(MASS)
library(bestNormalize)
set.seed(8)
data<-read.csv("crime_data.csv", header = TRUE, na.strings = c("NA", "") ) #read in crime data

data=data%>%
  mutate(Date= as.Date(CrimeDate, "%m/%d/%y")) #formatting date 

data=data%>%
  mutate(Inside.Outside=fct_collapse(Inside.Outside, Inside=c("Inside", "I"), Outside=c("Outside", "O"))) #collapse to only 2 catergories

data=data%>%
  mutate(Day_of_week= as.factor(weekdays(Date))) #make weekdays variable

summary(data)

#select variables
dat<-data%>%
  dplyr::select(Date, Day_of_week,CrimeTime, Inside.Outside, Weapon, CrimeCode, Description, District, Longitude, Latitude, Premise)

dat<-na.omit(dat) #get rid of NAs
summary(dat)


# read in full moon data

moon<-read.csv("full_moon.csv", header = TRUE)
moon=moon%>%
  mutate(Date=as.Date(Date, format = "%d %B %Y")) #formatting date 

moon=moon%>%
  mutate(full_moon=(!is.na(Day))) #making is it full moon variable

full_moons=moon%>%
  dplyr::select(Date, full_moon)

df<-left_join(dat,full_moons, by="Date") #joining crime data to fullmoon data by date 

df=df%>%
  replace_na(list(full_moon=FALSE)) #replacing blanks present for when not a full moon

df=df%>%
  mutate(full_moon=as.factor(full_moon))

#refactor to remove unused levels 

df$Description<-droplevels(df$Description) #dropping unused levels in description
summary(df$Description)

#### NBC ####

#select variables of interest
NBC_data=df %>%
  dplyr::select(full_moon, Day_of_week, Inside.Outside, Weapon, District, Description) 

no_obs<-dim(NBC_data)[1] #numbers of obs

#chi squared for independence of discrete data 

day_inside<- table(NBC_data$Day_of_week, NBC_data$Inside.Outside)

chisq.test(day_inside)   #not independent 

day_weapon<- table(NBC_data$Day_of_week, NBC_data$Weapon)
chisq.test(day_weapon) #not indep

day_discrict<- table(NBC_data$Day_of_week, NBC_data$District)
chisq.test(day_discrict)  #indep 

day_desciption<- table(NBC_data$Day_of_week, NBC_data$Description)
day_desciption
chisq.test(day_desciption)  #not indep

inside_weapon<- table(NBC_data$Inside.Outside, NBC_data$Weapon)
chisq.test(inside_weapon) #not indep 

inside_district<- table(NBC_data$Inside.Outside, NBC_data$District)
chisq.test(inside_district)  #not indep

inside_description<- table(NBC_data$Inside.Outside, NBC_data$Description)
chisq.test(inside_description) #not indep 

weapon_district<- table(NBC_data$Weapon, NBC_data$District)
chisq.test(weapon_district) #not indep 

weapon_description<- table(NBC_data$Weapon, NBC_data$Description)
chisq.test(weapon_description) #not indep 

district_description<- table(NBC_data$District, NBC_data$Description)
chisq.test(district_description) #not indep 

test_index<-sample(no_obs,size=as.integer(no_obs*0.2),replace = FALSE) #creating test index using random 20%

training_index<- -test_index #creating training index using remaining 80%

NaiveBayesCrime<-naive_bayes(full_moon~., data=NBC_data[training_index,], laplace = 1) #la place smoothing to prevent 0 probabilities 

NaiveBayesCrime #show model

Pred_class_train<-predict(NaiveBayesCrime, newdata = NBC_data[training_index,], type="class") #making predictions on training data using model
(cont_tab_train<-table(Pred_class_train, NBC_data$full_moon[training_index])) #cont table
((training_accuracy<-sum(diag(cont_tab_train))/sum(cont_tab_train))) #accuracy


Pred_class<-predict(NaiveBayesCrime, newdata = NBC_data[test_index,], type="class") #making preds on test data
(cont_tab_test<-table(Pred_class,NBC_data$full_moon[test_index])) #cont table test data

((testing_accuracy<-sum(diag(cont_tab_test))/sum(cont_tab_test))) #accuracy test data

#### Clustering ####
#select variables
gower_data=df%>%
  dplyr::select(full_moon, Day_of_week, Inside.Outside, Weapon, District, Description, Latitude, Longitude)

no_obs<-dim(gower_data)[1] #numbers of obs

gower_sample<-sample(no_obs,size=1000, replace = FALSE) #full dataset too big for daisy function so random sample

gower_data=gower_data[gower_sample,] 

#checking normality latitude

ggplot(gower_data, aes(x=Latitude)) + geom_density()
shapiro.test(gower_data$Latitude) #not normal


(normalize_lat<-bestNormalize(gower_data$Latitude)) #check which transformation is best for latitude


lat_norm<-orderNorm(gower_data[,7]) # orderNorm was best transformation accprding bestNormalize 
## Warning in orderNorm(gower_data[, 7]): Ties in data, Normal distribution not guaranteed
lat_transform<-lat_norm$x.t #saving transformed data

shapiro.test(lat_transform) # testing normality transformed data- normal

gower_data=gower_data%>%
  mutate(Latitude=lat_norm$x.t) #saving transformed data to dataframe


#checking if longitude is normally distributed

ggplot(gower_data, aes(x=Longitude)) + geom_density()
shapiro.test(gower_data$Longitude)  #not normal

(normalize_long<-bestNormalize(gower_data$Longitude)) #check which transformation is best

long_norm<-orderNorm(gower_data[,8]) # orderNorm was best transformation according bestNormalize 
## Warning in orderNorm(gower_data[, 8]): Ties in data, Normal distribution not guaranteed
long_transform<-long_norm$x.t #saving transformed values

shapiro.test(long_transform) # transformed values are normal

gower_data=gower_data%>%
  mutate(Longitude=long_norm$x.t) #adding transformed longitude values to dataframe 

gower_dat<-daisy(gower_data, metric = "gower") #perform gower distance on data now that its normal 

#Plot SWC against number of clusters for PAM algo
silhouette <- c()
silhouette = c(silhouette, NA)
for(i in 2:10){
  pam_clusters = pam(as.matrix(gower_dat),
                     diss = TRUE,
                     k = i)
  silhouette = c(silhouette ,pam_clusters$silinfo$avg.width)
}
plot(1:10, silhouette,
     xlab = "Clusters",
     ylab = "Silhouette Width")
lines(1:10, silhouette)
#k=2 is best from plot  

pam_crime=pam(gower_dat, k=2) #using pam clustering with k=2 from plot

pam_crime$clusinfo #avg cluster width
pam_crime$silinfo #avg width

pam_crime$data=gower_dat

#visualise clusters using fviz_cluster
fviz_cluster(pam_crime,  geom = "point", geom_point(aes(color=pam_crime$clustering),
                                                    shape=pam_crime$clustering))
#visualise clusters using Rtsne
tsne_object <- Rtsne(gower_dat, is_distance = TRUE)

tsne_df <- tsne_object$Y %>%
  data.frame() %>%
  setNames(c("X", "Y")) %>%
  mutate(cluster = factor(pam_crime$clustering))
ggplot(aes(x = X, y = Y), data = tsne_df) +
  geom_point(aes(color = cluster))
