# Reproducible research - Final project

Completed for the Reproducible research at the University of Warsaw, Faculty of Economic Sciences, MA in Data Science and Business Analytics program by:

- Ismayil Ismayilov (444459)
- Vadym Dudarenko (444820)
- Ivan Grakhovski (444422)

---

# Project Description
- This project was undertaken as a part of an academic task that required the translation of statistical analysis from one programming language to another. The original study, conducted in Python (see Ref. #1), was translated into R, and the analysis was reproduced. The process offered us an opportunity to understand the nuances of different programming languages and how the same task can be executed differently in each.

## Data Acquisition and Preparation
- The data for this project comes from two CSV files: matches_1930_2022.csv and world_cup.csv(see Ref. #2). The first file contains data on soccer matches from 1930 through 2022, while the second one provides information on World Cup matches.
- In the data preparation phase, unneeded columns from the matches dataset are dropped, focusing on essential match details such as home team, away team, and scores. Teams' names are replaced with appropriate names where necessary. A numeric index is assigned to each unique team name for more manageable data processing.
- Next, the championships won by each team are counted, and new columns, Home_Team_Champions and Away_Team_Champions, are added to the matches dataset, indicating how many times the home and away teams have won championships, respectively.
- The winning team for each match is calculated and added to the dataset as the column Winner.

## Data Analysis
- After data preparation, the dataset is visualized to see the distribution of World Cup championships by country. Next, teams' names are replaced with their corresponding numeric indices. Finally, missing values are replaced with appropriate values.
- The dataset is then split into training and test sets, with 70% of the data used for training the SVM model and 30% used for testing it.

## Modeling
- A Support Vector Machines (SVM) model is used to predict match outcomes. The model is trained on the Winner attribute with other columns as features.

## Model Evaluation
- The model's predictions on both training and test data are computed, and the accuracy of the model is determined by comparing the model's predictions to the actual results. A confusion matrix is generated using the caret package's confusionMatrix() function to provide a detailed evaluation of the model's performance.
- The model's performance is visualized, and a comparison between the predicted and actual results is made. This helps in understanding how well the model has performed in predicting the outcomes of the matches.
- In conclusion, the project demonstrates how machine learning can be applied in the domain of sports analytics to predict soccer match outcomes using SVM.

## Conclusion 
During the project, we applied an updated dataset spanning from 1930 to 2022, surpassing the previous study's coverage from 1930 to 2014. By adopting a similar methodology, we were able to achieve higher accuracy in our results. However, the translation of the code from Python to R presented a few challenges stemming from disparities in syntax, data structures, function creation, data modeling, libraries, and  especially error handling mechanisms. Despite these obstacles, we successfully navigated the differences and accomplished our objectives.   
 
## References
1. https://github.com/imajeetyadav/FIFA-WORLD-CUP-MATCH-DATA-ANALYSIS/blob/master/Project.ipynb
2. https://www.kaggle.com/datasets/piterfm/fifa-football-world-cup?select=world_cup.csv

