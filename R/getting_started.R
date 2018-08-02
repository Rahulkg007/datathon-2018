# @Author Rahul Gupta
# @Date 28-Jul-2018
# @Modified 2-Aug-2018

# ----------------
# Import Libraries
# ----------------
require(tidyverse)
require(pryr) # check memory usage
require(scales)

# ----------------
# Read Source file
# ----------------

setwd("~/Documents/Projects/Datathon/MelbDatathon2018")

# Show High Precision Number like lat and long
options("digits" = 15)

# card_types
col_names = c('Card_SubType_ID','Card_SubType_Desc','Payment_Type','Fare_Type','Concession_Type','MI_Card_Group')
card_types = read_delim('card_types.txt', delim ='|', col_names = col_names)


# Calendar
col_names = c('Date','Date1','CalendarYear','FinancialYear','FinancialMonth','CalendarMonth','CalendarMonthSeq',
              'CalendarQuarter','FinancialQuarter','CalendarWeek','FinancialWeek','DayType','DayTypeCategory',
              'DayTypeCategory2','WeekdaySeq',
              'WeekDay','FinancialMonthSeq','FinancialMonthName','MonthNumber','ABSWeek','WeekEnding','QuarterName')
calendar = read_delim('calendar.txt', delim ='|', col_names = col_names)

# stop_locations
col_names = c('StopLocationID','StopNameShort','StopNameLong','StopType','SuburbName','PostCode','RegionName',
              'LocalGovernmentArea','StatDivision','GPSLat','GPSLong')
stop_locations = read_delim('stop_locations.txt', delim ='|', col_names = col_names)

# Car Speeds
vehicle_traffic = read_csv('car_speeds/melbourne_vehicle_traffic.csv')
head(vehicle_traffic)

# Sample of Scan on transaction - Sample 1
col_names = c('Mode','BusinessDate','DateTime','CardID','CardType','VehicleID','ParentRoute','RouteID','StopID')
scan_on_S0_2018_W2 = read_delim('Samp_0/ScanOnTransaction/2018/Week2/QID3532995_20180713_34925_0.txt.gz', 
                           delim = '|', col_names = col_names)

# Scan on Sample 2
scan_on_S0_2016_W10 = read_delim('Samp_0/ScanOnTransaction/2016/Week10/QID3531224_20180713_23137_0.txt.gz', 
                              delim = '|', col_names = col_names)

# Sample of Scan off transaction
scan_off_S0_2018_W2 = read_delim('Samp_0/ScanOffTransaction/2018/Week2/QID3530175_20180713_12533_0.txt.gz', 
                            delim = '|', col_names = col_names)

# ----------------
# General Analysis
# ----------------

# generalize dataset
data = rbind(scan_on_S0_2018_W2, scan_off_S0_2018_W2)
object_size(data)
head(data)

# Exploring Transaction data
ggplot(data,aes(Mode)) + geom_bar() 
# --> highest to lowest 2, 1 and 3

# card types
table(data$CardType)

card_type = data %>%
  select(CardType) %>%
  group_by(CardType) %>%
  summarise(count=n()) %>%
  arrange(desc(count)) %>%
  head(10)

card_type$CardType = card_type$CardType %>% 
  factor(levels = card_type$CardType[order(card_type$count)]) 

ggplot(card_type) +
  geom_bar(aes(CardType,count), stat='identity')  + 
  coord_flip() +
  scale_y_continuous(labels = comma)
# card type 1 is most common, then 2, 9 and 4

# merge data with card types
data_merge = merge(x = data, y = card_types, by.x = 'CardType', by.y = 'Card_SubType_ID')
object_size(data_merge)
head(data_merge)

# card types visualization
ggplot(data_merge, aes(Payment_Type)) + geom_bar() + scale_y_continuous(labels = comma)
ggplot(data_merge, aes(Fare_Type)) + geom_bar() + scale_y_continuous(labels = comma)
ggplot(data_merge, aes(Concession_Type)) + geom_bar() + coord_flip() + scale_y_continuous(labels = comma)
ggplot(data_merge, aes(MI_Card_Group)) + geom_bar() + coord_flip() + scale_y_continuous(labels = comma)

# For card description - Detailed level
card_desc = data_merge %>%
  select(Card_SubType_Desc) %>%
  group_by(Card_SubType_Desc) %>%
  summarise(count=n()) %>%
  arrange(desc(count)) %>%
  head(10)

card_desc$Card_SubType_Desc = card_desc$Card_SubType_Desc %>% 
  factor(levels = card_desc$Card_SubType_Desc[order(card_desc$count)]) 

ggplot(card_desc) +
  geom_bar(aes(Card_SubType_Desc,count), stat='identity')  + 
  coord_flip() +
  scale_y_continuous(labels = comma)

x = data.frame(table(data$RouteID))
