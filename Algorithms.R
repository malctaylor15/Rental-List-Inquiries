# Get the data tables
source("Sampling3.R")

# H2o practice Tutorial link below 
# https://www.analyticsvidhya.com/blog/2016/05/h2o-data-table-build-models-large-data-sets/


# Get packages necessary 
packages <- c("data.table", "h2o")
purrr::walk(packages, library, character.only = TRUE, warn.conflicts = FALSE)

# Start H2o 
h2o.init(nthreads = -1)

# Turn data frames into h2o objects 
train.h2o <- as.h2o(train_df)
test.h2o <- as.h2o(test_df)

# Will need to refer to things by index 
colnames(train.h2o)
colnames(test.h2o)

# Interest level is 7 
y.index <- 7 
x.index <- c(1:6,8:10)

#######################################################################
 #################### ALGORITHMS #####################################
  ###################################################################

# Logistic Regression 
log.reg <- h2o.glm(y = y.index, x = x.index, training_frame = train.h2o, validation = test.h2o, family = "multinomial")
h2o.performance(log.reg)

log.predictions <- as.data.frame(h2o.predict(log.reg, test.h2o))
h2o.performance(log.reg)

h2o.logloss(log.reg)


# Random Forest

rforest <- h2o.randomForest(y = y.index, x = x.index, training_frame = train.h2o, ntrees = 1000, mtries = 3, max_depth = 4, seed= 12)

h2o.performance(rforest)
h2o.logloss(rforest)
h2o.varimp(rforest)

hyper_params_list <- list(ntrees = seq(from = 500, to = 2000, by= 200), 
                          max_depth = c(3:8), 
                          min_rows = seq(from = 1, to = 11, by = 2))

search_criteria_list <- list(strategy = "RandomDiscrete", max_models = 60, 
                             stopping_metric = "logloss", stopping_tolerance = 0.0001,
                             stopping_rounds = 7, seed = 12)
  
rf.grid <- h2o.grid("randomForest", grid_id = "rf_grid", y = y.index, x = x.index, 
                    training_frame = train.h2o,
                    hyper_params = hyper_params_list,
                    search_criteria = search_criteria_list)
# Find rf.grid id.... 
rf.sorted.grid <- h2o.getGrid(grid_id = "rf_grid", sort_by = "logloss")
print(rf.sorted.grid)
best_model <- h2o.getModel(rf.sorted.grid@model_ids[[1]])
summary(best_model)


rf.predictions <- as.data.frame(h2o.predict(best_model, test.h2o)) 

# GBM 

gbm.model <- h2o.gbm(y = y.index, x = x.index, training_frame = train.h2o, ntrees = 1000, max_depth = 5, learn_rate = 0.01, seed = 12)

h2o.performance(gbm.model)
h2o.varimp(gbm.model)
h2o.logloss(gbm.model)

hyper_params_gbm_list <- list(ntrees = seq(from = 500, to = 2100, by= 400), 
                          max_depth = seq(from =4, to = 20, by= 5), 
                          #learn_rate = c(0.01, 0.001, 0.0001),
                          min_rows = seq(from = 2, to = 14, by = 3))

search_criteria_list <- list(strategy = "RandomDiscrete", max_models = 60, 
                             stopping_metric = "logloss", stopping_tolerance = 0.0001,
                             stopping_rounds = 7, seed = 12,
                             max_runtime_secs = 1800)

gbm.grid <- h2o.grid("randomForest", grid_id = "gbm_grid", y = y.index, x = x.index, 
                    training_frame = train.h2o, hyper_params = hyper_params_gbm_list, 
                    search_criteria = search_criteria_list)
gbm.sort.grid <- h2o.getGrid(grid_id = "gbm_grid", sort_by = "logloss")
best_gbm <- h2o.getModel(gbm.sort.grid@model_ids[[1]])
summary(best_gbm)

gbm.grid.df <- as.data.frame(gbm.sort.grid)

gbm.predictions <- as.data.frame(h2o.predict(best_gbm, test.h2o))




#h2o.shutdown(prompt = F)


