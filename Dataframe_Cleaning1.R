# Cleaning and prepare data set 

packages <- c("jsonlite", "dplyr", "purrr", "tibble", "plotly", "lubridate")
purrr::walk(packages, library, character.only = TRUE, warn.conflicts = FALSE)

# Load data 
data <- fromJSON("input/train.json")

#Split features and photos?
vars <- setdiff(names(data), c("photos", "features"))
data <- map_at(data, vars, unlist) %>% tibble::as_tibble(.)

data_df <- as.data.frame(data)

# Check for na's
sum(is.na(data_df))

# Look at data 
colnames(data_df)
head(data_df)

# Change created feature into date time object 

data_df$created <- as.POSIXlt(data_df$created)

# Create potentially useful features 
# These will be 0 indexed 
data_df$weekday <- as.factor(data_df$created$wday)
data_df$hour <- as.factor(data_df$created$hour)
data_df$mday <- data_df$created$mday
data_df$yday <- data_df$created$yday - 90# This can be more of an index 

# Create new location based feature 
data_df$lat_long <- data_df$longitude * data_df$latitude
# Change data type of interest level 
data_df$interest_level <- as.factor(data_df$interest_level)

# Columns to keep 
quick_cols <- c("bathrooms", "bedrooms", "longitude", "latitude", "lat_long", "price", "interest_level", "hour", "weekday", "yday")  # add Listing ID here later for easy matching 

# Subset the original data set 
new_df <- data_df[ , quick_cols, drop = FALSE]

# Summary statistics of cleaned data set 
summary (new_df)

# Clean up- remove all variables except dataframe to export 
rm(list = setdiff(ls(), "new_df"))
