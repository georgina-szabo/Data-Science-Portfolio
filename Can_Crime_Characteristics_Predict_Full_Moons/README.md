# Can Crime Characteristics Predict Full Moons?

## Introduction
Crime is a complex phenomenon which influences most aspects of everyday life (Canter & Youngs, 2016).
Victim based crimes encompass crime perpetrated against a person and include, but are not limited to, robbery, aggravated assault , homicide and rape (Daigle, 2017). 
According to Crime Pattern Theory, crime does not occur randomly but can be predicted and therefore can be modelled  (Brantingham & Brantingham, 1984). The Lunar Effect (also known as The Transylvania Effect) is a  theory used to explain patterns in human behaviour that occur when the moon is full (Stolzenberg et al., 2017).There is evidence within this field to support an association between the incidence of a  full moon and aggression, number of crimes and unintentional poisoning (Qazi et al., 2007). 

### Aims
The primary aim of this project is to build a machine learning model that can predict if it is a full moon based on the characteristics of reported crimes. 
The secondary aim of this paper is to find patterns in crime data using clustering  which could be used as a basis for further research into crime prevention strategies and models. 

## Data 
### Crime Data
The crime data was obtained from the Baltimore Police Department database on victim based crime (Baltimore Police Department, 2020)
The dataset consists of 321,414  records of  victim-based crimes that occurred between 1978 and 2019 in Baltimore, United States of America. 
The database consisted of 16 variables, of which 7 variables where selected for analysis- date, inside.outside, weapon, description, district, latitude and longitude. 
Day of the week that the crime was committed was added to the dataframe using the function weekdays on the date variable. 
Many entries were missing data in the crime database and were omitted from this investigation using the na.omit function, which resulted in a total of 60,137 crime records without missing data.  

### Full Moon Data
Full moon data was obtained from a .csv full moon calendar from Kaggle, which consisted of the dates of every full moon between 1900 and 2050 in the Northern Hemisphere, which consists of 1867 entries (Chemkaeva, 2020)
and a new variable  full_moon was created, which was set to TRUE for each row as each row was the date of a full moon. The crime data was then joined to the full moon data using the left_join function, with date used as the key to join the 2 datasets. 
The left join created a new dataframe consisting of all of the crime variables of interest and the variable full_moon, which was TRUE for crimes that occurred on the date of a full moon and blank for dates that were not full moons. 
replace_na function was used to replace all the  blanks in the full_moon variable with FALSE. 
The resulting dataframe has 60,137 rows, consisting of the 7 variables selected from the crime database and the full_moon variable. 

## Methods 

###Naive Bayes Classifier
R studio version 1.2.5019 was used to produce this project (RStudio Team, 2019). 
A Naïve Bayes Classifier (NBC) was implemented to predict full_moon based on the categorical predictors- day_of_week, Inside.Outside,  Weapon, District, Description. 
A chi squared test for independence was conducted on all pair combinations of predictors using chisq.test function on contingency tables of the variable pairs as NBC assumes class conditional independence of predictors (Cooper, 2020).
Testing and training data sets were created using a randomly generated subset of the data using the sample function with the parameter replace=FALSE.
The testing set was set to 20% of the data and the training set the other 80% of the data. 
The function set.seed was set to 8 for reproducibility of results.
Naive_bayes algorithm was used on training data subset to train the model to predict full_moon using predictors day_of_week, Inside.Outside,  Weapon, District and Description. 
The naive_bayes parameter laplace was set to 1 for prevent zero probabilities (Juan & Ney, 2002). 
The resulting NBC model was then used to predict full_moon on the testing dataset using the predict function with the parameter type=class.
Contingency tables to assess the classification results for the testing and data were then created to assess the model

### PAM Clustering 
The variables full_moon, Day_of_week, Inside.Outside, Weapon, District, Description, Latitude, and Longitude were selected for a clustering analysis. 
As the data contains both categorical and continuous variables Gower distance was used to calculate the distance between data points (Akay & Yüksel, 2018). 
The daisy function was used to calculate the Gower distances. 
However, the crime data set was too large to compute Gower distance for every observation so a random subset of the data containing 1000 observations was selected using the sample function using the parameter replace=FALSE. 
The daisy function was then used to compute a Gower distance matrix from data subset by specifying the parameter metric= “gower”. 
The Partitioning around Medoids (PAM) algorithm was the clustering algorithm chosen as it can use Gower distances to compute similarity (Shendre, 2020).
PAM is a clustering algorithm based on K-means which instead of using centroids uses medoids, which is a member of the cluster that represents the median of all the variables (Akay & Yüksel, 2018). 
The optimal number of clusters was determined by plotting k against silhouette width criterion (SWC) for the PAM algorithm. 
PAM algorithm was then implemented on the Gower distance matrix with the parameter k=2 as this was the optimal number of clusters from inspecting the SWC plot. 
The t-SNE algorithm was used for dimensionality reduction in order to visualise the clusters in ggplot (Shendre, 2020). 
This was achieved by creating a t-SNE object of the gower distance matrix with the resulting object visualised using the ggplot function with data points coloured by cluster.  
The fviz_cluster function was also used to visualise the resulting clusters. 
  

## Results and Discussion 

### NBC
Chi squared tests of independence were carried out to asses for correlation between predictors for the NBC model to predict full moons based on crime predictors. 
Chi squared test results for all pair combinations of predictors only supported that day and district has no correlation. 
All other combinations supported a correlation between all other pairs of predictors.
Therefore, the data violates the Naïve Bayes Classifier assumption  of independence of predictors.
However, NBC has been shown to be an accurate classifier even when the independence assumption is violated  by correlated predictors (Jarecki et al., 2018). 
The A priori probability of a full moon occurring is 3.53%, with a probability of it not occurring of 96.47%. 
The accuracy of the NBC model on the training dataset was 96.47%, which is identical to the probability of a full moon not occurring.
On the testing data the model was 96.59% accurate.  
There were no true positives in the training or testing datasets as the model did not accurately predict any full moons and therefore the model has a sensitivity of 0. 
The model also has a specificity of 1 as there were no false negatives (Trevethan, 2017).  All the classifications by the model assigned full_moon=FALSE. 
As the model has a  sensitivity of zero  means the model is not good at classifying if it is a full moon.
The primary aim of this project is to build a machine learning model that can predict if it is a full moon based on the characteristics of reported crimes. 
A model to predict if it is a full moon based on crime predictors was produced however it is not a useful model as although it had an accuracy of 96% it has a specificity of 0. 
The model specificity of 1 is most likely reflective of the low probability of a full moon occurring as all classifications by the model were full_moon=FALSE. 

### PAM Clustering
Silhouette width (SW) was plotted against the number of clusters using the PAM algorithm as seen in the figure below. 

[SWC for PAM clustering solution](https://github.com/georgina-szabo/Data-Science-Portfolio/Can_Crime_Characteristics_Predict_Full_Moons/SWC crime.png)

The highest SW value was achieved when the number of clusters was 2.
As higher Silhouette width values produce better clustering solutions 2 clusters were chosen for this model (Lengyel & Botta‐Dukát, 2019)
SW values can also be used to evaluate the quality clustering solutions. 
SW values close to 1 suggest correct assignment of points to a cluster and SW values close to -1 suggest assignment to the wrong cluster (Batool, 2020).
The average SW for the PAM model was 0.204, with an average SW for cluster 1 of 0.234 and 0.171 for cluster 2.
These are low SW values that are not close to 1  which suggests that this PAM model is not a good fit for the data.


The figure below shows a visualisation of the 2-cluster solution  produced from the PAM algorithm. There are 2 clusters visible, however they are not tight clusters and some overlap is present across clusters.
[PAM clustering image](https://github.com/georgina-szabo/Data-Science-Portfolio/Can_Crime_Characteristics_Predict_Full_Moons/PAM clustering.png)


An alternate visualisation of the clustering solution is shown below, which was produced by fviz_plot. In this visualisation considerable overlap is shown between clusters 1 and 2, the boundary of cluster 2 nearly completely overlaps cluster 1. 
The data points are also not evenly spread through the clusters. 

[PAM clustering image using fviz_plot](https://github.com/georgina-szabo/Data-Science-Portfolio/Can_Crime_Characteristics_Predict_Full_Moons/PAM clustering fviz.png)

The secondary aim of this investigation included finding patterns in the crime data using clustering. A 2-cluster model was developed from the crime data however, the model was not a good fit for the data as it had very low SW values and considerable overlap in the visualisations.


## Conclusion
The primary aim of this project was to build a machine learning model that can predict if it is a full moon based on the characteristics of reported crimes.
An NBC model to predict full moons based on reported crimes was implemented.
However, the model is not an appropriate classifier for predicting full moons  and does not meet the aim as it has a sensitivity of zero. 
 The secondary aim of this project was to find patterns in crime data using clustering which could be used as a basis for further research into crime prevention strategies and models.
 A clustering solution  was implemented using a PAM clustering model consisting of 2 clusters  which did find crime data patterns. 
 However, the model was not a good fit for the data as it had low average Silhouette width values. 

 Limitations of this investigation include that the dataset only consisted of reported crimes when it is estimated that 52% of all violent crime goes unreported (Langton et al., 2012).
 Full moon state was determined by the date of the full moon and did not take into account the time in this report. 
 Therefore, if a crime took place during the day when the moon was not visible it was still classified as a full moon.
 A further analysis involving the time or even simply the inclusion of a variable for if it is day or night is a potential future direction of this research. 
 This investigation also only looked at a subset of crime, victim-based crime. 
 Further analyses of different areas of crime, such as property-based crime or financial crime could be investigated in the future.
 Analysis of crime data from other locations, such as Australia could also provide a more local analysis and provide more relevant insights. 
 Another potential direction is using different clustering algorithm which may provide more insightful and meaningful results.   


## References 

Akay, Ö., & Yüksel, G. (2018). Clustering the mixed panel dataset using Gower’s distance and k-prototypes algorithms. Communications in Statistics - Simulation and Computation, 47(10), 3031–3041. https://doi.org/10.1080/03610918.2017.1367806
Baltimore Police Department. (2020). BPD Part 1 Victim Based Crime Data. https://data.baltimorecity.gov/Public-Safety/BPD-Part-1-Victim-Based-Crime-Data/wsfq-mvij/data
Batool, F. (2020). Initialization methods for optimum average silhouette width clustering. ArXiv:1910.08644 [Cs, Stat]. http://arxiv.org/abs/1910.08644
Brantingham, P. J., & Brantingham, P. L. (1984). Patterns in crime. Macmillan ; Collier Macmillan; /z-wcorg/.
Canter, D., & Youngs, D. (2016). Crime and society. Contemporary Social Science, 11(4), 283–288. https://doi.org/10.1080/21582041.2016.1259495
Chemkaeva, D. (2020, March 28). Full Moon Calendar 1900-2050. Kaggle. https://kaggle.com/lsind18/full-moon-calendar-1900-2050
Cooper, M. (2020, November 3). Week 2; Collaborate Session 1: Naive Bayes [Tutorial Notes]. https://github.com/MarthaCooper/MA5810/blob/main/2_Naive_Bayes.pdf
Daigle, L. (2017). Victimology: The Essentials (second edition). Sage.
Jarecki, J. B., Meder, B., & Nelson, J. D. (2018). Naïve and Robust: Class-Conditional Independence in Human Classification Learning. Cognitive Science, 42(1), 4–42. https://doi.org/10.1111/cogs.12496
Juan, A., & Ney, H. (2002). Reversing and Smoothing the Multinomial Naive Bayes Text Classifer. 200–212.
Langton, L., Berzofsky, M., Krebs, C., & Smiley-McDonald, H. (2012). Victimizations Not Reported to the Police, 2006-2010 (p. 18). U.S. Department of Justice.
Lengyel, A., & Botta‐Dukát, Z. (2019). Silhouette width using generalized mean—A flexible method for assessing clustering efficiency. Ecology and Evolution, 9(23), 13231–13243. https://doi.org/10.1002/ece3.5774
Qazi, H. A. R., Philip, J., Manikandan, R., & Cornford, P. A. (2007). ‘The Transylvania Effect’ – Does the Lunar Cycle Affect Emergency Urological Admissions? Current Urology, 1(2), 100–102. https://doi.org/10.1159/000106544
RStudio Team. (2019). RStudio: Integrated Development for R. (1.2.5019) [Computer software]. RStudio, Inc.
Shendre, S. (2020, May 11). Clustering datasets having both numerical and categorical variables. Towards Data Science. https://towardsdatascience.com/clustering-datasets-having-both-numerical-and-categorical-variables-ed91cdca0677
Stolzenberg, L., D’Alessio, S. J., & Flexon, J. L. (2017). A Hunter’s Moon: The Effect of Moon Illumination on Outdoor Crime. American Journal of Criminal Justice, 42(1), 188–197. https://doi.org/10.1007/s12103-016-9351-9
Trevethan, R. (2017). Sensitivity, Specificity, and Predictive Values: Foundations, Pliabilities, and Pitfalls in Research and Practice. Frontiers in Public Health, 5. https://doi.org/10.3389/fpubh.2017.00307

R code for the project is available here

Link to code 
