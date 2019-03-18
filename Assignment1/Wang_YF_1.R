#1 Load the data file into an appropriate data object of your choice.
AD <- read.csv("AirlineDelays.txt", header = TRUE)

#2 average arrival delay of the carrier 
# exclude any missing or negative (early) arrival delay
# argument is the Carrier's name, such as AA
library(dplyr)
AvgArrDelayByCarriers <- function(Carrier){
  isPositive <- filter(AD, ARR_DELAY >= 0, CARRIER == Carrier)
  isPositive <- mean(isPositive$ARR_DELAY)
  return(isPositive)
}

#3 the probability of a departure 
# delays for a particular airport. The probability is the fraction of
# delayed flights devided bt all Flights
# the argument is the Original airport
ProbDepartureDelaysByOrigin <- function(Origin){
  delayFlights <- filter(AD, DEP_DELAY>0 & ORIGIN == Origin)
  allFlights <- filter(AD, ORIGIN == Origin & !is.na(DEP_DELAY))
  output <- nrow(delayFlights) / nrow(allFlights)
  return(output)
}

#4 the average arrival delay in minutes between two airports.
# NA will be treated as 0
# The argument is the two airports: departure and destination

AvgFlightDelay <- function(Dep, Dest){
  arrivalDelay <- filter(AD, Dep == ORIGIN, Dest == DEST)
  arrivalDelay[is.na(arrivalDelay)] <- 0
  output <- mean(arrivalDelay$ARR_DELAY)
  return(output)
}

