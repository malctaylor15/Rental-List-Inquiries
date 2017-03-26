# Make Suggestions from data cleaning 
# Prepare data set for analysis 

# Import data set 
source("Dataframe_Cleaning1.R")
source("Data_Cleaning2.R")
summary(new_df)

# Remove outlier (ask team about this)

bathroom_rows <- which(new_df$bathrooms > 4)
bedroom_rows <- which(new_df$bedrooms > 4)
price_high_rows <- which(new_df$price > price_quantile_high)
price_low_rows <- which(new_df$price < price_quantile_low)

# Concatenate rows to remove 
remove_rows <- c(bathroom_rows, bedroom_rows, 
                     price_high_rows, price_low_rows)
# Remove duplicates 
remove_rows <- unique(remove_rows)

# Percentage of interest level removed
length(which(new_df$interest_level[remove_rows] == "high"))* 100 /length(which(new_df$interest_level == "high"))

length(which(new_df$interest_level[remove_rows] == "medium")) * 100/length(which(new_df$interest_level == "medium"))

length(which(new_df$interest_level[remove_rows] == "low")) * 100/length(which(new_df$interest_level == "low"))

new_df <- new_df[-remove_rows, ]


############################################################################
########################## SAMPLING ########################################
############################################################################

# Will be random sampling so set seed 
set.seed(1)

# Percentage of each class in the modeling sample 
high_per <- 0.2
med_per <- 0.35
low_per <- 0.45

# int level = high determines sample size 
sample_size <- round(length(which(new_df$interest_level == "high"))/ high_per,0)

# Take all observations with high rating 
high_rows <- which(new_df$interest_level == "high")
medium_rows <- sample(which(new_df$interest_level == "medium"), 
                      round(med_per * sample_size))
low_rows <- sample(which(new_df$interest_level == "low"), 
                      round(low_per * sample_size))

# Concatenate rows 
sample_rows <- c(low_rows, medium_rows, high_rows)

# Determine test and training set sizes and rows 
train_rows <- sample(sample_rows, 0.7*length(sample_rows))
test_rows <- setdiff(sample_rows, train_rows)

# Create Sample test and train data frame 
train_df <- new_df[train_rows, ]
test_df <- new_df[test_rows, ]

# Peaks at test and train data sets 
summary(train_df)
summary(test_df)

# Clean up- remove all variables except dataframe to export 
rm(list = setdiff(ls(), c("train_df", "test_df")))



