---
title: 'Reproducible Research: Peer Assessment 1'
output:
  html_document:
    fig_caption: yes
    keep_md: yes
  pdf_document: default
---
#### Submitted by Lisa Murray
#### for Reproducible Research Coursera class with Johns Hopkins University

## Overview
Personal wearable activity monitoring devices are extremely popular. The summary data are used to track daily activity for the end user. This project delves further into the raw data stored by these devices to attempt to find more granular activity patterns that can be interpreted.

The data for this project were collected from an anonymous individual over the months of October and November 2012. The number of steps were collect at 5 minute intervals throughout the day.

This document outlines the steps that were taken to load and analyze the data to answer the specific questions below.

## Loading and preprocessing the data

Before the data is read into the working environment, the following packages are loaded into the working directory:


```r
library(ggplot2)
library(dplyr)   
library(knitr)
library(rmarkdown)
library(scales)
```

The data is stored in a comma-separated=value file, which has been archived/compressed into a zipped file. After ensuring that the raw data file **activity.zip** resides in the working directory, unzip (with the **unz()** function) and load the raw data into the work environment (with the **read.csv()** function, with header = TRUE). The output file is called **activityRAW**.


```r
activityRAW <- read.csv(unz("activity.zip", "activity.csv"), header = TRUE)
```

1. Create a copy of the file to keep the integrity of the raw data so it can be referred to, unchanged, during the process as needed.  This file is called **activityNA** (since the data has NA values **steps** field).


```r
activityNA <- activityRAW
```

2. Examine the characteristics of the **activityNA** dataset

* Run the **dim()** function to determine the number of rows of data to confirm that there are 17,568 observations of 3 variables. :


```r
dim(activityNA)
```

```
## [1] 17568     3
```

* Run the **names()** function to determine the header names for the columns of the data.


```r
names(activityNA)
```

```
## [1] "steps"    "date"     "interval"
```


* Run the **summary()** function for an overview of the data values:


```r
summary(activityNA)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##  NA's   :2304     (Other)   :15840
```

Note the number of NA values in the **steps** field is 2304. This missing will be addressed in further analysis.

* Determine the format of each of the data columns:


```r
str(activityNA)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

Note that the date field is a **factor**.

3. Since the data will be analyzed by date (day of week, etc.), the date field data type will be converted from **factor** to **date** using the **as.Date.factor()** and then confirm it worked using the **str()**.


```r
activityNA$date <- as.Date.factor(activityNA$date)

str(activityNA$date)
```

```
##  Date[1:17568], format: "2012-10-01" "2012-10-01" "2012-10-01" "2012-10-01" "2012-10-01" ...
```


Now that the data has been loaded and preprocessed, analyze the data to answer the following questions:

## What is mean total number of steps taken per day?

To calculate the mean total number of steps taken per day, first aggregate the total number of steps per date into a file called **stepsPerDay** and use the **head()** function to view a sample of the file.


```r
stepsPerDay <- aggregate(steps ~ date, activityNA, sum)

head(stepsPerDay, n = 20)
```

```
##          date steps
## 1  2012-10-02   126
## 2  2012-10-03 11352
## 3  2012-10-04 12116
## 4  2012-10-05 13294
## 5  2012-10-06 15420
## 6  2012-10-07 11015
## 7  2012-10-09 12811
## 8  2012-10-10  9900
## 9  2012-10-11 10304
## 10 2012-10-12 17382
## 11 2012-10-13 12426
## 12 2012-10-14 15098
## 13 2012-10-15 10139
## 14 2012-10-16 15084
## 15 2012-10-17 13452
## 16 2012-10-18 10056
## 17 2012-10-19 11829
## 18 2012-10-20 10395
## 19 2012-10-21  8821
## 20 2012-10-22 13460
```
Now that the data is aggregated by day, the following is done:

1. Make a histogram of the total number of steps taken each day.


```r
ggplot(stepsPerDay, aes(x = steps)) +
    geom_histogram(color = "black", fill = "lightblue",
                   binwidth = 3000) +
  scale_x_continuous("Total Daily Steps",label = comma) +
  labs(title = "Total Steps per Day in October and November 2012", y = "Number of Days Step Totals Were Achieved")
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

2. Calculate the mean and median of the total number of steps taken per day.


```r
cat("The mean of the total number of steps:", mean(stepsPerDay$steps), sep = " ")
```

```
## The mean of the total number of steps: 10766.19
```

```r
cat("The median of the total number of steps:", median(stepsPerDay$steps), sep = " ")
```

```
## The median of the total number of steps: 10765
```

## What is the average daily activity pattern?

To determine the average daily activity pattern, first aggregate the data by each 5-minute time interval of each day into a file called **meanStepsPerInt** and use the **head()** function to view a sample of the file..


```r
meanStepsPerInt <-
    aggregate(steps ~ interval, activityNA, mean)

head(meanStepsPerInt, n = 20)
```

```
##    interval     steps
## 1         0 1.7169811
## 2         5 0.3396226
## 3        10 0.1320755
## 4        15 0.1509434
## 5        20 0.0754717
## 6        25 2.0943396
## 7        30 0.5283019
## 8        35 0.8679245
## 9        40 0.0000000
## 10       45 1.4716981
## 11       50 0.3018868
## 12       55 0.1320755
## 13      100 0.3207547
## 14      105 0.6792453
## 15      110 0.1509434
## 16      115 0.3396226
## 17      120 0.0000000
## 18      125 1.1132075
## 19      130 1.8301887
## 20      135 0.1698113
```
Using this new aggregated data file as input, the following is done:

1. Create a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
ggplot(data = meanStepsPerInt,
       aes(interval,steps)) +
  geom_line() + 
        labs(title = "Average Total Steps per 5-minute Daily Intervals",
             subtitle = "24 Hour Time Format (e.g. 0500 = 5:00am)",
             x = "5-Minute Daily Interval",
             y ="Average Number of Steps") +
        scale_x_continuous(labels = function(x) 
                stringr::str_pad(x, width = 4, pad = "0"))
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

2. Determine which 5 minute interval, on average across all the days in the dataset, contains the maximum number of steps.


```r
# find the maximum value in the steps field
maxStepsPerInt <- max(meanStepsPerInt$steps)
# display max steps
maxStepsPerInt
```

```
## [1] 206.1698
```

```r
# subset the meanStepsPerInt to find the interval that has the max steps 
max5MinInt <- subset(meanStepsPerInt, steps == maxStepsPerInt)
# display the record that has the maximum steps
max5MinInt
```

```
##     interval    steps
## 104      835 206.1698
```

```r
cat("The 5-minute time interval with the maximum steps is", stringr::str_pad(max5MinInt$interval, width = 4, pad = "0"), ".")
```

```
## The 5-minute time interval with the maximum steps is 0835 .
```

## Imputing missing values

1. Calculate and report the number of missing values in the dataset.

As seen above when running the **summary()** function on the **activityNA**, there are 2304 instances of NA, or missing values, in the raw data file. We can use the **sum()** function to verify the number.


```r
sum(is.na(activityNA$steps))
```

```
## [1] 2304
```

2. Devise a strategy to fill in  all of the missing values in the dataset.

 Since we have calculated the mean steps per interval above (**meanStepsPerInt**), if the **steps** field in **activityNA** contains NA for a specific time interval, we can populate the field with the correlating value for that time interval in the **meanStepsPerInt** file. If a **steps** value exists, it will not be replaced.

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

Using the strategy outlined above, a new file called **activityNoNA** will be created with the following code. View a sample of the output file.


```r
activityNoNA <- left_join(activityNA, meanStepsPerInt,
                      by = 'interval') %>%
    mutate(steps = ifelse(is.na(steps.x),
                             steps.y, steps.x)) %>%
    select(-steps.y, -steps.x)

head(activityNoNA, n = 20)
```

```
##          date interval     steps
## 1  2012-10-01        0 1.7169811
## 2  2012-10-01        5 0.3396226
## 3  2012-10-01       10 0.1320755
## 4  2012-10-01       15 0.1509434
## 5  2012-10-01       20 0.0754717
## 6  2012-10-01       25 2.0943396
## 7  2012-10-01       30 0.5283019
## 8  2012-10-01       35 0.8679245
## 9  2012-10-01       40 0.0000000
## 10 2012-10-01       45 1.4716981
## 11 2012-10-01       50 0.3018868
## 12 2012-10-01       55 0.1320755
## 13 2012-10-01      100 0.3207547
## 14 2012-10-01      105 0.6792453
## 15 2012-10-01      110 0.1509434
## 16 2012-10-01      115 0.3396226
## 17 2012-10-01      120 0.0000000
## 18 2012-10-01      125 1.1132075
## 19 2012-10-01      130 1.8301887
## 20 2012-10-01      135 0.1698113
```

4. Make a histogram of the total number of steps taken each day and calculate and report the mean and median total number of steps taken per day.

* Using the same process outlined above to process the **activityNA** file, we will first aggregate the total number of steps per date into a file called **stepsPerDay2** and use the **head()** function to view a sample file.


```r
stepsPerDay2 <- aggregate(steps ~ date, activityNoNA, sum)

head(stepsPerDay2, n = 20)
```

```
##          date    steps
## 1  2012-10-01 10766.19
## 2  2012-10-02   126.00
## 3  2012-10-03 11352.00
## 4  2012-10-04 12116.00
## 5  2012-10-05 13294.00
## 6  2012-10-06 15420.00
## 7  2012-10-07 11015.00
## 8  2012-10-08 10766.19
## 9  2012-10-09 12811.00
## 10 2012-10-10  9900.00
## 11 2012-10-11 10304.00
## 12 2012-10-12 17382.00
## 13 2012-10-13 12426.00
## 14 2012-10-14 15098.00
## 15 2012-10-15 10139.00
## 16 2012-10-16 15084.00
## 17 2012-10-17 13452.00
## 18 2012-10-18 10056.00
## 19 2012-10-19 11829.00
## 20 2012-10-20 10395.00
```

* Next, create a histogram of the total number of steps taken each day.


```r
ggplot(stepsPerDay2, aes(x = steps)) +
    geom_histogram(color = "black", fill = "lightblue",
                   binwidth = 3000) +
  scale_x_continuous("Total Daily Steps",label = comma) +
  labs(title = "Total Steps per Day in October and November 2012", y = "Number of Days Step Totals Were Achieved")
```

![](PA1_template_files/figure-html/hist_stepsNoNA-1.png)<!-- -->

* Finally, calculate the mean and median of the total number of steps taken per day:


```r
cat("The mean of the total number of steps::", mean(stepsPerDay2$steps), sep = " ")
```

```
## The mean of the total number of steps:: 10766.19
```

```r
cat("The median of the total number of steps:", median(stepsPerDay2$steps), sep = " ")
```

```
## The median of the total number of steps: 10766.19
```
###Do these values different from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

The mean of the data did not change. The median of the data changed from 10765 to 10766.19, which is not significantly different. Thus the missing data does not seem to impact the overall analysis of the data.

## Are there differences in activity patterns between weekdays and weekends?

Using the data with the NA value replaced (**activityNoNA**), analyze the data to identy which data was captured on a weekend versus a weekday.

1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given data is a weekday or weekend.

Once we determine the day of the week for each observation we can then assign a variable of weekend or weekday for each.

Using the *activityNoNA** file, create a new field called **dow_type**, and populate it with "weekday" or "weekend". We first use the **weekdays()** function on the **date** field to determine the day of the week. If the day is "Saturday" or "Sunday", the dow_type = "weekend", else it will be "weekday". View a sample of the file using the **head()** function.


```r
activityNoNA$dow_type <- ifelse(
        weekdays(activityNoNA$date) == c("Saturday", "Sunday"),
        "Weekend", "Weekday")

head(activityNoNA, n = 20)
```

```
##          date interval     steps dow_type
## 1  2012-10-01        0 1.7169811  Weekday
## 2  2012-10-01        5 0.3396226  Weekday
## 3  2012-10-01       10 0.1320755  Weekday
## 4  2012-10-01       15 0.1509434  Weekday
## 5  2012-10-01       20 0.0754717  Weekday
## 6  2012-10-01       25 2.0943396  Weekday
## 7  2012-10-01       30 0.5283019  Weekday
## 8  2012-10-01       35 0.8679245  Weekday
## 9  2012-10-01       40 0.0000000  Weekday
## 10 2012-10-01       45 1.4716981  Weekday
## 11 2012-10-01       50 0.3018868  Weekday
## 12 2012-10-01       55 0.1320755  Weekday
## 13 2012-10-01      100 0.3207547  Weekday
## 14 2012-10-01      105 0.6792453  Weekday
## 15 2012-10-01      110 0.1509434  Weekday
## 16 2012-10-01      115 0.3396226  Weekday
## 17 2012-10-01      120 0.0000000  Weekday
## 18 2012-10-01      125 1.1132075  Weekday
## 19 2012-10-01      130 1.8301887  Weekday
## 20 2012-10-01      135 0.1698113  Weekday
```

2. Make a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

First aggregate the steps data by interval and dow_type. View a sample of the data.


```r
meanStepsPerIntPerDayType <-
        aggregate(steps ~ interval + dow_type,
                  activityNoNA, mean)

head(meanStepsPerIntPerDayType, n = 20)
```

```
##    interval dow_type      steps
## 1         0  Weekday 1.94375222
## 2         5  Weekday 0.38447846
## 3        10  Weekday 0.14951940
## 4        15  Weekday 0.17087932
## 5        20  Weekday 0.08543966
## 6        25  Weekday 1.38981844
## 7        30  Weekday 0.59807761
## 8        35  Weekday 0.98255607
## 9        40  Weekday 0.00000000
## 10       45  Weekday 1.66607334
## 11       50  Weekday 0.34175863
## 12       55  Weekday 0.01744393
## 13      100  Weekday 0.36311855
## 14      105  Weekday 0.08971164
## 15      110  Weekday 0.17087932
## 16      115  Weekday 0.38447846
## 17      120  Weekday 0.00000000
## 18      125  Weekday 1.26023496
## 19      130  Weekday 2.07191171
## 20      135  Weekday 0.02242791
```

Using the new **meanStepsPerIntPerDayType** file, we will then create a panel plot to compare the weekend and weekday data.


```r
ggplot(data = meanStepsPerIntPerDayType,
       aes(x=interval, y= steps)) +
        facet_grid(dow_type ~ .) +
        geom_line()
```

![](PA1_template_files/figure-html/time_seriesWKDAY-1.png)<!-- -->

From this we can see that the, while the subject of this study moves around during the same time windows during both the weekdays and the weekend, the subject has a much higher activity level during the weekend.
