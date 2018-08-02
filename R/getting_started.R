# @Author Rahul Gupta
# @Date 28-Jul-2018

# ----------------
# Import Libraries
# ----------------
require(tidyverse)

# ----------------
# Read Source file
# ----------------

setwd("~/Documents/Projects/Datathon/MelbDatathon2018")

# Show High Precision Number like lat and long
options("digits" = 15)

# card_types
col_names = c('Card_SubType_ID','Card_SubType_Desc','Payment_Type','Fare_Type','Concession_Type','MI_Card_Group')
card_types = read.csv('card_types.txt',sep = '|', col.names = col_names, header = FALSE)

# Calendar
col_names = c('Date','Date1','CalendarYear','FinancialYear','FinancialMonth','CalendarMonth','CalendarMonthSeq',
              'CalendarQuarter','FinancialQuarter','CalendarWeek','FinancialWeek','DayType','DayTypeCategory',
              'DayTypeCategory2','WeekdaySeq',
              'WeekDay','FinancialMonthSeq','FinancialMonthName','MonthNumber','ABSWeek','WeekEnding','QuarterName')
calendar = read.csv('calendar.txt',sep = '|', col.names = col_names, header = FALSE)

# All on
allon = read.csv('allon.txt',sep = ',', header = TRUE)

# stop_locations
col_names = c('StopLocationID','StopNameShort','StopNameLong','StopType','SuburbName','PostCode','RegionName',
              'LocalGovernmentArea','StatDivision','GPSLat','GPSLong')
stop_locations = read.csv('stop_locations.txt',sep = '|', col.names = col_names, header = FALSE)

# Car Speeds
vehicle_traffic = read_csv('car_speeds/melbourne_vehicle_traffic.csv')
head(vehicle_traffic)

# Sample of Scan on transaction
col_names = c('Mode','BusinessDate','DateTime','CardID','CardType','VehicleID','ParentRoute','RouteID','StopID')
scan_on2018W2 = read_delim('Samp_0/ScanOnTransaction/2018/Week2/QID3532995_20180713_34925_0.txt.gz', 
                           delim = '|', col_names = col_names)

# Sample of Scan off transaction
scan_off2018W2 = read_delim('Samp_0/ScanOffTransaction/2018/Week2/QID3530175_20180713_12533_0.txt.gz', 
                            delim = '|', col_names = col_names)
