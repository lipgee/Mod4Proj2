# Load the required packages

library(dplyr)
library(ggplot2)
library(sqldf)

# Create a directory to host the data set
# If a directory with the same name exist, back it up

if(file.exists("./datamod4proj2"))
{
        file.rename("./datamod4proj2","./datamod4proj2")
        
}

dir.create("./datamod4proj2")        

# Download the dataset and unzip it
# remove the downloaded zip file to save space

file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(file_url,"./datamod4proj2/dataset.zip",method="libcurl")
unzip("./datamod4proj2/dataset.zip",exdir="./datamod4proj2")
file.remove("./datamod4proj2/dataset.zip")

# Reading data set

NEI <- readRDS("./datamod4proj2/summarySCC_PM25.rds")
SCC <- readRDS("./datamod4proj2/Source_Classification_Code.rds")


# Find all emissions originated from motor vehicle and from LA and Baltimore

NEI_vehicle <- sqldf('select year, fips, Emissions from NEI where type="ON-ROAD" and fips in ("24510","06037") ')

NEI_year <- group_by(NEI_vehicle,year, fips)
total_em <- summarise(NEI_year, Total_Emissions=sum(Emissions))

# Split the result into 2 DF

em_LA <- sqldf('select year, "Los Angeles, CA", Total_Emissions from total_em where fips="06037"    ')

em_BAL <- sqldf('select year, "Baltimore City, MD", Total_Emissions from total_em where fips="24510"    ')

# Modify the column name to City

colnames(em_LA)[2] <- "City"
colnames(em_BAL)[2] <- "City"

# Create 2 vector to capture the changes from year to year

Changes_LA <- c(0, diff(em_LA$Total_Emissions))
Changes_BAL <- c(0, diff(em_BAL$Total_Emissions))

# Add the changes into to a data frame

em_LA_Change <- cbind(em_LA, Changes=Changes_LA)
em_BAL_Change <- cbind(em_BAL, Changes=Changes_BAL)

# Combine them all

em_Change <- rbind(em_LA_Change,em_BAL_Change)

# Plot the data and save as png  

g <- ggplot(em_Change, aes(year,Changes, col=City, group=City))
plot6 <- g + geom_point() + geom_line() + theme_bw(base_family = "Avenir", base_size = 10) + labs(x = "Year") + labs(y = "Changes of Total Emissions (tons)") + ggtitle(expression(paste(PM[2.5] , " Emissions Change from Motor Vehicle in Baltimore City vs LA (1999 - 2008)")))
ggsave(file="plot6.png", plot=plot6)




