#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: Vectorize2.R
# Desc: vectorize the function of stochastic Ricker Eqn and compare operation time
# Arguments: 0
# Date: Oct 2019

# Runs the stochastic (with gaussian fluctuations) Ricker Eqn .

rm(list=ls())

stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  for (pop in 1:length(p0)){ #loop through the populations
  
    for (yr in 2:numyears){ #for each pop, loop through the years
    
      N[yr,pop]<-N[yr-1,pop]*exp(r*(1-N[yr-1,pop]/K)+rnorm(1,0,sigma)) #fluctuated within years
    }
  }
 return(N)

}

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 
stochrickvect<-function(p0=1000,r=1.2,K=1,sigma=0.2,numyears=100){
    #initialize
    N<-matrix(NA, numyears,p0)
    N[1,]<-runif(p0,.5,1.5)
    
    for (yr in 2:numyears){ #loop through the years
        N[yr,]<-N[yr-1,]*exp(r*(1-N[yr-1,]/K)+rnorm(1,0,sigma))
    }
    return(N)
}


print("Stochastic Ricker takes:")
print(system.time(res2<-stochrick()))

print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))

