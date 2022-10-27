activityRaw <- read.csv(unz("activity.zip", "activity.csv"), header = TRUE)
dim(activityRawW)
summary(activityRaw)
names(activityRaw)
str(activityRaw)
stepsPerDay <- aggregate(steps ~ date, activityRaw, sum)
ggplot(data = stepsPerDay, aes(steps)) + geom_histogram(binwidth = 3000)

mean(stepsPerDay$steps)
median(stepsPerDay$steps)
sum(is.na(activityRaw$steps))
activityWork <- activityRaw
activityWork$newdate <- as.Date.factor(activityWork$date)
activityWork$DOW <- weekdays(activityWork$newdate)

stepsPerInterval <- aggregate(steps ~ interval, activityWork, sum)

ggplot(data = stepsPerInterval, aes(steps)) + geom_histogram()
mean(stepsPerInterval$steps)
median(stepsPerInterval$steps)

x$DOW_type <- ifelse(
        x$DOW == c("Sunday", "Saturday"), 
        "Weekend", "Weekday")
meanStepsPerInterval <- aggregate(steps ~ interval, activityRaw, mean)

activityWork$newSteps <- ifelse(is.na(activityWork$steps), 
                                "test", activityWork$steps)

library(dplyr)
activityWork <- left_join(activityWork, meanStepsPerInterval, 
                      by = 'interval') %>% 
    mutate(newSteps = ifelse(is.na(steps.x), 
                             steps.y, steps.x)) %>% 
    select(-steps.y)

with(meanStepsPerInterval, plot(interval, steps, type = "l"))


stepsPerDaynoNA <- aggregate(newSteps ~ date, activityWork, sum)

ggplot(data = stepsPerDaynoNA, aes(newSteps)) + 
        geom_histogram(binwidth = 3000)

mean(stepsPerDaynoNA$newSteps)
median(stepsPerDaynoNA$newSteps)

aggregate(newSteps ~ DOW_type + interval, activityWork, mean)

meanPerIntervalDOWtype <- aggregate(newSteps ~ DOW_type + interval, 
                                    activityWork, mean)


#Need to figure out how to do a panel plot with line plot per 
#interval for Weekday/Weekend 

