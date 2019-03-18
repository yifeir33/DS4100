library("rvest")
library("tidyverse")
google_news <- read_html("https://news.google.com/?hl=en-US&gl=US&ceid=US:en")

google_news %>% html_nodes(".ICsaqd") %>% html_text()

#open one of the imdb movies
imdb <- read_html("https://www.imdb.com/title/tt1517451/?ref_=inth_ov_tt")


#Practice Problems
# 1. extract the genre from the movie
genre <- imdb %>%
  html_node(".see-more.canwrap~ .canwrap a") %>%
  html_text() %>%
  str_trim()

  
# 2. extract the plot key words
imdb %>%

#3 select the country of origin

#4 select the director

#5 select the rating

#6 select the rating and the max rating

#7 select the cast, clean up the extracted strings


#8 extract the length of the movie clean up the text


#9 extract the movie's release date


#10 extract the country of release