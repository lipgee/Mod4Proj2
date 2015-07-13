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


# Merge the data based on SCC

merge_df <- merge(NEI, SCC, "SCC")
colnames(merge_df)[8] <- "shortname"


# Group the data by year and type

NEI_Coal <- sqldf('select year, Emissions from merge_df where shortname like "%Coal%Combustion%" ')

NEI_year <- group_by(NEI_Coal,year)
total_em <- summarise(NEI_year, Total_Emissions=sum(Emissions))

# Plot the data and save as png  

g <- ggplot(total_em, aes(year,Total_Emissions))
plot4 <- g + geom_point() + geom_line() + theme_bw(base_family = "Avenir", base_size = 10) + labs(x = "Year") + labs(y = "Total Emissions (tons)") + ggtitle(expression(paste("Trending of ",PM[2.5] , " Emissions from Coal Combustion in US (1999 - 2008)")))
ggsave(file="plot4.png", plot=plot4)
