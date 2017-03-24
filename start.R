
# Import and load libraries 
packages <- c("jsonlite", "dplyr", "purrr", "tibble", "plotly")
purrr::walk(packages, library, character.only = TRUE, warn.conflicts = FALSE)

# Load data 
data <- fromJSON("input/train/train.json")

vars <- setdiff(names(data), c("photos", "features"))
data <- map_at(data, vars, unlist) %>% tibble::as_tibble(.)

data_df <- as.data.frame(data)
head(data_df)

colnames(data_df)

quick_cols <- c("bathrooms", "bedrooms", "longitude", "latitude", "price", "interest_level")

new_df <- data_df[ , quick_cols, drop = FALSE]
# New Feature to combine lat x long 
new_df$lat_long <- new_df$latitude * new_df$longitude 
new_df$interest_level <- as.factor(new_df$interest_level)
new_df <- as.data.frame(model.matrix(~., data = new_df))

colnames(new_df)
# Note interest level high would be 0 (?) in both cases 
# So we have high  = 0 and low/medum = 1


# Create training data set 
n_obs <- nrow(new_df)
test_size_percent <- 0.75
sample_rows <- sample(n_obs, test_size_percent*n_obs)
train_df <- new_df[sample_rows, ]
test_df <- new_df[-sample_rows, ]

# Train logisitic regression 
fitlow <- glm(interest_levellow ~. -interest_levelmedium ,family = "binomial", data = train_df )

summary(fitlow)

fitmedium <- glm(interest_levelmedium ~. -interest_levellow ,family = "binomial", data = train_df )

summary(fitmedium)


# Test set predictions 
test_pred <- predict.glm(fitmedium, test_df, type = "response")
hist(test_pred)
# Most predictions are on side of 0 (high)


# Test set predictions 
test_pred <- predict.glm(fitlow, test_df, type = "response")
hist(test_pred)
# 




head(data$description,10)







