# Load the required packages

library(dplyr)

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


# Group the data by year

NEI_year <- group_by(NEI,year)
total_em <- summarise(NEI_year, Total_Emissions=sum(Emissions/1000))

# Plot the data as png graphic device 

png(filename="plot1.png", width=480,height=480)
par(col.main="blue",col.lab="blue", font=2,font.axis="serif")
with(total_em, plot(year,Total_Emissions, type="o", main=expression(paste("Trending of Total ", PM[2.5], " Emissions in US (1999 - 2008)")),xlab="Year", ylab="Total Emissions ( ,000 Tons )",xaxt="n"))
axis(side=1, at=total_em$year)
dev.off()


