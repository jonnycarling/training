## Demonstration R for curious psychologists  

### This is practice code and dummy data for basic R training purposes. 

**Mission:** To help existing psychologists who are trained in SPSS to learn how to replicate those basic skills, but in R and via R Studio.  

**Aim:** To illustrate, using two worked examples, how R Studio operates and introduce you to the process of writing and running analytical code. It is **not** intended to be a comprehensive introduction to statistics on R. (Clearly, you would do more than is covered here if you were doing a real analysis.)  

**Objective:** To guide the reader, step-by-step, through two examples of basic statistical analyses that a typical psychologist would likely have encountered and may have conducted before using SPSS: (1) a two-sample student's t-test using numerical data and (2) a chi-square test of association using categorical data.  

> **Remember:** The beauty of R is that you can tailor your analyses in a million different ways. 
> Don't presume these examples even scratch the surface of what R can do! And don't be scared to try some coding of your own - you can always press **CTRL+Z** to undo your edits :)  

There are 10 steps to follow, which (sort of) get a little more tricky as you work through them.  

---
### STEP 1: Downloading and installing the neccessary stuff  
Here's where you want to go to get the software.  
**R**: https://cran.ma.imperial.ac.uk/  
**R Studio**: https://rstudio.com  

Create a folder somewhere easy to find on your computer's hard drive. My recommendation is to create a folder in **My Documents/R** and then a subfolder called /Training  
Download the data from this repository (https://github.com/ianaelliott/training) and move it into that folder.  

---
### STEP 2: Understanding a few basic "need-to-knows"  
- Any text that is prefixed with a hash ``#`` will be ignored by R, so you can use hash marks to annotate your code.  
- R is **CASE-SENSITIVE** so if you run into an error, check your spelling and/or capitalisations.  
- Copying and pasting code is not cheating: in fact, it's part and parcel of the collaborative nature of open-source stats!  
- To **run** code, either:  
  - place the cursor into a single chunk of code you want to run and hit **CTRL+RETURN**  
  - select (highlight) chunks of code that you want to run and click the "Run" button  
  - place the cursor at the start and hit "Run": it'll run everything!  

> **Remember:** If at first you don't succeed, **COPY AND PASTE IT INTO A SEARCH ENGINE!** :) 
> Seriously, whatever you've done I **guarantee** you, someone else has also done it and there's an explanation of how to fix it!  

---
### STEP 3: Familarising yourself with the typical R Studio layout
When you open R Studio, it should look a bit like the image below. But if it doesn't, **don't worry**, it soon will!  

   ![R Studio layout](r-screen.png)  

Let's also make sure you've got a .R file open to write your code in. Either navigate to **File -> New File -> R Script** or press **CTRL+SHIFT+N**.  

Now you should have four quadrants:  
- **Top left**: This is your .R file, where you'll write and save your code. Why not give your file a title like ``## MY TRAINING CODE ##``   
- **Bottom left**: This is the console, where you'll see you code executed and get your data outputs.  
- **Top right**: This is your environment, where your data and other objects you've created will be listed.  
- **Bottom left**: This is your file structure, where you'll see the folder you're working from.  
    - It's also where your plots will go and where you can find in-software help.   

---
### STEP 4: Set a working directory  
First, we need to tell R Studio where in our hard drive (or online) we need it to go to find the things we want to use (code, data, etc).  
- Navigate to the "Go to Directory" button on the "Files" tab of the bottom-right pane (it should be the three dots).  
- From there you can navigate to the folder that your created and into which you saved the data. Then click Open.  
- In the "Files" tab (bottom-right pane) click **More -> Set As Working Directory**. You'll see in the console (bottom-left pane) that this is executed as (for example):  
      
      > setwd(~R\Training)
      

---
### STEP 5: Loading some data into R Studio  
Now we can load the data into our project environment so that we can run code over it.  

> **Remember**: To run code, in turn, place the cursor in the line you want to run and then press CTRL+RETURN. 
> You can run each line at a time, or highlight the two lines and run them with the "Run" button in the top-right of the code file pane.  
    
    mydata <- read.csv("prog-example-data.csv", header = TRUE)  
    View(mydata)  
    
Objects are created and assigned values using ``<-`` or ``=``. So this will create an object called ``mydata`` that is a dataframe built from the .csv file.  

> **Tip:** ``=`` doesn't mean equal to in R, it means "assign to". If you need to specify that something "is equal to" you need to use ``==``. 
> This maybe makes more sense when you consider other similar operators are also combinations of two characters: not-equal-to ``!=``, less-than-or-equal-to ``<=``, and so on.  

The ``header = T`` option let's R know that your columns have headers at the top.  
The second line allows you to view the dataframe object that you've just created. You should see it in the environment (top-right pane).  

> **Tip**: You can substitute ``TRUE`` and ``FALSE`` for ``T`` and ``F``.  

---
### STEP 6: We need some packages   
Packages are the euivalent of the functions you select from the toolbar in SPSS.  
For now, we'll just need the ``stats`` package. First you'll install the package to the "library" of packages on your hard drive, then load them from the library so that we can use the functions within them in our analyses.
    
    install.packages("stats", dependencies = T)
    library(stats)  
    
Specifying ``dependencies = T`` tells R that you also want to install any other packages that the ``stats`` package requires to run.  

---
### STEP 7: Let's try a basic between-subjects t-test!  
Ok, let's see if there is a *programme* effect ``prog.type`` of *antisocial personality disorder* ``apd``.  
First we want to check our data are numerical so that the test will execute correctly:  
    
    class(mydata$apd)
    class(mydata$prog.type)

Hopefully, this has returned:  
    
    > class(mydata$apd)
    [1] "integer"
    > class(mydata$prog.type)
    [1] "factor"
    
This is good. If it doesn't look like that, you can change the class of the data with code. Executing the following code tells R to recreate, for example, the variable ``adp`` as an integer.

    mydata$adp <- as.integer(mydata$adp)
    mydata$prog.type <- as.integer(mydata$prog.type)  
    
> **Remember:** the ``$`` operator separates an object from the elements within it, in the format ``object$element``. 
> Here, that's in the format ``data$variable``.   

To run the t-test you want to test the apd scores by programme type, so execute:
    
    t.test(mydata$apd ~ mydata$prog.type)
    
This should return something similar to:

    > t.test(mydata$apd ~ mydata$prog.type)

  	      Welch Two Sample t-test

    data:  mydata$apd by mydata$prog.type
    t = -0.3321, df = 663.07, p-value = 0.7399
    alternative hypothesis: true difference in means is not equal to 0
    95 percent confidence interval:
      -0.4276355  0.3039068
    sample estimates:
    mean in group izon mean in group None 
              4.543046           4.604911

This tells us that the group means are 4.5 for the programme group and 4.6 for the no-programme group.  
The t-value is -0.33 at 663.07 degrees of freedom, and the p-value is .740. So, we fail to reject the null hypothesis.  

> **Try your own t-tests**, by selecting different integer (score) and factor (group) variables in the datset!  

You could also try a within-subjects t-test using a comma instead of the tilde ``~`` and specifying that you want a paired test.  
Here's an example of a within-subjects t-test to examine the pre-and post-programme difference in problem solving scores (pre.prob & post.prob):   
    
    t.test(mydata$pre.prob, mydata$post.prob, paired = T)
    

---
### STEP 8: Let's try a basic chi-square test of association!  
Ok, so what about categorical data? Let's try the association between *pre-treatment risk* ``risk.gen`` and *programme* ``prog.type``.  
We know that ``prog.type`` is categorical already (it's class = factor) so let's check the risk variable is also in the correct format:  
    
    class(mydata$risk.gen)
    
This should also return that ethnicity is a "factor". We can also see what levels are in that factor with a string command:  
    
    str(mydata$risk.gen)
    
The output tells us that risk.gen is a factor with 4 levels:  
    
    > str(mydata$risk.gen)
     Factor w/ 4 levels "High","Low","Medium",..: 1 3 1 1 1 1 1 4 3 3 ...
    
We can also look at a table of the data before we run a chi-square test:  
    
    table(mydata$risk.gen, mydata$prog.type)
    
The output shows us the frequencies within each level of the factor, by the programme or no-programme groups.  
    
    > table(mydata$risk.gen, mydata$prog.type)
        
             izon None
      High     81  108
      Low      11   26
      Medium  170  242
      Vhigh    40   72

Now we run the chi-square test by executing:  
    
    chisq.test(mydata$ethnicity, mydata$prog.type)

Like the t-test, the output gives us a chi-square test value, degrees of freedom, and a p-value.  
    
    > chisq.test(mydata$ethnicity, mydata$prog.type)

	          Pearson's Chi-squared test

    data:  mydata$ethnicity and mydata$prog.type
    X-squared = 9.5829, df = 9, p-value = 0.3853
    
> **Tip:** Try your own chi-square tests on other categorical variables (e.g., ethnicity, previous convictions)!  

---
### STEP 9: This is a step to the next level, but we can use ``ggplot2`` to chart those effects.  
One of the absolute strengths of R is the ability to visualise data and outcomes. Let's plot those two tests we've run.  
"Base R" (the functions that come with R before you install any packages) can do plots, but they're pretty ugly.  
First we'll run some code for a simple-but-ugly base chart, then we'll run some for a complex-but-beautiful ``ggplot`` chart!  

But first we need to install the ``ggplot2`` package:  
    
    install.packages("ggplot2", dependencies = T)
    library(ggplot2)  
    
Here's the plot you can get from base R:  
    
    plot(mydata$prog.type, mydata$apd)
    
Prob couldn't get that into a journal article though right? Well, we can spruce it up with ggplot.  
We'll also install and load ``ggpubr`` and ``Hmisc``, so we can include a significance bar and error bars.  
    
    install.packages(c("ggpubr", "Hmisc"), dependencies = T)
    library(ggpubr)  
    library(Hmisc)  
    
You can still run quite basic plots with ggplot. Here's the basic code for the adp t-test, specifying that you want the chart to plot the ``summary`` values derived from the ``mean`` function:  
    
    ggplot(mydata, aes(prog.type, apd) +
      geom_bar(stat = "summary", fun = "mean")
    
But, again, it's not as visually attractive as it could be. Let's add some bells and whistles from ggplot!  
        
    mycolours <- c("#284969", "#5599C6") # pick a couple of colours
    prog.comps <- list(c("izon", "None")) # tell ggpubr what comparison you want it to show significance for
    ggplot(mydata, aes(prog.type, apd, fill = prog.type)) +
      stat_summary(fun = mean, geom = "bar", position = "dodge", alpha = 0.5, colour = "black") +
      stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position = position_dodge(width = .90), width = .1) +
      stat_compare_means(comparisons = prog.comps, method = "t.test",
                         label = "p.signif", label.y = c(5.5), 
                         tip.length = .01, size = 4) +
      labs(x= "Prog", y = "APD", fill = "Prog") +
      scale_fill_manual(values = mycolours, labels = c("izon", "None")) +
      theme(text = element_text(size = 12), legend.position = "none")
    
This should arrive in the "Plots" tab in the bottom-right hand pane.  

This is a bit more complicated (but presented here as a final demonstration!), so let's have a quick look at the ingredients here:  

- **Line 1:** Creates a vector object called ``mycolours`` that specify two colours you'd like to use in the chart.  ``c`` means "combine".   
- **Line 2:** Creates a list object called ``prog.comps`` that will tell the gggpubr package how to render your significance bar.  
- **Line 3:** Starts the chart as an object. Specifies ``mydata`` as the source of the data, and the aesthetics (``aes``) of variables ``prog.type`` and ``apd``. Also tells ggplot to use the ``prog.type`` variable to group the bars. The plus sign ``+`` at the end of each line tells R to join these bits of code into one "chunk".  
- **Line 4:**  Specifies the stats you want to the chart to use. You want to use the ``mean`` function from the ``stats`` package to chart the means, via a bar chart, with the options to ``dodge`` (separate) the bars, make them 50% transparent with ``alpha``, and give the bars a black outline.  
- **Line 5:**  Adds the error bars, using the mean using the ``mean_cl_normal`` function from ``Hmisc``, and instructions on where to position them and their size.  
- **Line 6:**  Adds the significance bar by telling ggplot to display the outcome of a ``t.test`` on the levels specified in ``prog.comps``. It also specifies that you want the display the p-value test. Lastly it tells ggplot how high up the y axis to put it (``label.y``) and what size and shape it should be (``size`` and ``tip.length``).  
- **Line 7:**  Adds labels to the chart on the x and y axis and tells ggplot what to use to label the bars (``fill``).  
- **Line 8:**  Adds the colours specified in the ``mycolours`` object and which levels you want them applying to.  
- **Line 9:**  Lastly, changes the size of the text and removes the legend.  

> **Tip:** Dare to try changing some of the visualisations?! For example, try changing ``legend.position = "none"`` to ``legend.position = "top"``...   

---
### STEP 10: Save your code file and consider your own journey into the brave new world...  :)  
Save your code file by navigating to **File -> Save As** and save your file with a name like "training.R"  
(Who knows, you might be coming back to add to it in the future!)  

We've come to the end of this whistle-stop tour. The possibilities for analysis on R are vast, but the learning curve is incredibly steep.  
However, if you commit to integrating it into your stats projects and building on your skills, it really will start to come naturally - I promise!  

> **Last tip!** I would recommend adding something like Andy Field's excellent R version of his SPSS textbook to your library. It's a really good investment. https://uk.sagepub.com/en-gb/eur/discovering-statistics-using-r/book236067  

---
GOOD LUCK!!!  
**Ian**  

*Last updated: January, 2021*  
