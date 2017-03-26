# Looking at some ways to augment data before analysis 

# Import cleaning R script 
source("Dataframe_Cleaning1.R")
# Will be looking for a data frame called new_df with relevant column names 
# quick_cols <- c("bathrooms", "bedrooms", "longitude", "latitude", "lat_long", "price", "interest_level", "hour", "weekday", "yday")

# Start by looking at some extreme values 
summary(new_df)

# Bathrooms may want to drop this for linear analysis but not for rnadom forest?
hist(new_df$bathrooms, main = "Histogram of Number of Bedrooms")
hist(new_df$bathrooms[which(new_df$bathrooms > 4)], main = "Histogram of Number of bedrooms > 4")
# Note the y axis 
length(which(new_df$bathrooms > 4))


# Bedrooms 
hist(new_df$bedrooms, main = "Number of bedrooms")
hist(new_df$bedrooms[which(new_df$bedrooms > 4)], main = "Number of bedrooms > 4")
# Note the y axis 
length(which(new_df$bedrooms > 4))


# Price 
# Slightly more tricky due to continous nature 
hist(new_df$price, main = "Histogram of price")
# Try looking at price after certain quantile 
price_quantile_high <- quantile(new_df$price, 0.98)
price_quantile_low <- quantile(new_df$price, 0.02)
# How many observations are we cutting 
length (which(new_df$price > price_quantile_high ))
length (which(new_df$price < price_quantile_low ))

# New histogram of prices 
hist(new_df$price[which(new_df$price < price_quantile_high & 
                          new_df$price > price_quantile_low)], 
     main = "Histogram of price with 2% cutoffs ")

# Almost looks normal 
hist(new_df$price[which(new_df$price < price_quantile_high & 
                          new_df$price > price_quantile_low)], 
     probability = T, main = "Density of Price with Normality assumption")

price_median <- median(new_df$price[which(new_df$price < price_quantile_high & 
                                       new_df$price > price_quantile_low)])
price_sd <- sd(new_df$price[which(new_df$price < price_quantile_high & 
                                    new_df$price > price_quantile_low)])

norm_density <- dnorm(seq(price_quantile_low, price_quantile_high, len = 5000), 
                      mean = price_median, sd = price_sd)
lines(seq(price_quantile_low, price_quantile_high, len = 5000), norm_density, lwd = 3, col = "blue")





# Weekday 
plot(new_df$weekday, main = "Weekday distribution ")

# Roughly equal, maybe slightly fewer on Sunday and Mondays 

# Number of postings per day 
hist(new_df$yday, main = "Number of postings per day", col = rgb(0, 0.5, 1, 0.8), ylim = c(0, 4000))
hist(new_df$yday[which(new_df$interest_level == "medium" | new_df$interest_level == "high")], main = "Number of postings per day", col = "green", add = T, ylim = c(0, 4000))
hist(new_df$yday[which(new_df$interest_level == "high")], col = "red", add = T, ylim = c(0, 4000))
plot_mean <- (nrow(new_df)/ 90)*(90/20) # Assuming there are 20 bins (param = breaks)
abline(h = plot_mean, lwd = 3, col = "black")
 
legend("topright", c("High", "Medium", "Low", "Uniform Rate"), col = c(rgb(0, 0.5, 1, 0.8), "green", "red", "black"), lwd = 3)



