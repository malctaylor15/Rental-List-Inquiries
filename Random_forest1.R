# Random forest algorithm grid searching through # of tree parameter  

source("Sampling3.R")
############################################
## Start Random Forest 
############################################
#install.packages("randomForest")
library(randomForest)

# Data prep for random forest 
y_train <- train_df$interest_level
x_train <- train_df
# Remove dependent variable
x_train$interest_level <- NULL

# Number of of trees 
numb_tree <- 10
# Pre allocate space for random forest 
rf_tree_err <- data.frame(matrix(0, ncol = 14, nrow = numb_tree))
# Rename columns -- really should not have the out error rate 
names(rf_tree_err)[1:14] <- c("Numb Trees", "hh", "hl", "hm", 
                             "lh", "ll", "lm", "mh", "ml", "mm", 
                             "h_ce", "l_ce", "m_ce", "accuracy")

# Look for best number of tree parameter for random forest 
for (index in 1:numb_tree){
  # Number of trees to use in algorithm 
  numb_trees_rf <- 100*index
  # Fit random forest 
  fit_temp <- randomForest(x_train, y_train, ntree = numb_trees_rf)
  # Temporary confusion matrix for in sample 
  rf_conf_train <- fit_temp$confusion
  # Store in data frame 
  rf_tree_err[index, 1:13] <- c(numb_trees_rf, rf_conf_train[1:12]) 
}


# Accuracy column 
#rf_tree_err$accuracy <- apply(rf_conf_train, 1, function(x) sum(rf_conf_train[x, c(2,5,9)])/sum(rf_conf_train[x, 1:9]))

# Look at error rate vs. Number of tree 
plot(rf_tree_err$`Numb Trees`, rf_tree_err$h_ce, main = "Number of Trees vs Accuracy",
     type = "l", ylim = c(0.1,0.7))
lines(rf_tree_err$`Numb Trees`, rf_tree_err$l_ce, type = "l", col = "red")
lines(rf_tree_err$`Numb Trees`, rf_tree_err$m_ce, type = "l", col = "blue")

max(rf_tree_err$l_ce)

rf_err_fit <- lm( h_ce~`Numb Trees`, data = rf_tree_err)
abline(rf_err_fit, col = "blue", lwd= 4)
abline(h = 1-high_low_ratio_train, col = "red", lwd = 4) # at 0.65
legend("topright",  c("Regression error fit", "Error Rate Training set"), col = c("blue", "red"), lwd = 4)
