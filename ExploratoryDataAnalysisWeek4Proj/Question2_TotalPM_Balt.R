## Coursera: Exploratory Data Analysis: Final Class project
## Lisa Murray

## Question 2:
## Have total emissions from PM2.5 decreased in Baltimore
## City, Maryland (fips == "24510") from 1999 to 2008?
## Use the base plotting system to make a plot answering
## this question.

## Load the raw data files.
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# Subset the NEI data for fips = '24510'

NEI_Balt <- subset(NEI, fips == '24510')

## Aggregate the NEI_Balt data, summing emissions by year

PM25_Balt <- aggregate(Emissions ~ year, NEI_Balt, sum)


## Create plot of PM2.5 emissions for Balt City, with
## chart showing PM2.5 total emissions by year
## Add a linear model smooth line to see trend in Data
## Save output to a png file

png(filename = "2_PM25_Balt.png", width = 480, height = 480)
with(PM25_Balt,
     plot(year, Emissions,
          xlab = "Year",
          ylab = "PM 2.5 Emissions in Tons",
          main = "PM 2.5 Emissions in Baltimore City from 1999 to 2008",
          pch = 20,
          xlim = c(1999,2008),
          cex = 2,
          col = "blue",
          font.lab = 2,
          las = 1))

with(PM25_Balt,
     abline(lm(Emissions ~ year),
            lwd = 2,
            col = "red",
            lty = "dotted"))

dev.off()
