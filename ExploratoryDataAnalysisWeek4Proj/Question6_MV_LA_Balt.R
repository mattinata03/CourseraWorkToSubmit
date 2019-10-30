## Coursera: Exploratory Data Analysis: Final Class project
## Lisa Murray

## Question 6:
## Compare emissions from motor vehicle sources in Baltimore City
## with emissions from motor vehicle sources in Los Angeles County,
## California (fips=="06037"). Which city has seen greater changes
## over time in motor vehicle emissions?

## Load the raw data files.
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

library(ggplot2)

# Subset the SCC file for sources that are motor vehicles

vSCC <- SCC[grep("[Vv]ehicle",
                       SCC$EI.Sector, value = FALSE),]


# Subset the NEI data for fips = '24510'

NEI_Balt <- subset(NEI, fips == '24510')

# Subset the NEI data for fips = '06037'

NEI_LA <- subset(NEI, fips == "06037")

# combine the two files
NEI_LA_Balt <- rbind(NEI_Balt, NEI_LA)

# Subset the data for sources from motor vehicles

vPM25_BaltLA <- subset(NEI_LA_Balt,
                             NEI_LA_Balt$SCC %in% vSCC$SCC)


## Aggregate the  data, summing emissions by year


vBaltLA <- aggregate(Emissions ~ year + fips,
                                  vPM25_BaltLA, sum)

## Create plot of PM2.5 emissions from motor vehicles, with
## chart showing PM2.5 total emissions by year
## Add a linear model smooth line to see trend in Data
## Save output to a png file

vBaltLA_plot <- ggplot(vBaltLA,
                       aes(x = year,
                           y = Emissions,
                           color = fips)) +
                geom_point() +
                geom_smooth(method = "lm", 
                            linetype = "dashed",
                            se = FALSE) +
                labs(title = 
                        "PM2.5 Motor Vehicle Emissions",
                  subtitle = 
                  " in Baltimore City and Los Angeles County from 1999 to 2008",
                     y = "PM2.5 Emissions in Tons",
                     color = "Location") +
                scale_color_discrete(labels = c("LA County", "Baltimore")) +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5))


# Create output file

suppressMessages(ggsave(vBaltLA_plot,
                       filename = "6_vBalt_LA.png"))
