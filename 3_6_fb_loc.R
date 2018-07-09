
library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)
# library(rjson)

options(fileEncoding = "utf-8")
options(encoding = "UTF-8")
options(stringsAsFactors = FALSE)
Sys.setenv(TZ="Asia/Taipei")


# My function to get longer token -----------------------------------------

get_fb_token <- function(){
    app_id <- "188730144854871"
    app_secret <- "8761f7c2146b01c5332dbb1fcf386b3b"
    url <- sprintf('https://graph.facebook.com/oauth/access_token?grant_type=client_credentials&client_id=%s&client_secret=%s&extended_permissions=TRUE', app_id, app_secret)
    text <- content(POST(url),'text')
    res <- fromJSON(text)
    print(sprintf("Getting token: %s", res$access_token))
    res$access_token
}

token <- get_fb_token()




# My function - flatten data ----------------------------------------------
# Origianl return data are tree-like list.
# However, the design of data.frame is suitable for tree only depth = 1

flatten_data <- function(df){
    df$category <- sapply(df$category_list, function(x){paste(x$name, collapse = ",")})
    df$category_list <- NULL
    # df$pic.url <- df$picture$data$url
    # df$picture <- NULL
    df$engage.count <- df$engagement$count
    df$engage.text <- df$engagement$social_sentence
    df$engagement <- NULL
    df
}



# Main crawler ------------------------------------------------------------
# Search location
# facebook api https://developers.facebook.com/docs/places/search

latlng <- "22.4297515,120.5092405"
distance <- 2000


all.list <- list()
i <- 1


url <- sprintf(
    "https://graph.facebook.com/v3.0/search?type=place&center=%s&distance=%s&fields=name,checkins,category_list,rating_count,engagement,fan_count&access_token=%s", latlng, distance, token)
res <- fromJSON(content(GET(url),'text'))
all.list[[i]] <- flatten_data(res$data)
print("Get page 1")


# crawl following pages
nexturl <- res$paging$"next"
while(!is.null(nexturl)){
    i <- i + 1
    res <- fromJSON(content(GET(nexturl),'text'))
    all.list[[i]] <- flatten_data(res$data)
    nexturl <- res$paging$"next"
    print(sprintf("Get page %d", i))
}

# Binding all data
all.df <- bind_rows(all.list)
all.df %>% View

write.csv(all.df, file = "test.csv")
