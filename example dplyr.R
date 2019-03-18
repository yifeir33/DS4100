
library(tidyverse)

# <- assignment operator
select_diamonds <- select(diamonds,carat,price)
select_diamonds
# change to include other variables such as the variables that describe x,y,z

# sometimes it is easier to specify what you do not want
select(diamonds, -x,-y,-z,-price)

select(diamonds,starts_with("c"))
mode("c")
class("c")
mode(c)

# we have many ways to create a filter greater than, greater than and equal, equal, less than, less than and equal
filter(diamonds, carat > .5)
filter(diamonds, carat >= .5)

filter(diamonds, cut == "Ideal")

filter(diamonds, cut %in% c( "Ideal", "Premium"))
head(diamonds)

# SUMMARY STATISTICS - creating summaries
summarize(diamonds, carat_mean = mean(carat,na.rm=TRUE) )
# functions like min, max, number of rows
summarize(diamonds, carat_mean = mean(carat,na.rm=TRUE),
          carat_median = median(carat,na.rm=TRUE),
          num_observations = n())

# investigate other summary statistics
summarize(group_by(diamonds, cut), carat_mean = mean(carat,na.rm=TRUE) )



#ARRANGE - specify the order of the output - default is ascending order
arrange(diamonds, cut, color)

arrange(diamonds, desc(cut), color)

s <- arrange(diamonds, desc(cut), min_rank(desc(color)))

# ordering functions min_rank(), row_number(), dense_rank(), percent_rank(), cum_dist(), ntile()

# rename a column in the results width is the new name for x
rename(diamonds, width = x)

#reorder diamonds to have x,y,z as the first 3 columns
select(diamonds, x, y, z, everything())

# mutate adds a new column to the result
m1 <- mutate(diamonds, volume = x*y*z)
m2 <- select(m1, volume, carat)
m3 <- filter(m2,color == "Ideal" )

# only variable in the result is the new col. volume
transmute(diamonds, volume = x*y*z)

h <- mutate(diamonds, volume_min = floor(x*y*z))

h2 <- mutate(diamonds, volume = round(x*y*z,1))

band <- mutate(diamonds, volume_min = floor(x*y*z),
               volume_max = ceiling(x*y*z))

?floor
# What are the different diamond colors?
summarize(group_by(diamonds,color))

# How many distinct colors do we have in the dataset?
summarize(diamonds , color_n=n_distinct(color))


# it gets confusing to track the nesting parentheses
summarize(group_by(diamonds, cut ) , color_n=n_distinct(color))
# if we want to know number of diamonds with a specific cut
count(diamonds, weight=cut)

count(diamonds)
# count the number of diamonds with a specific carat
count(diamonds, weight=carat)
# what is the difference here
count(diamonds, carat)

# another method
count(select(diamonds, cut, carat))
# Pipes makes it easier to define the necessary transformations for the data
# in this example wt is an argument to count, performing a weighted tally - which is typically what you want to do
diamonds %>% count(cut, wt=carat)