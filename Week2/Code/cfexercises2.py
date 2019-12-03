#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: cfexercises2.py
# Desc: examples of loops with conditions
# Arguments: 0
# Date: Oct 2019

"""Examples of loops with conditions"""

__appname__="cfexercises2.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"


for j in range(12):
    if j % 3 == 0:
        print('hello')

for j in range(15):
    if j % 5 == 3:
        print('hello')
    elif j % 4 == 3:
        print('hello')
    
z = 0
while z != 15:
        print('hello')
        z = z + 3

z = 12
while z < 100:
    if z == 31:
        for k in range(7):
            print('hello')
    elif z == 18:
        print('hello')
    z = z + 1
