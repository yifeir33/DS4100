##########################################################################################
##  Collecting Twitter Data from Streaming API
## To run this script, you need to generate your own "consumerKey", "consumerSecret", and
## an oAuth token by ##registering your application with Twitter. It is a simple process,
## just pick a name for your application. ##Register it here: https://dev.twitter.com/apps
##
## Documentation of Twitter Streaming API:
##   https://dev.twitter.com/docs/streaming-apis/streams/public
##   https://dev.twitter.com/docs/auth/authorizing-request
##   http://www.foundations-edge.com/blog/oauth_in_R.html
##   https://dev.twitter.com/docs/streaming-apis/processing
##
##########################################################################################

## Change working directory

# Load required libraries
library(RCurl)
library(ROAuth)
library(streamR)
library(twitteR)
library(ROAuth)
library(rtweet)


#download certificate needed for authentication, creates a certificate file on desktop
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")

# Configuration for twitter
#create a file to collect all the Twitter JSON data recevied from the API call
outFile <- "tweets_sample4.json"
# Twitter configuration
# Set all the Configuration details to authorize your application to access Twitter data.
requestURL        <- "https://api.twitter.com/oauth/request_token"
accessURL         <- "https://api.twitter.com/oauth/access_token"
authURL           <- "https://api.twitter.com/oauth/authorize"
consumerKey       <- "E9nZ1lbwwt3ENfxHFQONCRCHv"
consumerSecret    <- "PsWawAduWgRLzTe9dSiYBAqMQimx0w4b9XqCFuk624NoSVPlVl"
accessToken       <- "34430979-xYrn01anOvmlU3VaejzByczWOsjsywYHCtI4OydV8"
accessTokenSecret <- "UffCwJiQMwDxy0XQ5EWWVwyihvi5hGlVpgvF0oQ6nQUqT"


#obtain oauth by handshaking and save the oauth to the local disk for future connections
my_oauth <- OAuthFactory$new( consumerKey=consumerKey,
                              consumerSecret=consumerSecret,
                              requestURL=requestURL,
                              accessURL=accessURL,
                              authURL=authURL)
# returns the oauth
my_oauth$handshake(cainfo="cacert.pem")

##########################################################################################
## PAUSE HERE !!!!!
## Once executing the above code returns true, you will be given a link to authorize your
## application to get twitter feeds. Copy the link in your browser. Click on "Authorize
## MyApplication." You will receive a pin number. Copy the pin number and paste it in the
## console. Once your application has been authorized you need to register your credentials.
##########################################################################################

# set up the OAuth credentials for a twitterR session
setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessTokenSecret)

# Press 1 in the console to allow the file to access the credentials

rstats_tweets <- search_tweets(q = "#rstats",
                               n = 500)
# view the first 3 rows of the dataframe
head(rstats_tweets, n = 3)

pol_tweets <- search_tweets(q = "#kavanaugh",
                            n = 50)
head(pol_tweets, n = 4)
users_data(pol_tweets)

us_tweets <-search_tweets("lang:en", geocode=lookup_coords("usa"), n =2000)
us_tweets<- lat_lng(us_tweets)
par(mar = c(0,0,0,0))
maps::map('state', lwd=.25)
with(us_tweets, points(lng, lat, pch = 20, cex = .75, col = rgb(0, .3, .7, .75)))

ts_plot(pol_tweets)
pol_noretweets <- search_tweets("#kavanaugh", n = 50,
                                include_rts = FALSE)

# view the first 3 rows of the dataframe
head(pol_noretweets, n = 4)

# collect sample of tweets defaut time = 30 seconds
stream_t <- stream_tweets("")
#requires a Google Maps API key
boston <- stream_tweets(lookup_coords("boston, usa"))

stream_tweets(
  "realdonaldtrump,trump",
  timeout = 30,
  file_name = "tweetsabouttrump.json",
  parse = FALSE
)

## read in the data as a tidy tbl data frame
djt <- parse_stream("tweetsabouttrump.json")

# get followers for a specific account
## get user IDs of friends of CNN
jobi_fds <- get_friends("Jobi_Pottery")

## lookup data on those accounts
jobi_fds_data <- lookup_users(cnn_fds$user_id)

## lookup followers of an account
## get user IDs of accounts following Jobi Pottert
## limit it to the first 75,000
jobi_flw <- get_followers("Jobi_Pottery", n = 75000)

## lookup data on those accounts
jobi_flw_data <- lookup_users(jobi_flw$user_id)


tmls <- get_timelines(c("cnn", "BBCWorld", "foxnews"), n = 3200)

## plot the frequency of tweets for each user over time
tmls %>%
  dplyr::filter(created_at > "2017-10-03") %>%
  dplyr::group_by(screen_name) %>%
  ts_plot("days", trim = 1L) +
  ggplot2::geom_point() +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    legend.title = ggplot2::element_blank(),
    legend.position = "bottom",
    plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of Twitter statuses posted by news organization",
    subtitle = "Twitter status (tweet) counts aggregated by day from Aug to October 2018",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )
# get recently favored statuses
jkr <- get_favorites("jk_rowling", n = 300)

# search for a hashtag in a profile biography
## search for users with #rstats in their profiles
usrs <- search_users("#rstudio", n = 1000)
usrs <- search_users("#r,data visualization", n = 1000)

# trenda for a location
sf <- get_trends("boston")

## lookup users by screen_name or user_id
users <- c("KimKardashian", "justinbieber", "taylorswift13",
           "espn", "JoelEmbiid", "cstonehoops", "KUHoops",
           "upshotnyt", "fivethirtyeight", "hadleywickham",
           "cnn", "foxnews", "msnbc", "maddow", "seanhannity",
           "potus", "epa", "hillaryclinton", "realdonaldtrump",
           "natesilver538", "ezraklein", "annecoulter")
famous_tweeters <- lookup_users(users)

## preview users data
famous_tweeters

# extract most recent tweets data from the famous tweeters
tweets_data(famous_tweeters)
## lookup users by screen_name or user_id
users <- c("KimKardashian", "justinbieber", "taylorswift13",
           "espn", "JoelEmbiid", "cstonehoops", "KUHoops",
           "upshotnyt", "fivethirtyeight", "hadleywickham",
           "cnn", "foxnews", "msnbc", "maddow", "seanhannity",
           "potus", "epa", "hillaryclinton", "realdonaldtrump",
           "natesilver538", "ezraklein", "annecoulter")
famous_tweeters <- lookup_users(users)

## preview users data
famous_tweeters

# extract most recent tweet data from the famous tweeters

hadley <- lookup_users("hadleywickham")