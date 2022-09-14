## LFF TRAINING SESSION 2 ##

rm(list = ls()) # clears workspace and restarts current work essentially



# READ IN THE KYRIOS (kyrios_referrals.csv) REFERRALS DATA (tip use read.csv function)


# add new id vector - this is for merging purposes later
id_v2 <- c(1:14802)
kyrios$id <- id_v2

# VISUALISE WHAT'S IN THE DATAFRAME (summary is one function to use)
head(kyrios)
colnames(kyrios)
summary(kyrios)


# THE TIDYVERSE IS A SET OF PACKAGES THAT ALLOW US TO CHAIN TOGETHER COMMANDS TO PRODUCE, MANIPULATE, AND
# VISUALISE DATA QUICKLY AND IN A REPRODUCIBLE MANNER
library(tidyverse)


# INTRODUCE DPLYR "PIPES"
# SELECT (id, conviction_type, core_referral, general_risk, violent_risk, needs_screen) VARIABLES from kyrios dataset


#de-select needs_screen from the dataframe you have just created with the select function


# FILTER (FILTERS THE DATA BY ONE OR MORE CONDITIONS)
# build code up at each step, i.e code in first step use it in each subsequent step, so there are multiple conditions in one piece of code
# filter for those who were referred to kyrios (core_referal variable)


# filter for those who were referred to kyrios & allocated to the programme 



# filter for hose who were referred to kyrios & allocated to the programme and conviction types - SVC OR LGC (use the or operator this one |)





# GROUP, SUMMARISE, AND MUTATE (CREATES A NEW VARIABLE)
# get the numbers that completed and did not complete create a table
kyrios_v3 %>%
  dplyr::group_by(completion_status) %>%
  dplyr::summarise(n = n()) %>%
  tibble::as_tibble(.)## leaving this in so you can get a general idea

# create a percentage variable for your numbers - create new column essentially - use mutate function



# group also by the conviction type



# turn that into a df object - assign it essentially 


# USING LUBRIDATE TO WORK WITH DATES
install.packages("lubridate")
library(lubridate)
# check what format the date is in


# change start date into d/m/y format using lubridate, will need to use mutate here



# create new variable start_year from start_date using lubridate 


# you can use GROUP_BY, SUMMARISE, and MUTATE to look at yearly rates


# USE FILTER TO FILTER OUT PRE-2010 (NEW PROGRAMME) AND POST-2019 (COVID-19)


# run group_by, summarise and mutate again here to look at rates  


############################################################################# pick this up again
# DATA JOINS
# read in the practice data for all prisoners ("prog-example-data.csv")


# take a look at data like done previously (glimspe etc.)


# link that data to kyrios data joining on the "id" variable


# CASE_WHEN FUNCTION - create new column recoding age into age_band (18-21, 22-24, 25)


# ACROSS FUNCTION - use scale function across violent risk and sexual risk (across function comes first)
# scale function essentially standardises variables - useful for placing them on a common scale (standard deviation units above or below the mean)


##### Data visualisation  

### use ggplot to plot a boxplot of conviction type and violent risk


## add some labels to the boxplot (labs function to do this)




# use ggplot to create scatter plot (using risk and age)



# END #