install.packages("lubridate")
library(lubridate)
library(tidyverse)
library(dplyr)
#1 Load the data file into a data frame.

install.packages("openxlsx")
require(openxlsx)
df <- read.xlsx("2013 Geographric Coordinate Spreadsheet for U S  Farmers Markets 8'3'1013.xlsx", startRow = 3)


#2 
# this function outputs a number either 1, 2, 3 based on the string input

# function was created based on the logic, input is each string from the table
# the output is based on the time.  1 if the market is open until 12pm only, 2 if it is all day (from some time in
# the morning to sometime in the afternoon), and 3 if it is afternoon only (only 
# open after 12pm).
timeOutput <- function(String){
  
  ifelse((str_detect(String,"AM")|str_detect(String,"am"))&(str_detect(String,"PM")|str_detect(String,"pm")),
    2,ifelse((str_detect(String,"PM")|str_detect(String,"pm")),3,1))
}
#add the Open column into the table
df <- mutate(df, Open = timeOutput(Season1Time))

#3 Creating a table that the colum shows the open and number
# and with row is the number of markets open during that period.
OpeningTimes <- function(){
  output <- df %>%
  group_by(Open) %>%
  filter(!is.na(Open)) %>%
  summarise(Number = n())
  return(output)
}

#4 the percentage of markets that sell baked good
# function has no inputs
sellsBakedGoods <- function(){
  TrueForGood <-sum(df$Bakedgoods =="Y")
  return(TrueForGood/nrow(df))
}
