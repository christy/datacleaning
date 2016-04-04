options(rpubs.upload.method = "internal")
install.packages('ggplot2')
library(ggplot2)
require(ggplot2)

# Set directory
#setwd("C:/Users/bergmc/Documents/cb/datakind/cta")

# Read Data from csv 
df = read.csv(file="ma11.csv", header=TRUE, sep=",");

#################
# Make notes about your data
# rows = 529
# number unique users = 492
# Check data types
# Did you read the data in right?
#################
names(df)
head(df, n=5)
str(df)

# Check your missing data situation
# Are you missing too much data in any of your "key" columns?
good <- complete.cases(df) #logical vector of which rows are complete
temp <- df[good, ] 
nrow(temp)

# Expect characters as factors
#convert users, events to factors
df$contactID <- as.factor(df$contactID)
df$event <- as.factor(df$event)
str(df)

############################
# convert timestring character text to POSIXlt
# convert unix time to POSIXlt
# origin="1899-12-30" for Excel Windows
# origin="1970-01-01" for Unix times
############################
# example with literal timestamp character string
df$timestring <- as.character(df$timestring)
df$timestring <- strptime(df$timestring
                                , "%Y-%m-%d %H:%M:%S"
                                , tz="America/Los_Angeles")
# example with Unix time
df$Unix_time <- as.POSIXct(df$Unix_time/1000, origin="1970-01-01")
df$Unix_time <- as.POSIXlt(df$Unix_time)
class(df$timestring)
class(df$Unix_time)
head(paste(paste(df$timestring, df$Unix_time, sep=" Unixtime: "),
           df$Unix_time$zone))  #first 6 rows

# example with Windows Excel times
# Sort by ContactID, so we can compare values against original Excel
df <- df[with(df, order(Contact.ID)), ]
tempDates <- as.Date(df$Start.Date, origin="1899-12-30")
# Check dates with original .xls sheet, sorted by ContactID
head(df$Start.Date, n=20)
head(tempDates, n=20)
# Yes, they matched, so origin date assumption was correct, convert all Dates
df$Start.Date <- as.Date(df$Start.Date, origin="1899-12-30")

# Eyeball your data for strange-looking dates or column names
head(df, n=10)

# Rename columns in case of messy misspellings
# example rename all columns for Contact.ID to exactly that
names(df)[names(df)=="Client..Contact.ID"] <- "Contact.ID"

# Save .Rdata file, makes re-loading faster in case of errors
save(df, file="clean_data.RData")

# Write cleaned csv files
write.csv(df, file = 'cleaned_data.csv')

# Check frequency histograms for columns







