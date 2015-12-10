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
#now we can make some plots. first one looks like a histogram of global active power
#use png command, which defaults to size asked for
png('plot1.png')
hist(consump2$global_active_power,col='red',xlab='Global Active Power (kilowatts)',main="Global Active Power")
dev.off()
#boom