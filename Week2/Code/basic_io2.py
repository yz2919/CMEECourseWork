#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: basic_io2.py
# Desc: Save a list of numbers into `testout.txt` file in `sandbox` directory
# Arguments: 0
# Date: Oct 2019

"""Save a list of numbers into `testout.txt` file in `sandbox` directory"""

__appname__="basic_io2.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

#############################
# FILE OUTPUT
#############################
# Save the elements of a list to a file
list_to_save = range(100)

f = open('../Sandbox/testout.txt','w')
for i in list_to_save:
    f.write(str(i) + '\n') ## Add a new line at the end

f.close()
