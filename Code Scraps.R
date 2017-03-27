
# Log loss 
logloss <- 0 
for(obs in 1:nrow(y_test)){
  pij <- predicted[obs, paste(y_test[obs])
  logloss <- logloss + pij  
}

######
# Random Forest convert to confusion matrix (failed) code
 as.matrix(as.nnumeric(rf_tree_err[1,2:13], nrow = 3, ncol = 4))
###########
# Think parallel 
rf <- foreach(ntree=seq(100, 1000, by = 100), .combine=combine, .multicombine=TRUE,
              .packages='randomForest') %dopar% {
                randomForest(x_train, y_train, ntree=ntree)
              }
