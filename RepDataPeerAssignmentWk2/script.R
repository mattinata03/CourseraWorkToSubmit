library(ggplot2)
library(dplyr)
library(knitr)
activityRaw <- read.csv(unz("activity.zip", "activity.csv"), header = TRUE)

stepsPerDay <- aggregate(steps ~ date, activityRaw, sum)
ggplot(data = stepsPerDay, aes(steps)) +
    geom_histogram(binwidth = 2000)
hist(stepsPerDay$steps)

mean(stepsPerDay$steps)
median(stepsPerDay$steps)
sum(is.na(activityRaw$steps))
activityWork <- activityRaw
activityWork$newdate <- as.Date.factor(activityWork$date)
activityWork$DOW <- weekdays(activityWork$newdate)
activityWORK2$DOW_type2 <- ifelse(
    weekdays(activityWORK2$date) == c("Sunday", "Saturday"), 
        "Weekend", "Weekday")

stepsPerInterval <- aggregate(steps ~ interval, 
                              activityWork, sum)

ggplot(data = stepsPerInterval, aes(steps)) +
    geom_histogram(binwidth =1000)
mean(stepsPerInterval$steps)
median(stepsPerInterval$steps)

meanStepsPerInterval <- 
    aggregate(steps ~ interval, activityRaw, mean)

meanNewStepsPerInterval <- 
    aggregate(newSteps ~ interval, activityWork, mean)

#activityWork$newSteps <- ifelse(is.na(activityWork$steps), 
#                                "test", activityWork$steps)

library(dplyr)
activityWork <- left_join(activityWork, meanStepsPerInterval, 
                      by = 'interval') %>% 
    mutate(newSteps = ifelse(is.na(steps.x), 
                             steps.y, steps.x)) %>% 
    select(-steps.y)

with(meanStepsPerInterval, plot(interval, steps, type = "l"))


stepsPerDaynoNA <- aggregate(newSteps ~ date, activityWork, sum)

ggplot(data = stepsPerDaynoNA, aes(newSteps)) + 
        geom_histogram(binwidth = 2000)

mean(stepsPerDaynoNA$newSteps)
median(stepsPerDaynoNA$newSteps)

ggplot(data = meanStepsPerInterval, 
       aes(x=interval, y= steps)) + 
    facet_grid(. ~ DOW_type)
    geom_line()

#Need to figure out how to do a panel plot with line plot per 
#interval for Weekday/Weekend 

