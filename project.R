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

# This R script adds a Winner column to matches, determines match outcomes (draw, home win, away win), 
# and then counts each outcome's frequency.
matches$Winner <- "-"
calculate_winner <- function(matches) {
  home_team_goal <- as.integer(matches$home_score)
  away_team_goal <- as.integer(matches$away_score)
  matches$Winner <- ifelse(home_team_goal == away_team_goal, 0, ifelse(home_team_goal > away_team_goal, 1, 2))
  
  return(matches)
}
matches <- calculate_winner(matches)
table(matches$Winner)

#This R script replaces team names in the `matches` dataset, trims unnecessary columns,
# pulls specific ranking data from the `fifa_ranking_2022.10.06` dataset,
#adds new rank columns to `matches`, and replaces any NA values in championship columns with zeros.
replace_team_name <- function(matches) {
  matches$home_team <- team_name[matches$home_team]
  matches$away_team <- team_name[matches$away_team]
  return(matches)
}

matches <- replace_team_name(matches)

matches <- matches[, -c(5, 8, 9, 10, 11, 12, 13)]

matches$Away_Team_Champions <- ifelse(is.na(matches$Away_Team_Champions), 0, matches$Away_Team_Champions)
matches$Home_Team_Champions <- ifelse(is.na(matches$Home_Team_Champions), 0, matches$Home_Team_Champions)

# The code below prepares data for a machine learning model. First, it defines the target variable
# 'Winner' and the predictor variables from a data frame called 'matches', excluding some specific columns.
# The champion team columns are then converted to numeric data types. Any lists within the 'away_team' and
# 'home_team' columns are flattened into vectors. It handles missing values in the 'home_xg' and
# 'away_xg' columns by replacing them with the mean values of their respective columns. 
# Finally, the data is split into a training set and a test set, with approximately 70% of the data used for training and 30% used for testing.


# Convert champion columns to numeric
matches$Home_Team_Champions <- as.numeric(matches$Home_Team_Champions)
matches$Away_Team_Champions <- as.numeric(matches$Away_Team_Champions)

# Unlist team columns
matches$away_team <- unlist(matches$away_team)
matches$home_team <- unlist(matches$home_team)

# Replace NA values in home_xg and away_xg columns with mean values
mean_value <- mean(matches$home_xg, na.rm = TRUE)
matches$home_xg <- ifelse(is.na(matches$home_xg), mean_value, matches$home_xg)
mean_value1 <- mean(matches$away_xg, na.rm = TRUE)
matches$away_xg <- ifelse(is.na(matches$away_xg), mean_value1, matches$away_xg)

# Create training and test datasets with approximately 70% training, 30% test
sample <- sample(c(TRUE, FALSE), nrow(matches), replace=TRUE, prob=c(0.7,0.3))
train <- matches[sample, ]
test <- matches[!sample, ]  
