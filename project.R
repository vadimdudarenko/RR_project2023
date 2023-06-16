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
#Deleting unnecessary columns

matches <- matches_1930_2022[, -c(9, 10, 11, 12, 14,15,18,19,20,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45)]



replace_teams <- function(matches) {
  matches$home_team[matches$home_team %in% c("German DR", "Germany FR")] <- "Germany"
  matches$home_team[matches$home_team == "Soviet Union"] <- "Russia"
  
  matches$away_team[matches$away_team %in% c("German DR", "Germany FR")] <- "Germany"
  matches$away_team[matches$away_team == "Soviet Union"] <- "Russia"
  
  return(matches)
}

#Activate function replace_teams
matches <- replace_teams(matches)


team_name <- list()
index <- 0

for (i in 1:nrow(matches)) {
  name <- matches[i, "home_team"]
  if (!(name %in% names(team_name))) {
    team_name[[name]] <- index
    index <- index + 1
  }
  
  name <- matches[i, "away_team"]
  if (!(name %in% names(team_name))) {
    team_name[[name]] <- index
    index <- index + 1
  }
}

team_name
championships <- table(ifelse(world_cup$Champion == "West Germany", "Germany", world_cup$Champion))
championships

# Chart #1
# It makes a bar chart showing how many World Cup Championships each country has won. The chart is neat and clean with blue bars.
# It tries to add information about the number of championships won by home and away teams in a dataset named matches.
# Create a countplot
ggplot(world_cup, aes(x = Champion)) +
  geom_bar(fill = "steelblue") +
  labs(x = "Country", y = "Number of World Cup Championships") +
  ggtitle("Number of World Cup Championships by Country") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Add new variables to matches data frame
matches$Home_Team_Champions <- 0
matches$Away_Team_Champions <- 0

# Update new variables with championships data
matches$Home_Team_Champions <- ifelse(matches$home_team %in% names(championships), 
                                       championships[matches$home_team], 
                                       0)
matches$Away_Team_Champions <- ifelse(matches$away_team %in% names(championships), 
                                       championships[matches$away_team], 
                                       0)

