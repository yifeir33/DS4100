library(tidyverse)
text <- c("one", "two", "three", NA, "five")

# how many characters in each string?
base::nchar(text)
#> [1]  3  3  5 NA  4
# this works fine
paste("University", "of", "California", "Berkeley")
#> [1] "University of California Berkeley"

# this works fine too
paste("University", "of", "California", "Berkeley")
#> [1] "University of California Berkeley"

# this is weird
paste("University", "of", "California", "Berkeley", NULL)
#> [1] "University of California Berkeley "

# this is ugly
paste("University", "of", "California", "Berkeley", NULL, character(0),
      "Go Bears!")
#> [1] "University of California Berkeley   Go Bears!"


# default usage
str_c("May", "The", "Force", "Be", "With", "You")
#> [1] "MayTheForceBeWithYou"

# str_c removes zero length objects
str_c("May", "The", "Force", NULL, "Be", "With", "You", character(0))
#> [1] "MayTheForceBeWithYou"

# changing separator
str_c("May", "The", "Force", "Be", "With", "You", sep = "_")
#> [1] "May_The_Force_Be_With_You"


some_text <- c("one", "two", "three", NA, "five")

# compare 'str_length' with 'nchar'
nchar(some_text)
#> [1]  3  3  5 NA  4
str_length(some_text)
#> [1]  3  3  5 NA  4
some_factor <- factor(c(1,1,1,2,2,2), labels = c("good", "bad"))
some_factor
#> [1] good good good bad  bad  bad
#> Levels: good bad

# try 'nchar' on a factor
# nchar(some_factor)
#> Error in nchar(some_factor): 'nchar()' requires a character vector

# now compare it with 'str_length'
str_length(some_factor)
#> [1] 4 4 4 3 3 3

## ----str_sub-----------------------------------------
# exract substrings from a string negative number mean go backwards
string <- "now is the time"
str_sub(string, start = 1L, end = -1L)
lorem <- "Lorem Ipsum"

# apply 'str_sub'
str_sub(lorem, start = 1, end = 5)
#> [1] "Lorem"

# equivalent to 'substring'
substring(lorem, first = 1, last = 5)
#> [1] "Lorem"

# another example with 3 different starting positions
str_sub("adios", 1:3)
#> [1] "adios" "dios"  "ios"

resto = c("brasserie", "bistrot", "creperie", "bouchon")

# 'str_sub' with negative positions
str_sub(resto, start = -4, end = -1)
#> [1] "erie" "trot" "erie" "chon"

# compared to substring (useless)
substring(resto, first = -4, last = -1)
#> [1] "" "" "" ""

# before reviewing this read the help page for seq_len()
# extracting sequentially
str_sub(lorem, seq_len(nchar(lorem)))
#>  [1] "Lorem Ipsum" "orem Ipsum"  "rem Ipsum"   "em Ipsum"    "m Ipsum"
#>  [6] " Ipsum"      "Ipsum"       "psum"        "sum"         "um"
#> [11] "m"
substring(lorem, seq_len(nchar(lorem)))
#>  [1] "Lorem Ipsum" "orem Ipsum"  "rem Ipsum"   "em Ipsum"    "m Ipsum"
#>  [6] " Ipsum"      "Ipsum"       "psum"        "sum"         "um"
#> [11] "m"

# reverse substrings with negative positions
str_sub(lorem, -seq_len(nchar(lorem)))
#>  [1] "m"           "um"          "sum"         "psum"        "Ipsum"
#>  [6] " Ipsum"      "m Ipsum"     "em Ipsum"    "rem Ipsum"   "orem Ipsum"
#> [11] "Lorem Ipsum"

# does not understand negative offsets
substring(lorem, -seq_len(nchar(lorem)))
#>  [1] "Lorem Ipsum" "Lorem Ipsum" "Lorem Ipsum" "Lorem Ipsum" "Lorem Ipsum"
#>  [6] "Lorem Ipsum" "Lorem Ipsum" "Lorem Ipsum" "Lorem Ipsum" "Lorem Ipsum"
#> [11] "Lorem Ipsum"


## ----replacing_strings---------------------------------------------------
# replacing 'Lorem' with 'Nullam'
lorem <- "Lorem Ipsum"
str_sub(lorem, 1, 5) <- "Nullam"
lorem
#> [1] "Nullam Ipsum"

# replacing with negative positions
lorem <- "Lorem Ipsum"
str_sub(lorem, -1) <- "Nullam"
lorem
#> [1] "Lorem IpsuNullam"

# multiple replacements
lorem <- "Lorem Ipsum"
str_sub(lorem, c(1,7), c(5,8)) <- c("Nullam", "Enim")
lorem
#> [1] "Nullam Ipsum"  "Lorem Enimsum"

## ----duplicate_strings---------------------------------------------------
times <- 2
string <- "Hello"
str_dup(string, times)
# default usage
str_dup("hola", 3)
#> [1] "holaholahola"

# use with differetn 'times'
str_dup("adios", 1:3)
#> [1] "adios"           "adiosadios"      "adiosadiosadios"

# use with a string vector
words <- c("lorem", "ipsum", "dolor", "sit", "amet")
str_dup(words, 2)
#> [1] "loremlorem" "ipsumipsum" "dolordolor" "sitsit"     "ametamet"

str_dup(words, 1:5)
#> [1] "lorem"                "ipsumipsum"           "dolordolordolor"
#> [4] "sitsitsitsit"         "ametametametametamet"

## ----padding_strings-----------------------------------------------------
string_ex <- "Gandalf"
width <- 20
str_pad(string_ex, width, side = "left", pad = " ")
# what happens if string length is longer than width?
# valid values for side c("left", "right", "both")
str_pad(string_ex, 2, side = "left", pad = " ")
# default usage
str_pad("hola", width = 7)
#> [1] "   hola"

# pad both sides
str_pad("adios", width = 7, side = "both")
#> [1] " adios "

# left padding with '#'
str_pad("hashtag", width = 8, pad = "#")
#> [1] "#hashtag"

# pad both sides with '-'
str_pad("hashtag", width = 9, side = "both", pad = "-")
#> [1] "-hashtag-"

## ----text_formatting-----------------------------------------------------
# format str_wrap(string, width = 80, indent = 0, exdent = 0)
# quote (by Douglas Adams)
some_quote <- c(
  "I may not have gone",
  "where I intended to go,",
  "but I think I have ended up",
  "where I needed to be")

# same_quote in a single paragraph
some_quote <- paste(some_quote, collapse = " ")
# display paragraph with width=30
cat(str_wrap(some_quote, width = 30))
#> I may not have gone where I
#> intended to go, but I think I
#> have ended up where I needed
#> to be

# display paragraph with first line indentation of 2
cat(str_wrap(some_quote, width = 30, indent = 2), "\n")
#>   I may not have gone where I
#> intended to go, but I think I
#> have ended up where I needed
#> to be

# display paragraph with following lines indentation of 3
cat(str_wrap(some_quote, width = 30, exdent = 3), "\n")
#> I may not have gone where I
#>    intended to go, but I think I
#>    have ended up where I needed
#>    to be

## ----trim_strings--------------------------------------------------------
string_ex <- "    Gandalf the Grey    "
str_trim(string_ex, side = "both")
# text with whitespaces
bad_text <- c("This", " example ", "has several   ", "   whitespaces ")

# remove whitespaces on the left side
str_trim(bad_text, side = "left")
#> [1] "This"           "example "       "has several   " "whitespaces "

# remove whitespaces on the right side
str_trim(bad_text, side = "right")
#> [1] "This"           " example"       "has several"    "   whitespaces"

# remove whitespaces on both sides
str_trim(bad_text, side = "both")
#> [1] "This"        "example"     "has several" "whitespaces"

## ----extracting_words----------------------------------------------------
# format word(string, start = 1L, end = start, sep = fixed(" "))
#example
string_ex <- "I am looking for someone to share in an adventure that I am arranging, and it's very difficult to find anyone."
# some sentence
change <- c("Be the change", "you want to be")
change
# extract first word
word(change, 1)
#> [1] "Be"  "you"

# extract second word
word(change, 2)
#> [1] "the"  "want"

# extract last word
word(change, -1)
#> [1] "change" "be"

# extract all but the first words
word(change, 2, -1)
#> [1] "the change" "want to be"

## ----wild_metacharacter--------------------------------------------------
library(htmltools)
library(htmlwidgets)
not <- c("not", "note", "knot", "nut")

str_view(not, "n.t")

## ----locating_patterns---------------------------------------------------
x <- c("abcd", "a22bc1d", "ab3453cd46", "a1bc44d")

# locate 1st sequence of 1 or more consecutive numbers
str_locate(x, "[0-9]+")
str_locate_all(x, "[0-9]+")

## ----escaping_characters-------------------------------------------------
fives <- c("5.00", "5100", "5-00", "5 00")
str_view(fives, "5\\.00")

## ----character_sets------------------------------------------------------
pns <- c('pan', 'pen', 'pin', 'pon', 'pun')

str_view(pns, "p[aeiou]n")

pnx <- c('pan', 'pen', 'pin', 'p0n', 'p.n', 'p1n', 'paun')

str_view(pnx, "p[aeiou]n")

my_lower = "[abcdefghijklmnopqrstuvwxyz]"

# instead of listing all you can use the range character -
my_upper <- "[A-Z]"
basic <- c('1', 'a', 'A', '&', '-', '^')
# digits
str_view(basic, '[0-9]')
# lower case letters
str_view(basic, '[a-z]')
# upper case letters
str_view(basic, '[A-Z]')

triplets <- c('123', 'abc', 'ABC', ':-)')
#matching consecutive characters

str_view(triplets, '[0-9][0-9][0-9]')

str_view(triplets, '[A-Z][A-Z][A-Z]')

## ----negatation_set------------------------------------------------------
# specifying the pattern you do not want
basic <- c('1', 'a', 'A', '&', '-', '^')
str_view(basic, '[^A-Z]')
# the caret must be the first character listed
# this is different than the pattern above
str_view(basic, '[A-Z^]')
str_view(basic, '[A\\-]')

#match everything BUT the caret
str_view(basic, '[^^]')

pnx <- c('pan', 'pen', 'pin', 'p0n', 'p.n', 'p1n', 'paun')
# . metacharacter inside a character set loses its metaness and is just normal character
str_view(pnx, "p[ae.io]n")
#any metacharacter used to define a character set do not follow this rule so the closing bracket, the caret, the minus sign, the backslash

basic <- c('1', 'a', 'A', '&', '-', '^', '[', ']')
str_view(basic, "[a\\^\\-]")


# there are also POSIX character classes that are represented via terms
#alpha matches alphanumeric characters
pnx <- c('pan', 'pen', 'pin', 'p0n', 'p.n', 'p1n', 'paun')
str_view(pnx, "[[:alpha:]]")
str_view(pnx, "[[:alpha:]]+")

# use references \\1 \\2 \\3 to access matched components
head(sentences)
sentences %>%
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>%
  head(5)

head(sentence)
# str_split to define method to break up a string
sentences %>%
  head(5) %>%
  str_split(" ", simplify = TRUE)

ret <- sentences %>%
  head(5) %>%
  str_split(" ")