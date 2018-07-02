# Install and import essential packages -----------------------------------

# library(tidyverse) will import ggplot2, dplyr, tidyr, readr, purrr, and tibble
# Need to library 
# readxl	for .xls and .xlsx sheets.
# haven 	for SPSS, Stata, and SAS data.
# jsonlite 	for JSON.
# xml2 		for XML.
# httr 		for web APIs.
# rvest 	for web scraping.
# stringr 	for strings.
# lubridate	for dates and date-times.
# forcats	for categorical variables (factors).
# hms		for time-of-day values.
# blob		for storing blob (binary) data.

# packages for lecture hand-in-hand R
pkgs <- c("tidyverse", "jiebaR", "data.table", "text2vec", 
		  "fmsb", "rpart", "randomForest", "ggmap", 
		  "zoo", "rtweet", "tidytext", "tm", "wordcloud", 
		  "igraph", "rgexf", "topicmodels", "RTextTools", 
		  "tidyr", "DT")

# excluded packages not in the computer
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])] 
if(length(pkgs)) install.packages(pkgs)