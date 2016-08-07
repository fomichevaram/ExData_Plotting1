library(data.table)
if (dir.exists('./data') == F) {
  dir.create('./data')
  download.file(
    'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip',
    './data/pwc.zip'
  )
  unzip('./data/pwc.zip',exdir = './data/dfa')
}
Sys.setlocale("LC_TIME", "English")
df <- fread('data/dfa/household_power_consumption.txt')
str(df)
library(lubridate)
df$DT <- dmy_hms(paste(df$Date, df$Time))
df$Date <- dmy(df$Date)
library(dplyr)
df %>% filter(Date >= '2007-02-01' & Date <'2007-02-03') -> df1
df1 %>% mutate(Global_active_power = as.numeric(Global_active_power))

png(filename = 'plot4.png', width = 480, height = 480)
par(mfrow = c(2,2))
plot(df1$Global_active_power ~ df1$DT, type = 'l', xlab = '', ylab = 'Global Active Power (kilowatts)')
plot(df1$Voltage ~ df1$DT, type = 'l', xlab = 'datetime', ylab = 'Voltage')
plot(df1$Sub_metering_1 ~ df1$DT, type = 'l', xlab = '', ylab = 'Energy sub metering')
lines(df1$Sub_metering_3 ~ df1$DT, col = 'blue')
lines(df1$Sub_metering_2 ~ df1$DT, col = 'red')
legend('topright',col = c('black','red','blue'),lty = c(1,1,1), legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), bty = 'n')
plot(df1$DT, df1$Global_reactive_power, lty = 1, type = 'l', xlab = "datetime", ylab = 'Global_reactive_power')
dev.off()