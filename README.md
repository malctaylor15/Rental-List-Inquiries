# Rental-List-Inquiries
Repository for files related to the Kaggle Competition about Home Rent Prices. More information about the competition can be found [here](https://www.kaggle.com/c/two-sigma-connect-rental-listing-inquiries) 


My co-worker [Xuanru Shen](https://github.com/ttjxuan) helped by helping to visualize the data on the map.  

The goal of the competition was to predict the interest level of each rental housing unit as high, medium or low. The competition data consisted of several attributes about each such as the number of bedrooms, bathroomms, longitude, latitute and photos of the listings. 

After using a random search through the hyper parameters for a GBM mode, my lowest log-loss on the public leaderboard was 0.742 and on the private leader board 0.733. The competition winners achieved a log loss of 0.492 on the private leader board. 

## Malcolm R Project 

There are several files associated with the Malcolm R Project. Much more work can be done and below is a short description of the files. 


In Dataframe_Cleaning1.R- 
We add a few features for the time and date information as well as change several data types for later analysis. 

In Data_Cleaning2.R- 
we do some analysis on some of the features to remove outliers that could skew our results. 
We have some quick histograms to illustrate several features of the data 

In Sampling3.R- 
We remove the outliers as mentioned in Data_Cleaning2.R 
We sample from the data to create a modeling sample that has more evenly balanced dataset. 
These datasets are ready for analysis. 

In Algorithms.R 
I use the h2o package and environment to begin conducting analysis on the datasets. 
To install h2o visit h2o.ai. You will need to install java in order for the package to work. 
Used grid search with random forest and GBM. 


## Next steps might include 
1. Add submission file to cleaning steps - read in test set and following cleaning protocols. 
2. Clean features column and conduct bag of words. Create flags for high frequency terms. 
3. Adding the number of photos column  
4. Conduct sentiment analysis on the description as it would add more features. 
5. Transfer learning on the images. Using Imagenet to identify what kind of pictures people upload 
  (kitchen, bathroom, living room, other etc. ) 

