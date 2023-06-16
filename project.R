####Upload necessary packages####

install.packages("e1071")
library(e1071)
library(caret)
library(dplyr)
library(tidyverse)
library(ggplot2)

####Loading data######

matches_1930_2022 <- read.csv("matches_1930_2022.csv")
world_cup <- read.csv("world_cup.csv")

####Data preparation###

matches <- matches_1930_2022[, -c(9, 10, 11, 12, 14,15,18,19,20,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45)]



replace_teams <- function(matches) {
  matches$home_team[matches$home_team %in% c("German DR", "Germany FR")] <- "Germany"
  matches$home_team[matches$home_team == "Soviet Union"] <- "Russia"
  
  matches$away_team[matches$away_team %in% c("German DR", "Germany FR")] <- "Germany"
  matches$away_team[matches$away_team == "Soviet Union"] <- "Russia"
  
  return(matches)
}
