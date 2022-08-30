## LFF TRAINING SESSION 2 ##

rm(list = ls())

# REFRESH THE RSTUDIO ARRANGEMENT
# OPEN A NEW R SCRIPT FILE
# REFRESH HOW TO RUN CODE

# SET THE WORKING DIRECTORY
setwd("C:/Users/hqp96j/Desktop/lff-training")

# R IS OBJECT-ORIENTED
10 + 50
ten_plus_sixty <- 10 + 50
print(ten_plus_sixty)
ten_plus_sixty/2

# R IS CASE-SENSITIVE
print(Ten_plus_Sixty)
# Error in print(Ten_plus_Sixty) : object 'Ten_plus_Sixty' not found

# READ IN THE KYRIOS REFERRALS DATA
kyrios <- read.csv("kyrios_referrals.csv", header = T)

# VISUALISE WHAT'S IN THE DATAFRAME
head(kyrios)
colnames(kyrios)

# VISUALISE FACTOR VARIABLES (get the identifiers)
kyrios$conviction_type
table(kyrios$conviction_type)

# VISUALISE NUMERICAL VARIABLES
mean(kyrios$general_risk)
sd(kyrios$general_risk)

# HOWEVER, WE HAVE TO DO ALL OF THESE THINGS ONE-BY-ONE
# THE TIDYVERSE IS A SET OF PACKAGES THAT ALLOW US TO CHAIN TOGETHER COMMANDS TO PRODUCE, MANIPULATE, AND
# VISUALISE DATA QUICKLY AND IN A REPRODUCIBLE MANNER

library(tidyverse)
# v ggplot2 3.3.3     v purrr   0.3.4
# v tibble  3.1.1     v dplyr   1.0.6
# v tidyr   1.1.3     v stringr 1.4.0
# v readr   1.4.0     v forcats 0.5.1

# INTRODUCE DPLYR "PIPES"

# SELECT VARIABLES
kyrios <- kyrios %>%
  dplyr::select(id, conviction_type, core_referral, general_risk, violent_risk, sexual_risk, needs_screen, qualifies_need, override, referral_decision, start_date, completion_status)

#kyrios <- kyrios %>% # DROP OPTION
#  dplyr::select(-exp_release_date, -onboard_date, -onboard_year, -add_referral, -end_date)

# FILTER (FILTERS THE DATA BY ONE OR MORE CONDITIONS)
# filter for those who were referred to kyrios
kyrios %>%
  dplyr::filter(core_referral == "Kyrios")

# filter for those who were allocated to the programme
kyrios %>%
  dplyr::filter(core_referral == "Kyrios" & referral_decision == "Allocated")

# filter for conviction types
kyrios_allocated <- kyrios %>%
  dplyr::filter(core_referral == "Kyrios" & referral_decision == "Allocated" & 
                  (conviction_type == "ATH" | conviction_type == "IGV" | conviction_type == "LGA"))

str(kyrios_allocated$conviction_type)
kyrios_allocated$conviction_type <- droplevels(kyrios_allocated$conviction_type)

# GROUP, SUMMARISE, AND MUTATE (CREATES A NEW VARIABLE)
# get the numbers that completed and did not complete create a table
kyrios_allocated %>%
  dplyr::group_by(completion_status) %>%
  dplyr::summarise(n = n()) %>%
  tibble::as_tibble(.)

# create a percentage variable for your numbers
kyrios_allocated %>%
  dplyr::group_by(completion_status) %>%
  dplyr::summarise(n = n()) %>%
  dplyr::mutate(pc = n/sum(n)*100) %>%
  tibble::as_tibble(.)

# group also by the conviction type
kyrios_allocated %>%
  dplyr::group_by(conviction_type, completion_status) %>%
  dplyr::summarise(n = n()) %>%
  dplyr::mutate(pc = n/sum(n)*100) %>%
  tibble::as_tibble(.)

# turn that into a df object
kyrios_completion_rates <- kyrios_allocated %>%
  dplyr::group_by(conviction_type, completion_status) %>%
  dplyr::summarise(n = n()) %>%
  dplyr::mutate(pc = n/sum(n)*100) %>%
  tibble::as_tibble(.)

# USING LUBRIDATE TO WORK WITH DATES
# check what format the date is in
class(kyrios_allocated$start_date)

# parse start date into correct R date format
kyrios_allocated %>% 
  mutate(start_date = lubridate::dmy(start_date))

kyrios_allocated <- kyrios_allocated %>% 
  mutate(start_date = lubridate::dmy(start_date)) %>%
  mutate(start_year = lubridate::year(start_date))

# you can use GROUP_BY, SUMMARISE, and MUTATE to look at yearly rates
kyrios_allocated %>%
  dplyr::group_by(start_year) %>%
  dplyr::summarise(n = n()) %>%
  dplyr::mutate(pc = n/sum(n)*100)

# USING FILTER TO FILTER OUT PRE-2010 (NEW PROGRAMME) AND POST-2019 (COVID-19)
kyrios_allocated_11_18 <- kyrios_allocated %>%
  dplyr::filter(start_year >= 2011 & start_year <= 2018)

kyrios_allocated_11_18 %>%
  dplyr::group_by(start_year) %>%
  dplyr::summarise(n = n()) %>%
  dplyr::mutate(pc = n/sum(n)*100)

# DATA JOINS
# read in the demographic data for all prisoners
demographics <- read.csv("ernesford_data_demo.csv", header = T)
colnames(demographics)
head(demographics)

# link that data to our 2011-18 data
kyrios_allocated_11_18 <- kyrios_allocated_11_18 %>%
  dplyr::inner_join(demographics, by = "id", keep = F)
colnames(kyrios_allocated_11_18)

# CASE_WHEN FUNCTION
kyrios_allocated_11_18 <- kyrios_allocated_11_18 %>%
  dplyr::mutate(age_band = case_when(
    age <= 25 ~ "18-25",
    dplyr::between(age, 25, 55) ~ "26-54",
    age >= 55 ~ "55+"
  ))

table(kyrios_allocated_11_18$age_band)
table(kyrios_allocated_11_18$age)

# ACROSS FUNCTION
kyrios_allocated_11_18 %>% 
  dplyr::mutate(across(c("general_risk", "violent_risk", "sexual_risk"), scale))

kyrios_allocated_11_18 <- kyrios_allocated_11_18 %>% 
  dplyr::mutate(across(c("general_risk", "violent_risk", "sexual_risk"), scale)) %>%
  dplyr::mutate(across(where(is.numeric), round, 2))
  
# GGPLOT WITH WIDE DATA
plot(kyrios_allocated_11_18$conviction_type.x, kyrios_allocated_11_18$general_risk)
# but that's rubbish right?!

ggplot(kyrios_allocated_11_18, aes(conviction_type.x, general_risk)) +
  geom_boxplot()

ggplot(kyrios_allocated_11_18, aes(conviction_type.x, general_risk)) +
  geom_boxplot() +
  labs(x = "Conviction type", y = "General risk level", title = "General risk")

ggplot(kyrios_allocated_11_18, aes(conviction_type.x, general_risk)) +
  geom_boxplot() +
  labs(x = "Conviction type", y = "General risk level", title = "General risk") +
  theme_bw() # theme_dark theme_light theme_classic theme_minimal

ggplot(kyrios_allocated_11_18, aes(conviction_type.x, general_risk)) +
  geom_hline(yintercept = 0, linetype = "dashed", alpha = .5) + # do this first and draw boxplot on top
  geom_boxplot() +
  labs(x = "Conviction type", y = "General risk level", title = "General risk") +
  theme_bw()

ggplot(kyrios_allocated_11_18, aes(conviction_type.x, general_risk, fill = conviction_type.x)) +
  geom_hline(yintercept = 0, linetype = "dashed", alpha = .5) + 
  geom_boxplot(outlier.colour = "blue", outlier.alpha = 0.2) +
  scale_fill_manual(values = c("#c8b5cc", "#84a05c", "#e7bc69")) + # chatelle, asparagus, Rob Roy!
  labs(x = "Conviction type", y = "General risk level", title = "General risk") +
  theme_bw() +
  theme(legend.position = "bottom", text = element_text(size = 12))

# SCATTER PLOT VERSION (USING RISK AND AGE)
plot(kyrios_allocated_11_18$age, kyrios_allocated_11_18$general_risk)

ggplot(kyrios_allocated_11_18, aes(age, general_risk)) +
  geom_point(aes(colour = age_band)) +
  geom_smooth(method = lm, colour = "black") +
  ggpubr::stat_cor(method = "pearson", label.x = 65, label.y = 2.5, p.accuracy = 0.001) +
  geom_hline(yintercept = 0, linetype = "longdash", alpha = .5) +
  scale_colour_grey() +
  labs(x = "Age", y = "General risk", title = "Association between risk and age", colour = "Age band") +
  theme_bw() +
  theme(text = element_text(size = 12), legend.position = "bottom") +
  facet_wrap(~conviction_type.x, nrow = 3)

# PIVOT LONGER FUNCTION
kyrios_11_18_risk <- kyrios_allocated_11_18 %>%
  dplyr::select(id, conviction_type.x, general_risk, violent_risk, sexual_risk) %>%
  tidyr::pivot_longer(
    cols = c(general_risk, violent_risk, sexual_risk),
    names_to = "Group",
    values_to = "Count") %>%
  dplyr::mutate(Group = forcats::fct_recode(Group, 
                                            "General" = "general_risk", 
                                            "Sexual" = "sexual_risk", 
                                            "Violent" = "violent_risk"))

head(kyrios_11_18_risk)

library(viridis)
library(rstatix)
library(ggpubr)

stat.test <- kyrios_11_18_risk %>%
  group_by(Group) %>%
  t_test(Count ~ conviction_type.x) %>%
  adjust_pvalue() %>%
  add_significance("p.adj") %>%
  add_xy_position(x = "conviction_type.x")

kyrios_11_18_risk_plot <- ggplot(kyrios_11_18_risk, aes(conviction_type.x, Count)) +
  geom_boxplot(aes(fill = conviction_type.x)) +
  stat_pvalue_manual(stat.test, label = "p.adj.signif", tip.length = 0.01, 
                       y.position = c(4.75, 5.25, 4.75), bracket.shorten = 0.05) +
  #scale_fill_manual(values = c("#c8b5cc", "#84a05c", "#e7bc69")) +
  scale_fill_viridis(discrete = T, option = "A", alpha = 0.5) + 
  #scale_x_discrete(labels = c("General", "Violent", "Sexual")) +
  labs(x = "Risk type", y = "Risk level (z-score)", title = "Risk scores", fill = "Risk type") +
  theme_bw() +
  theme(legend.position = "none", axis.text.x = element_text(angle = 90), text = element_text(size = 12)) +
  #coord_flip() +
  facet_wrap(~ Group)

print(kyrios_11_18_risk_plot)

# FUNCTIONS (DRY: don't repeat yourself)
kyrios_regression <- lm(violent_risk ~ conviction_type, data = kyrios)
summary(kyrios_regression)

kyrios_regression_table <- data.frame(summary(kyrios_regression)$coefficients) %>%
  tibble::rownames_to_column(.) %>%
  dplyr::mutate(df = kyrios_regression$df.residual) %>%
  dplyr::filter(rowname != "(Intercept)")

# function for r effect size
rcontrast <- function(t, df) {
  tsq <- t*t
  tsqdf <- tsq + df
  r <- sqrt(tsq/tsqdf)
  return(r)
}

# use it once
rcontrast(-4.44, 14793)

# apply the function to the t-values
kyrios_regression_table %>% rowwise() %>% mutate(r = rcontrast(t.value, df)) %>%
  dplyr::mutate(across(where(is.numeric), round, 2))

# END #