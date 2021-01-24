## R training for psychologists  

### This is practice code and dummy data for basic R training purposes. 

The aim of this repository is to help existing psychologists that are trained in SPSS to learn how to replicate those basic skills, but on R Studio.  

The objective is to provide "two-minute tasks" (TMTs) that slowly take you through a basic analysis of typical psychological intervention data. 
Got two minutes? Do one task. Got ten minutes? Do a couple! The whole thing is intended to fill a 2-hour introduction session.

> Just remember, the beauty of R is that you can tailor your analyses in a million different ways - don't take these tasks as gospel!

### TMT 1: Download and install the software  
R: https://cran.ma.imperial.ac.uk/  
R Studio: https://rstudio.com  

### TMT 2: Understand a couple of basic need-to-knows  
- Anything after a hash (#) will not run, so you can use those to annotate your code.  
- R is **CASE-SENSITIVE** so if you run into an error, check your spelling and/or capitalisations.  
- Copying and pasting code is not cheating: in fact, it's part and parcel of the collaborative nature of open-source stats!  
- To **run** code, either:  
  - place the cursor into a single chunk of code you want to run and hit Ctrl+Rtn  
  - select (highlight) chunks of code that you want to run and click the "Run" button  
  - place the cursor at the start and hit "Run": it'll run everything!  

> Remember: If at first you don't succeed, **COPY AND PASTE IT INTO A SEARCH ENGINE!** :) Seriously, whatever you've done I **guarantee** you, someone else has also done it and there's an explanation of how to fix it!  

### TMT 3: The typical R Studio layout
When you open R Studio, it should look a bit like this (but if it doesn - **don't worry**, it soon will!):  

   ![R Studio layout](main1.png)  

Let's make sure you've got a .R file to write your code in. Either navigate to **File -> New File -> R Script** or press **CTRL+SHIFT+N**.  
Now you should have four quadrants:  
- **Top left**: This is your .R file, where you'll write and save your code. Why not give your file a title like ``## MY TRAINING CODE ##``   
- **Bottom left**: This is the console, where you'll see you code executed and get your data outputs.  
- **Top right**: This is your environment, where your data and other objects you've created will be listed.  
- **Bottom left**: This is your file structure, where you'll see the folder you're working from.  
    - It's also where your plots will go and where you can find in-software help.   

### TMT 4: Loading some data into R Studio  
We need to do two things here:
- Tell R Studio where in our hard drive (or online) we need it to go to find the things we want to use (code, data, etc).  
- Import some data from that location.  
The following code can be either typed or copied into your R file:
    
    # set my working directory (your's will be wherever you saved the docs)  
    setwd("~/R/training 2019")  
    
    # this will create a data-frame in your environment with the data  
    mydata <- read.csv("prog-example-data.csv", header = T)  
    View(mydata)  
    

### TMT 5: Exploring the nature of the data

### TMT 6: 
