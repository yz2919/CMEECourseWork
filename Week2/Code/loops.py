#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: loops.py
# Desc: FOR loop and WHILE loop examples
# Arguments: 0
# Date: Oct 2019

"""FOR loop and WHILE loop exampels"""

__appname__="loops.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

# FOR loops in Python
for i in range(5):
    print(i)

my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)

total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
    print(total)

# WHILE lopps in Python
z = 0
while z < 100:
    z = z + 1
    print(z)

b = True
while b:
    print("GERONIMO! infinite loop! ctrl+c to sip!")
# ctrl + c to stop
