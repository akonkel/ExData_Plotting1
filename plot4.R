#we'll need the chron library for the time
require(chron)

#assumes this script is in folder with data file
consump=read.table('household_power_consumption.txt',skip=1,sep=";",stringsAsFactors = FALSE)
names(consump)=c("date","time","global_active_power","global_reactive_power","voltage","global_intensity","sub_metering_1","sub_metering_2","sub_metering_3")
#said to limit to 2007-02-01 and 2007-02-02, which are helpfully not in the format used in the data
consump2=subset(consump,date=='1/2/2007' | date=='2/2/2007')
consump2$datetime=paste(consump2$date,consump2$time)
consump2$date=as.Date(consump2$date,format='%d/%m/%Y')
consump2$time=chron(times=consump2$time)
consump2$datetime=strptime(consump2$datetime,format='%d/%m/%Y %T')
#set remaining columns to numbers
for (i in 3:9) {
  consump2[,i]=as.numeric(consump2[,i])
}
#now we can make some plots. fourth one is a collection of plot 2, plot 3, voltage over time, and global reactive power over time
#use png command, which defaults to size asked for
png('plot4.png')
par(mfcol=c(2,2))
#plot 1
plot(consump2$datetime,consump2$global_active_power,ty='l',ylab='Global Active Power (kilowatts)',xlab='')
#plot 2 
plot(consump2$datetime,consump2$sub_metering_1,ty='l',ylab='Energy sub metering',xlab='')
lines(consump2$datetime,consump2$sub_metering_2,col='red')
lines(consump2$datetime,consump2$sub_metering_3,col='blue')
legend('topright',legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_2'),col=c('black','red','blue'),lwd=1)
#plot 3
plot(consump2$datetime,consump2$voltage,ty='l',ylab='Voltage',xlab='datetime')
#plot 4
plot(consump2$datetime,consump2$global_reactive_power,ty='l',xlab='datetime',ylab='global_reactive_time')
dev.off()
#boom