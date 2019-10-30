## Coursera: Exploratory Data Analysis: Final Class project
## Lisa Murray

## Question 1:
## Have total emissions from PM2.5 decreased in the United States
## from 1999 to 2008? Using the base plotting system, make a plot showing
## the total PM2.5 emission from all sources for each of the years
## 1999, 2002, 2005, and 2008.

## Load the raw data files.

NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

## Aggregate the NEI data, summing emissions by year

PM25_US <- aggregate(Emissions ~ year, NEI, sum)

## Create bar chart showing PM2.5 total emissions by year
## and save to png file (dividing total emissions by 10,000 so y axis
## values are easier to read)

png(filename = "1_PM25_US.png", width = 480, height = 480)
with(PM25_US,
      barplot(Emissions/10000 ~ year,
              xlab = "Year",
              ylab = "PM 2.5 Emissions in 10,000s of Tons",
              col = "red",
              main = 
              "PM 2.5 Emissions in the United States from 1999 to 2008"))

dev.off()
