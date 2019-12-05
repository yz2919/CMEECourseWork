#!/usr/bin/env python3

"""vectorize the function of stochastic Ricker Eqn and compare operation time"""

__appname__ = 'Vectorize2.py'
__author__ = 'Yuqing Zhou (yz2919@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = "None"


import numpy as np
import random
import math
from timeit import default_timer as timer

# rm(list=ls())

def stochrick(p0=np.random.uniform(.5,1.5,(1000,)),r=1.2,K=1,sigma=0.2,numyears=100):
  #initialize
  N = np.empty((numyears,len(p0),))
  N[0,] = p0
  
  for pop in range(len(p0)): #loop through the populations
  
    for yr in range(1,numyears): #for each pop, loop through the years
    
      N[yr,pop]=N[yr-1,pop]*np.exp(r*(1-N[yr-1,pop]/K)+np.random.normal(0,sigma,1)) #fluctuated within years
    
    return N

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 
def stochrickvect(p0=1000,r=1.2,K=1,sigma=0.2,numyears=100):
    #initialize
    N = np.empty((numyears,p0,))
    N[0,]=np.random.uniform(.5,1.5,(p0,))
    
    # for (pop, yr) in range(p0,(1,numyears)):
    for yr in range(1,numyears):
    # for yr in range(1,numyears):#loop through the years
        N[yr]=N[yr-1]*np.exp(r*(1-N[yr-1]/K)+float(np.random.normal(0,sigma,1)))

    return N

stochrickvect2 = np.vectorize(stochrick,otypes=[np.float],cache=False)


print("Vectorized Stochastic Ricker takes:")
start=timer()
stochrick()
print("%s" %(timer()-start))

print("Vectorized Stochastic Ricker 1 takes:")
start=timer()
stochrickvect()
print("%s" %(timer()-start))

print("Vectorized Stochastic Ricker 2 takes:")
start=timer()
stochrickvect2()
print("%s" %(timer()-start))
