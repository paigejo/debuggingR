# Debugging R code

# Define simple example functions ----
f = function(x) {
  yval = x$y
  yval
}
g = function(x) {
  f(x)
}



## Correct input x ----
x = list(y = 1, z = 2)
f(x)
g(x)




## Incorrect input x ----
x = 5
f(x)
g(x)




# options(error=recover)!!! ----

# default R behavior on error:
options(error=NULL)
f(x)




# Set R to print the full function stack at the time of the error
options(error=traceback)
f(x)
g(x)



# allow the user to see environments in any function in the 
# stack at the time of the error. VERY USEFUL!!! Note in 
# particular the "Next", "Continue" and "Stop" buttons that 
# appear over the console when in debug mode.
options(error=recover)
g(x) # error occurs in frame 2

# Selecting the f(x) environment number 
# allows us to see the variables directly leading to the error. 
# Selecting 0 exits from debug mode




# options(warn=2) ----

# default behavior in R: 
# warnings stored until top level function returns
options(warn=0)

x = rep(1, 2000000)
x[1] = -1
fun = function(x) {
  log(x)
}
temp = sapply(x, fun)

# warnings printed as they occur (recommended in general). 
options(warn=1)
temp = sapply(x, fun)

# (technically "temp = fun(x)" is equivalent, but it doesn't 
#  illustrate the difference in when the warning occurs)

# warnings are treated like errors
options(warn=2)
fun(-1)

# NOTE: 
# options(warn=2) can be used in conjunction 
# with options(error=recover)!

# reset to default behavior
options(warn=0)



# debug, undebug, debugonce ----

# debug and undebug are very useful for going through functions 
# line by line, which is very important for debugging.

x = 5
debug(f)
f(x)
g(x)

undebug(f)
f(x)
# NOTE: if f is in a script, sourcing that script will "undebug" f

debugonce(f)
f(x)

f(x)

# print() ----

# print variable values to understand what led to error

h = function(x) {
  
  for(i in 1:1000) {
    if(!is.finite(x[i])) {
      # print the value of x[i]
      print(paste0("Alert! For iteration ", i, " x[i]=", x[i]))
    }
    
    x[i] = x[i] + 1
  }
  
  out = x^2
  out
}

x = 1:1000
x[500] = NA

test = h(x)

# browser() ----

# rather than printing, we could enter debug mode directly

h = function(x) {
  
  for(i in 1:1000) {
    if(!is.finite(x[i])) {
      # enter debug mode
      browser()
    }
    
    x[i] = x[i] + 1
  }
  
  out = x^2
  
  browser()
  out
}

x = 1:1000
x[500] = NA

test = h(x)

# Summary of functions and options for debugging ----

# options(error=recover)
## Single most useful debug tool in R

# options(warn=2) vs options(warn=1) vs options(warn=0)
## 2: treats warnings like errors (useful for debugging, 
##    can be used in conjunction with options(error=recover))
## 1: prints warnings as they occur (recommended in general)
## 0: prints warnings after top level function finishes 
##    (default)

# debug, undebug, debugonce
## Useful for entering debug mode when function is called.
## Generally browser() can be used instead, but if  
## you are on the cluster and changing the code is 
## inconvenient, these make good alternatives

# print() statements
## Overrated for debugging in R, but can sometimes help, particularly when the 
##   "if" condition for entering debug mode is unknown

# browser() statements
## Second most useful debug tool in R
### (the most important depending on who you ask)



# Other ideas on debugging: ----
# Write well organized and readable code:
#   Use comments extensively
#   Name variables and functions well
#   code using functions rather than scripts when possible
#   Use "document outline" feature of RStudio (comments ending with "----")
# Plot variables and model output
# Make a list of things that could cause the bug/error (this takes more experience)
#  and check them one by one
# When in doubt, go through code line by line looking at variables
# The "eye test" is the single most important test to check your results: 
#  have an idea of what you expect your results to look like, and if they 
#  look different ask yourself if it could be a bug in your code.
# Recommendations for debugging on the cluster:
#   setBreakpoint("source.R", 6) causes R to enter debug mode when it gets to 
#    line 6 of source.R
#   run code on small test dataset interactively using methods mentioned above 
#    before moving on to large scale computations



