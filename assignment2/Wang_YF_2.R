# needed libraries
install.packages("xts")
install.packages("zoo")
library("zoo")
library("xts")
library("tidyverse")
#1 Locate the data set and load the data into R.
CD <- read.csv("customertxndata.csv", col.names = 
                 c("Visits","Transactions","System","Gender","Revenue"), header = FALSE)
#2 total number of cases, mean number of visits, median revenue, maximum 
# and minimum number of transactions, most commonly used operating system. 
# Exclude any cases where there is a missing value.
TotalNumberOfCase <- nrow(CD)
MeanNumberOfVisits <- mean(CD$Visits,na.rm = TRUE)

MedianRevenue <- median(CD$Revenue, na.rm = TRUE)
MaximumNumberOfTransaction <- max(CD$Transactions, na.rm = TRUE)
MinimumNumberOfTransaction <- min(CD$Transactions, na.rm = TRUE)
MostCommonlyUsedSystem <- CD %>% 
  group_by(System) %>% 
  summarise(count = n()) %>%
  top_n(n=1)

#3  Create a scatterplot of visits (x-axis) versus revenue (y-axis)
#create a scatterplot has name visits vs revenue..
VisitVsRevenue <- plot(CD$Visits, CD$Revenue, xlab = "number of visits", 
                    ylab = "revenue", main = "Visits vs revenue")

#4 Impute missing transaction and gender values.
imputed_CD <- CD #created a new table to make change
#fill in the transactions with the average of the others
fillNATransaction <- round(mean(CD$Transactions, na.rm = TRUE), digits = 0)
imputed_CD$Transactions[is.na(imputed_CD$Transactions)] <- fillNATransaction
#fill in the NA gender with the one above it
imputed_CD$Gender <-na.locf(imputed_CD$Gender)


#5 Split the data set into two equally sized data sets where one can be used for training a model
#and the other for validation. Take every even numbered case and add them to the training data 
#set and every even odd case and add them to the validation data set, i.e., row 1, 3, 5, 7, etc.
#are validation data while rows 2, 4, 6, etc. are training data.
oddNumberList <- seq(from = 1,to =TotalNumberOfCase, by = 2) #making odd index
evenNumberList <- seq(from = 0, to = TotalNumberOfCase, by = 2) #making even index
ValidationData <- imputed_CD[evenNumberList,]
TrainingData <- imputed_CD[oddNumberList,]

#6 Split the data set into two equally sized data sets where one can be used for training a model
# and the other for validation. Take a random set of cases equal to 50% of the data set and make
# that the training data subsets. Assign the unselected cases for the validation data subset.
randomIndex1 <- sample(1:TotalNumberOfCase, TotalNumberOfCase*0.5, replace = FALSE)
TrainingData2 <- imputed_CD[randomIndex1,]
randomIndex2 <- setdiff(1:TotalNumberOfCase, randomIndex1) # the subset of the others
ValidationData2 <- imputed_CD[randomIndex2,]

#7 Calculate the mean revenue for each of the four data sets and compare them.
Revenue_TD1 <- mean(TrainingData$Revenue) #449.61
Revenue_TD2 <- mean(TrainingData2$Revenue) #456.01
Revenue_VD1 <- mean(ValidationData$Revenue) #460.26
Revenue_VD2 <- mean(ValidationData2$Revenue) #453.86

# Comparision of the four datasets:
# TD1<VD2<TD2<VD1
# Training dataset 1(even number list index dataset) has the least average revenue,
# Validation dataset 1 (odd number list index dataset) has the largest average revenue