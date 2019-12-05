#!/usr/bin/env python3

"""sums all elements of a matrix, 
compare operation time of code with loop and with inbuilt function"""

__appname__ = 'Vectorize1.py'
__author__ = 'Yuqing Zhou (yz2919@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = "None"


import numpy as np
import random
from timeit import default_timer as timer

# M = [[random.random() for i in range(1000)] for j in range(1000)]
M = np.random.randint(1000000, size=(1000,1000))  

def SumAllElements(M):
    Dimensions = np.shape(M)
    Tot = 0
    for i in range(Dimensions[0]):
        for j in range(Dimensions[1]):
            Tot = Tot + M[i][j]
    
    return Tot


print("Using loops, the time taken is:")
start= timer()
SumAllElements(M)
print("%s" %(timer()-start))


print("Using the in-built vectorized function, the time taken is:")
start= timer()
np.sum(M)
print("%s" %(timer()-start))
