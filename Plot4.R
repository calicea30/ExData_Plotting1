library(sqldf)
library(lubridate)
library(tidyverse)

# Create a data folder for the project data
if(!file.exists("./data")){
  dir.create("./data")
  }

# Get and unzip data for the project
if(!file.exists("./data/data.zip")){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl,destfile="./data/data.zip")
  unzip(zipfile="./data/data.zip",exdir="./data")
}

datafile <- "./data/household_power_consumption.txt"

# create data frame with only the dates needed.
df <- read.csv.sql(datafile, header = TRUE, sep = ";",
                   sql="Select * from file where Date = '1/2/2007' or Date = '2/2/2007'")

# convert Date and Time columns from character
# https://www.geeksforgeeks.org/how-to-merge-date-and-time-in-r/
df <- df %>%
  mutate(Time=dmy_hms(paste(df$Date, df$Time)),
         Date=as.POSIXct(df$Date, format="%d/%m/%Y"))

# multiple plots at once
# https://www.statmethods.net/advgraphs/layout.html
png(file="Plot4.png", width = 480, height = 480)

par(mfrow=c(2,2))
# plot top left (column 1, row 1)
plot(df$Time, df$Global_active_power, 
     type =  "l",
     xlab =  "",
     ylab = "Global Active Power")

#plot bottom left (column 1, row 2)
plot(df$Time, df$Voltage, 
     type =  "l",
     xlab = "datetime",
     ylab = "Voltage")

# plot top right (column 2, row 1)
plot(df$Time, df$Sub_metering_1,
     type =  "l",
     xlab = "",
     ylab =  "Energy sub metering")
points(df$Time, df$Sub_metering_2, type = "l", col = "red")
points(df$Time, df$Sub_metering_3, type = "l", col = "blue")
legend("topright",100,legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black","red","blue"),
       lty=c(1,1,1))

#plot bottom right (column 2, row 2)
plot(df$Time, df$Global_reactive_power, 
     type =  "l",
     xlab = "datetime",
     ylab = "Voltage")

dev.off()
