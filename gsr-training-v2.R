## R TRAINING ##
## IAN ELLIOTT: AUGUST 2020 ## 

#----------------------------------------------------------------------------------------#

## SOME CRITICAL BASICS TO START OFF WITH

# 1. anything after a hash will not run, so you can use those to annotate your code

# 2. R is *CASE-SENSITIVE* so if you run into an error, check your spelling and/or capitalisations

# 3. it's entirely up to you, but there is a consensus to dot variables and underscore objects

# 4. to run code, either:
# a) put the cursor in the line you want to run and hit Ctrl+Rtn
# b) select (highlight) a section of lines you want to run and click "Run" above
# c) hit "Run" above and it'll run everything!

# 5. if at first you don't succeed, COPY AND PASTE IT INTO GOOGLE! seriously, whatever you've done
# i guarantee you, someone else has also done it and there's an explanation of how to fix it!

#----------------------------------------------------------------------------------------#

# HOW TO LOAD IN DATA (CSV FORMAT)

# in this section we'll look at how to get your data into R Studio for manipulation and analysis

# first set the working drive. this tells R where it's getting the data from. however, i find it easier
# to go to "Files" in the bottom-right-hand box, navigate to the data, "More", and "Set as Working Directory"   

setwd("~/R/training 2019")

# load in the data as a data.frame with headers

mydata <- read.csv("prog-example-data.csv", header = T) # mention the = and == issue!

# you can then see the data in a number of diferent ways

View(mydata) # this is typically the most useful way to see everthing
head(mydata) # shows the top few rows, so you can check everything us there
mydata # not useful for datasets, but will be relevant for objects like charts and tables 

#----------------------------------------------------------------------------------------#

# CREATING OBJECTS

# in this section we'll quickly look at how to create an object
# this is like the M button on a calculator - saves a chunk info so you can refer back to it

risklab <- c("Low", "Med", "High", "Very high") # we will refer back to this!

#------------------------#

# DATA FRAMES AND CLASSES

# R needs to know what format your data is in - i.e., numbers, groups, etc. this section will explain how
# to check what they are and then how to change them if you need to

class(mydata)

class(mydata$risk.gen) # explain strings
class(mydata$apd) # we want this to be a numerical, but is currently an "integer"

mydata$apd <- as.numeric(as.character(mydata$ap)) # changes "apd" to a numerical variable

mydata$risk.gen <- as.factor(mydata$risk.gen) # changes risk.gen to a factor
levels(mydata$risk.gen) # you can then ask what the "groups" are within that factor
str(mydata$risk.gen) # this becomes really important when you start running tests with groups etc

mydata$risk.gen <- factor(mydata$risk.gen, levels = c("Low", "Medium", "High", "Vhigh"))

#----------------------------------------------------------------------------------------#

# HOW TO GET BASIC CENTRAL TENDENCY STATISTICS ETC

# in this section we'll just generate some basic stats using some in-built functions
# we'll also look at how to call on specific variables (columns) within the dataset

mean(mydata$age) # get the average of one variable
round(mean(mydata$age),2) # you can also round this to two decimal places

sd(mydata$age) # get the standard deviation of one variable
round(sd(mydata$age),2)

max(mydata$age)
min(mydata$age)

# you can also get all of these stats using the "summary" function

summary(mydata$age)

#----------------------------------------------------------------------------------------#

# HOW TO INSTALL AND LOAD PACKAGES

# get access to other statistics

install.packages("semTools", dependencies = T) 
library(semTools)

skew(mydata$age) # semTools gives you skew and excess kurtosis for normality checks
kurtosis(mydata$age)

# get access to alternatives to "summary" etc

install.packages("pastecs", dependencies = T)
library(pastecs) 
stat.desc(mydata$age) # stat.desc gives you extra stats

install.packages("stats", dependencies = T)
library(stats) 
aggregate(age ~ prog.type, mydata, mean, na.action = na.omit) # aggregate splits groups by one function

#----------------------------------------------------------------------------------------#

# HOW TO DO BASIC VISUALISATIONS (TABLES, PLOTS)

# basic tables are simple

table(mydata$risk.gen)
table(mydata$risk.gen, mydata$prog.type) # you can also split by multiple variables

# but other packages have better and more useful tables - i really like "CrossTable" as it's like SPSS
# https://www.rdocumentation.org/packages/gmodels/versions/2.18.1/topics/CrossTable

install.packages("gmodels", dependencies = T)
library(gmodels)

CrossTable(mydata$risk.gen)
CrossTable(mydata$risk.gen, mydata$prog.type, format = "SPSS")
CrossTable(mydata$risk.gen, mydata$prog.type, format = "SPSS",
           prop.r = T, prop.t = F, prop.c = F) # you can specify which of the percentages you want

# the base R plots are also simple, but ugly

hist(mydata$apd)
plot(mydata$prog.type, mydata$apd)
plot(mydata$cogdist, mydata$apd)

#--------------------#

# CHARTS/VISUALISATION 
# this COULD BE A WHOLE SESSION IN ITSELF, but the "ggplot" is the boss package for plots

install.packages("ggplot2", dependencies = T)
library(ggplot2)

# at it's very basic level you specify: 
# the data, the "aes" (aesthetics: these are your variables) +
# what type of chart you want to view and the stats you want it to use

apchart <- ggplot(mydata, aes(prog.type, apd, fill = prog.type)) +
  geom_bar(stat = "summary", fun = "mean")

print(apchart) # but that's kind of ugly right?

# well, you can go HAM on any chart...

mycolours <- c("#284969", "#5599C6") # pick a couple of colours

apchart2 <- ggplot(mydata, aes(prog.type, cogdist, fill = prog.type)) +
  stat_summary(fun = mean, geom = "bar", position = "dodge", alpha = 0.5, colour = "black") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position = position_dodge(width = .90), width = .1) +
  labs(x= "Prog", y = "APD", fill = "Prog") +
  ylim(0,10) + 
  scale_fill_manual(values = mycolours, labels = c("izon", "None")) +
  theme(text = element_text(size = 12), legend.position = "none") +
  facet_wrap(~risk.gen)

print(apchart2)

# we'll try some more charts as we go along...

#----------------------------------------------------------------------------------------#

# HOW TO STATISTICALLY COMPARE GROUPS
# in this section we'll look at how to replicate some of the basic stats that SPSS offers

install.packages("stats", dependencies = T) # get access to other statistics
library(stats)

#--------------------#

## T-TEST

# t.test for one variable and two groups (fyi: "~" is called a "tilde")

t.test(mydata$apd ~ mydata$prog.type)

# a paired (repeated-measures) t.test

t.test(mydata$pre.prob, mydata$post.prob, paired = T)

#--------------------#

## ANOVA

apt_aov <- aov(mydata$apd ~ mydata$risk.gen) # you can also do anova for more than one groups

summary(apt_aov)

# plot the differences

mycolours4 <- c( "#91D7F0", "#5599C6", "#195A9B", "#284969") # create a four-level colour scheme

apt_plot <- ggplot(mydata, aes(risk.gen, apd, fill = risk.gen)) +
  stat_summary(fun = mean, geom = "bar", position = "dodge", alpha = 0.5, colour = "black") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position = position_dodge(width = .90), width = .1) +
  labs(x= "Risk", y = "APD", fill = "Risk") +
  ylim(0,10) + 
  scale_fill_manual(values = mycolours4) +
  theme(text = element_text(size = 12), legend.position = "none")

print(apt_plot)

# you could even wrap it by other elements

apt_plot + facet_wrap(~prog.type)

# you can also request post-hoc tests to look at those group differences

apt_posthoc <- TukeyHSD(apt_aov, "mydata$risk.gen", conf.level = 0.95)

print(apt_posthoc)

#--------------------#

## CHI-SQUARE

# check your 2x2 table first

table(mydata$ethnicity, mydata$prog.type)

# run a chi-square and fisher's exact test

chisq.test(mydata$ethnicity, mydata$prog.type)
fisher.test(mydata$prog.type, mydata$ethnicity)

# the CrossTable function also gives you a chisq value - good to use as a "second opinion"!

CrossTable(mydata$ethnicity, mydata$prog.type, chisq = T, fisher = T)

# you can also plot the groups as a bar histogram

ethn_plot <- ggplot(mydata, aes(ethnicity, fill = prog.type)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = mycolours) +
  labs(x= "Ethicity", y = "Freq", fill = "Prog") +
  theme(text = element_text(size = 12), legend.position = "top", axis.text.x = element_text(angle = 90))

print(ethn_plot)

#----------------------------------------------------------------------------------------#

## SELECTING AND SUBSETTING
# in this section we'll continue manipulating the full data into smaller chunks for different analyses
# for this, we'll want the "dplyr" package (dplyr could also be a whole session in its own right!)

install.packages("dplyr", dependencies = T)
library(dplyr)

#--------------------#

# SELECTING variables 
# (i.e., creating new dataframes by choosing *columns*)

# you might want to select just the variables from one measure/scale to get reliability stats 

oasys <- mydata %>% select(7:14)

install.packages("CTT", dependencies = T)
library(CTT) # classical test theory

CTT::reliability(oasys) # use "CTT::" here as multiple packages we've loaded have a function called reliability
itemAnalysis(oasys) 

# you might want to select two variables for inter-rater reliability

risk <- mydata %>% select(risk.gen, risk.gen2)

install.packages("irr")
library(irr) 

agree(risk, tolerance = 0) # the raw percentage agreement

kappa2(risk, "squared") # the cohen's kappa for two raters

#--------------------#

# SUBSETTING cases
# (i.e., creating new dataframes by choosing *cases*)

# here's an example where you want to create a dataset just for those who did the programme

izon <- subset(mydata, prog.type == "izon")

mean(izon$pre.cog, na.rm = T); sd(izon$pre.cog, na.rm = T)  # then you can get the stats you're after

# here's an example where you then want programme participants under the age of 20

izon_u20 <- subset(izon, age < 20)

mean(izon$pre.cog, na.rm = T); sd(izon$pre.cog, na.rm = T) # then you can get the stats you're after

# you can also select cases by removing ALL missing data (at the casewise level)

full_izon <- na.omit(izon)

#----------------------------------------------------------------------------------------#

# CREATING NEW VARIABLES
# in this section we'll create new variables (columns) based on manipulating the existing ones

# simple example, let's create "change" variables for the differences between pre- and post- scores

full_izon$cd.change <- full_izon$pre.cog - full_izon$post.cog
full_izon$prob.change <- full_izon$pre.prob - full_izon$post.prob
full_izon$selfreg.change <- full_izon$pre.selfreg - full_izon$post.selfreg
full_izon$scap.change <- full_izon$pre.scap - full_izon$post.scap

# we can also plot the distributions of those new variables

cd_hist <- ggplot(full_izon, aes(cd.change)) +
  geom_histogram(fill = "#5599C6", colour = "black") +
  labs(y = "Frequency", x = "CD Change")

print(cd_hist)

# alternatively, we could create a new categorical variables

range(full_izon$age)
full_izon$age.gp <- as.factor(ifelse(full_izon$age > 21, 1, 0))
class(full_izon$age.gp)

# you could then look for statistical group differences in those new categorical variables

t.test(cd.change ~ age.gp, full_izon)

cd_age <- ggplot(full_izon, aes(age.gp, cd.change, fill = age.gp)) +
  stat_summary(fun = mean, geom = "bar", position = "dodge", alpha = 0.5, colour = "black") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position = position_dodge(width = .90), width = .1) +
  labs(x= "Age group", y = "CD change", fill = "Age group") +
  scale_fill_manual(values = mycolours, labels = c("Over 21", "Not over 21")) +
  theme(text = element_text(size = 12), legend.position = "top")

print(cd_age)

#----------------------------------------------------------------------------------------#

## LOGISTIC REGRESSION MODELS
# in this section we'll look at how to run logistic and linear regression models using the "car" package

install.packages("car")
library(car)

#--------------------#

# LOGISTIC REGRESSION
# this section explores whether any of those new raw change variables predict binary recidivism (yes/no)

# first we specify our model 

rx_model <- glm(recon ~ cd.change + prob.change + selfreg.change + scap.change, 
                full_izon, family = binomial(), na.action = na.exclude)

summary(rx_model)

#--------------------#

# LINEAR REGRESSION
# this section explores whether any of the oasys variables predict socially-desirable responding

# first we specify our model 

lie_model <- lm(lie.scale ~ apd + cogdist + associates + family + substance + ete + housing + prosocial, 
                full_izon, na.action = na.exclude)

summary(lie_model)

#----------------------------------------------------------------------------------------#

## MELTING DATA FROM WIDE TO LONG FORMAT
# this section shows how to reshape data from sets of columns into one column with categorical variables
# this format helps for multi-level modeling and for some line charts in ggplot2

# isolate the variables that you want to melt

psych <- full_izon %>% select(id, recon, 
                              pre.prob, pre.selfreg, pre.cog, pre.scap,
                              post.prob, post.selfreg, post.cog, post.scap)

# use the melt function to turn the data into long-format

psych_lg <- melt(psych, id = c("id", "recon"),
              measured = c("pre.prob", "pre.selfreg", "pre.cog", "pre.scap",
                           "post.prob", "post.selfreg", "post.cog", "post.scap"))

# add the categorical variables automatically and adds the names

psych_lg$time <- gl(2, (2120/2), label = c("Pre", "Post"))
psych_lg$scale <- gl(4, (2120/8), label = c("PS", "SR", "COG", "SCP"))

names(psych_lg) <- c("id", "Recidivism", "variable", "score", "Time", "scale")

# test the data with a line plot

oasys.line <- ggplot(psych_lg, aes(Time, score, colour = Recidivism)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun = mean, geom = "line", aes(group = Recidivism)) +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.2) +
  labs(x = "Time", y = "Scale score", fill = "time") +
  theme(plot.title = element_text(size = 11)) +
  scale_color_manual(values = mycolours) +
  theme(legend.position = "top", ) +
  facet_wrap(~scale); oasys.line

## END ##