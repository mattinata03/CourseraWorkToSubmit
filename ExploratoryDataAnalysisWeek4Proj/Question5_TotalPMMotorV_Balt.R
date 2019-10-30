## Coursera: Exploratory Data Analysis: Final Class project
## Lisa Murray

## Question 5:
## How have emissions from motor vehicle sources changed from
## 1999–2008 in Baltimore City?

## Load the raw data files.
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

library(ggplot2)

# Subset the SCC file for sources that are motor vehicles

vSCC <- SCC[grep("[Vv]ehicle",
                       SCC$EI.Sector, value = FALSE),]


# Subset the NEI data for fips = '24510'

NEI_Balt <- subset(NEI, fips == '24510')


# Subset the NEI Baltimore data for data sourced from motor vehicles

vNEI_Balt <- subset(NEI_Balt,
                    NEI_Balt$SCC %in% vSCC$SCC)


## Aggregate the data, summing emissions by year

vPM25_Balt <- aggregate(Emissions ~ year,
                        vNEI_Balt, sum)

## Create plot of PM2.5 emissions from motor vehicles, with
## chart showing PM2.5 total emissions by year
## Add a linear model smooth line to see trend in Data
## Save output to a png file

vPM25_Balt_plot <- ggplot(vPM25_Balt,
                          aes(x = year,
                              y = Emissions)) +
        geom_point() +
        geom_smooth(method = "lm",
                    linetype = "dashed",
                    se = FALSE) +
        labs(title = 
        "PM2.5 Motor Vehicle Emissions",
        subtitle = " in Baltimore City from 1999 to 2008",
             x = "Year",
             y = "PM2.5 Emissions in Tons") +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5))

# Create output file

suppressMessages(ggsave(vPM25_Balt_plot,
                       filename = "5_vPM25_Balt.png"))
