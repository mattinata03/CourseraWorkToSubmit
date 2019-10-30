## Coursera: Exploratory Data Analysis: Final Class project
## Lisa Murray

## Question 4:
## Across the United States, how have emissions from coal
## combustion-related sources changed from 1999–2008?

## Load the raw data files.

NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# Subset the SCC file for sources that are coal combustion-related
# First subset SCC for sources from combustion sources

cSCC <- SCC[grep("[Cc]omb", SCC$EI.Sector, value = FALSE),]

# Then subset the combustion sources for those using coal

cCoalSCC <- cSCC[grep("[Cc]oal",
                            cSCC$EI.Sector, value = FALSE),]

# Subset the NEI data for data sourced only from coal combustion-related
# sources.

cCoalNEI_US <- subset(NEI, NEI$SCC %in% cCoalSCC$SCC)


## Aggregate the NEI data, summing emissions by year


cCoalPM25_US <- aggregate(Emissions ~ year,
                                  cCoalNEI_US, sum)

## Create plot of PM2.5 coal combustion-related emissions
## for the US, with chart showing PM2.5 total emissions by year
## Add a linear model smooth line to see trend in Data
## (dividing total emissions by 10,000 so y axis values are easier to read)
## Save output to a png file

png(filename = "4_cCoalPM25_US.png", width = 480, height = 480)
with(cCoalPM25_US,
     plot(year, Emissions/10000,
          xlab = "Year",
          ylab = "PM 2.5 Emissions in 10,000 of Tons",
          main = 
          "PM 2.5 Emissions in the United States from 1999 to 2008
          from Coal Combustion-Related Sources",
          pch = 20,
          xlim = c(1999,2008),
          cex = 2,
          col = "blue",
          font.lab = 2,
          las = 1))

with(cCoalPM25_US,
     abline(lm(Emissions/10000 ~ year),
            lwd = 2,
            col = "red",
            lty = "dotted"))

dev.off()
