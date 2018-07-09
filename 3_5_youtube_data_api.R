# library(jsonlite)
library(tidyverse)
library(jsonlite)
library(rvest)
library(httr)
options(stringsAsFactors = F)


api_key <- "AIzaSyBKfW1tJjg52cF2ivkXUYN_zezet6ZDZjk"




# Get playlists of a channel ----------------------------------------------
channelid <- "UCvsye7V9psc-APX6wV1twLg"

# https://developers.google.com/apis-explorer/#p/youtube/v3/youtube.playlists.list?part=snippet,contentDetails&channelId=UC_x5XG1OV2P6uZZ5FSM9Ttw

playlist_to_tibble <- function(res){
    tibble(kind = res$items$kind,
           listid = res$items$id,
           channelTitle <- res$items$snippet$channelTitle,
           timestamp = res$items$snippet$publishedAt,
           channelid = res$items$snippet$channelId,
           listtitle = res$items$snippet$title,
           nvideo = res$items$contentDetails$itemCount
    )
}

plist.list <- list()
url <- paste0("https://www.googleapis.com/youtube/v3/playlists?maxResults=25&channelId=", channelid,
              "&part=snippet%2CcontentDetails&key=", api_key)
res <- fromJSON(content(GET(url), "text", encoding = "utf-8"))
plist.list[[1]] <- playlist_to_tibble(res)
npages <- res$pageInfo$totalResults %/% res$pageInfo$resultsPerPage + 1

for(i in 2:npages){
    print(i)
    url.next <- paste0("https://www.googleapis.com/youtube/v3/playlists?maxResults=25&channelId=", channelid,
                       "&pageToken=", res$nextPageToken,
                       "&part=snippet%2CcontentDetails&key=", api_key)
    res <- fromJSON(content(GET(url.next), "text", encoding = "utf-8"))
    plist.list[[i]] <- playlist_to_tibble(res)
}
plist.df <- bind_rows(plist.list)

plist.df %>% count(listid, sort = T) %>% View()



# Get videos of a playlist ------------------------------------------------

video_to_tibble <- function(res){
    tibble(kind = res$items$kind,
           vid = res$items$id,
           timestamp = res$items$snippet$publishedAt,
           channelid = res$items$snippet$channelId,
           vtitle = res$items$snippet$title,
           listid = res$items$snippet$playlistId,
           position = res$items$snippet$position,
           videoid = res$items$contentDetails$videoId,
           vtimestamp = res$items$contentDetails$videoPublishedAt
    )
}

allvideo.list <- list()
# for(p in 1:length(plist.df$listid)){
for(p in 1){
    message("...... p = ", p)
    plistid <- plist.df$listid[[p]]
    video.list <- list()
    url <- paste0("https://www.googleapis.com/youtube/v3/playlistItems?playlistId=", plistid,
                  "&maxResults=25",
                  "&part=snippet%2CcontentDetails",
                  "&key=", api_key)
    res <- fromJSON(content(GET(url), "text", encoding = "utf-8"))
    if(is.null(res$items)) next
    video.list[[1]] <- video_to_tibble(res)
    
    res$nextPageToken
    npages <- res$pageInfo$totalResults %/% res$pageInfo$resultsPerPage + 1
    
    for(i in 2:npages){
        message("video:", i)
        url.next <- paste0("https://www.googleapis.com/youtube/v3/playlistItems?playlistId=", plistid,
                           "&pageToken=", res$nextPageToken,
                           "&maxResults=25",
                           "&part=snippet%2CcontentDetails",
                           "&key=", api_key)
        res <- fromJSON(content(GET(url.next), "text", encoding = "utf-8"))
        video.list[[i]] <- video_to_tibble(res)
    }
    allvideo.list[[p]] <- bind_rows(video.list)
}

allvideo.df <- bind_rows(allvideo.list)

count(allvideo.df, channelid)
View(res)




