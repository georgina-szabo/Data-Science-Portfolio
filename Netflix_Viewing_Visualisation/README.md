# Comparing Netflix Viewing Habits

## Introduction
We all spend too much time watching Netflix so I thought it would be interesting to break down the stats of what we've been watching. Particularly as 2020 did involve a lot of staying home and watching Netflix!  This project looks at the Netflix viewing habits of 2 different Netflix users Geo and Em. This project used Python to analyse the data and visualisations were performed  using **matplotlib**. 


## Data
You can put in a data download request to get your personal Netflix data directly from Netflix. [You can find the link to download your own data here](https://www.netflix.com/account/getmyinfo) 

Putting a data download request gives you access to a whole wealth of .csv files about your Netflix account from  your search history, ratings history and complete Netflix viewing history, which is the focus of this project.  

The file ViewingActivity.csv contains a complete history of everything viewed on Netflix   

Consisted of 12841 rows - 

Kept the rows Profile Name, Start Time, Duration, Title

Start Time was not in Aus timezone-Converted start time to datetime and  used  tz_convert to make it in local time


Converted duration to timedelta 

Made Day of week column using dt.weekday.  Ordered Days using pd.Catergorical
Created hour viewed e.g. 11AM using dt.hour and ordered 

Title contained the show name, season and episode title in the format Show:Season:Episode

Broke into seperate components
Filtered out previews by getting rid of anything with duration<5 mins

Filtered to just 2020 data 

Made df for Geo and df for Emery from 2020 df


## Now for the results

Total time Geo has watched Netflix:  23 days 10:25:23
Total time Em has watched Netflix:  89 days 15:29:24

Since what year? 


Total time Em has watched Netflix in 2020:  24 days 00:47:56
Total time Geo has watched Netflix in 2020:  10 days 14:55:52

2020 


Thought it would be interesting to see what each user's top 10 most watched shows were 

Table of top 10 shows



Next to see what day most often watched

**Graphs of day watched** 




Then what time of day most often watched 
**Graphs of time of day watched** 







