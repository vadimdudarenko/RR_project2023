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
