library(tidyverse)
library(lubridate)
#1 Load the data file "BirdStrikes" into an appropriate 
# data object of your choice.
BS <- read.csv("Bird Strikes.csv", header = TRUE)

#2 the year which had the most bird strike incidents.

mostStrikesInaYear <- function(){
  groupInFormat<- as.Date(BS$FlightDate, "%m/%d/%Y %H:%M")
  groupInYear <- year(groupInFormat)
  BS <- mutate(BS, yearOfStrikes = groupInYear)
  output <- BS %>%
    group_by(yearOfStrikes) %>%
    summarise(number = n()) %>%
  filter(number == max(number))
  return(output[1,1])
}

#3 a dataframe containing for each year the number of bird strike incidents. 

strikesByYear <- function(){
  groupInFormat<- as.Date(BS$FlightDate, "%m/%d/%Y %H:%M")
  groupInYear <- year(groupInFormat)
  BS <- mutate(BS, yearOfStrikes = groupInYear)
  output <- BS %>%
    group_by(yearOfStrikes) %>%
    summarise(number = n()) 
  return(output)
}


#4 the number of birds strike incidents per type of wildlife (excluding unkown)
# in a dataframe. Store the return result in a dataframe called Strikes.
strikesByType <-function(){
  output2 <- BS %>%
    filter(!grepl( "Unknown", Wildlife..Species )) %>%
    group_by(Wildlife..Species) %>%
    summarise(number = n())
  return(output2)
  
}
#this is the name to make the dataset called Strikes
Strikes <- strikesByType()

#5  the type of wildlife that caused the most bird strike incidents.
# in here the input should be strikes
# Argument:strikes
# output type: first line of a table
mostStrikes <- function(Strikes){
  outputWildlife <- Strikes %>%
    filter(number == max(number)) %>%
    top_n(n=1)
     return(outputWildlife)
}

#6 For the function mostStrikes() use system.time() to measure the 
# execution time for the original sized data, 20 times the original 
# size and 40 times the original size, etc. by duplicating the data 
# set (you may need quite large data sets if you have a fast computer).
# Write a short report that describes your approach and includes a chart 
# that visualizes the runtime curve (you may do the chart in Excel or R).
# Based on the curve, find the complexity of the function and define big-O.
# Hint: Consider using the rbind() function to concatenate data frames.
Runtime <- system.time(mostStrikes(Strikes))
#0.02
Times2<- rbind(Strikes, Strikes)
Times4<- rbind(Times2, Times2)
Times8<- rbind(Times4,Times4)
Times10<- rbind(Times2,Times8)
Times20<- rbind(Times10,Times10)
Times40<- rbind(Times20,Times20)
Times80<- rbind(Times40,Times40)
Times160<- rbind(Times80,Times80)
Times320<- rbind(Times160,Times160)
Times640<- rbind(Times320,Times320)
Times1280<- rbind(Times640,Times640)
Times2560<- rbind(Times1280,Times1280)
Times5120<- rbind(Times2560,Times2560)
system.time(mostStrikes(Times2))
#0.03
system.time(mostStrikes(Times4))
#0.02
system.time(mostStrikes(Times8))
#0.01
system.time(mostStrikes(Times10))
#0.02
system.time(mostStrikes(Times20))
#0.02
system.time(mostStrikes(Times40))
#0.02
system.time(mostStrikes(Times80))
#0.02
system.time(mostStrikes(Times160))
#0.04
system.time(mostStrikes(Times320))
#0.05
system.time(mostStrikes(Times640))
#0.07
system.time(mostStrikes(Times1280))
#0.021
system.time(mostStrikes(Times2560))
#0.047
system.time(mostStrikes(Times5120))
#0.081
#the example i had
datafor6 <-data.frame(numberofset = c(1,2,4,8,10,20,40,80,160,320,640,1280,2560,5120),
                      runtime =c(0.002,0.003,0.002,0.001,0.002,0.002,
                        0.002,0.002,0.004,0.005,0.007,0.021,0.047,0.081))
runtimeCurve <- plot(datafor6$numberofset, datafor6$runtime, type ="o", xlab = "Sizes", 
                       ylab = "Runtime", main = "Sizes vs Runtime")
# short report
# The complexiety of the function should be grown as linear, the example
# we used showing that the input double and the runtime doubles as well.
# The answer is bigO = n, because when we see at the end of chart it is being more 
# obvious, the size of input doubles from 640 times into 1280 times,
# and the output of runtime doubles as well from 0.021 to 0.047.
