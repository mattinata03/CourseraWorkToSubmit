## Coursera: Exploratory Data Analysis: Final Class project
## Lisa Murray

## Question 3:
## Of the four types of sources indicated by the type (point,
## nonpoint, onroad, nonroad) variable, which of these four sources
## have seen decreases in emissions from 1999–2008 for Baltimore City?
## Which have seen increases in emissions from 1999–2008?
## Use the ggplot2 plotting system to make a plot answer this question.

## Load the raw data files.

NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# Load the graphics package

library("ggplot2")

# Subset the NEI data for fips = '24510'

NEI_Balt <- subset(NEI, fips == '24510')

## Aggregate the NEI data, summing emissions by year
## This will be the input to the plot for Question 1 of the Week 4
## class project for the Exploratory Data Analysis Coursera classs

PM25Source_Balt <- aggregate(Emissions ~ year + type, NEI_Balt, sum)

## Create plot of PM2.5 emissions for each source in Balt City, with
## chart showing PM2.5 total emissions by year
## Add a linear model smooth line to see trend in Data by sources
## Save output to a png file

PM25Source_Balt_plot <- ggplot(PM25Source_Balt,
       aes(x = year,
           y = Emissions,
           color = type)) +
        geom_point() +
        geom_smooth(method = "lm",
                    linetype = "dashed",
                    se = FALSE) +
        labs(title =
        "Total PM2.5 Emissions in Baltimore City from 1999 to 2008",
        subtitle = "by Source Type",
        x = "Year",
        y = "PM2.5 Emissions in Tons",
        color = "Source Type") +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5))



# Create output file

suppressMessages(ggsave(PM25Source_Balt_plot,
                       filename = "3_PM25Source_Balt.png"))
