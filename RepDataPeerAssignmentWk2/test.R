temp <- activityNA$interval
temp2 <- mapply(function(x, y) paste0(rep(x, y), collapse = ""), 
                0, 4 - nchar(temp))
temp <- paste0(temp2, temp)
activityNA$interval <- strptime(temp, format="%H%M")


ggplot(data = meanStepsPerInt,
       aes(interval,steps)) +
  geom_line() + 
        labs(title = "Average Total Steps per 5-minute Daily Intervals",
             subtitle = "24 Hour Time Format (e.g. 0500 = 5:00am)",
             x = "5-Minute Daily Interval",
             y ="Average Number of Steps") +
        scale_x_continuous(labels = function(x) 
                stringr::str_pad(x, width = 4, pad = "0"))
                