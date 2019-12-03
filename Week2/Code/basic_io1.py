#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: basic_io1.py
# Desc: output lines from `test.txt` file in 'sandbox' directory
# Arguments: 0
# Date: Oct 2019

"""output lines from `test.txt` file in `sandbox` directory"""

__appname__="basic_io1.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

#############################
# FILE INPUT
#############################
# Open a file for reading
f = open('../Sandbox/test.txt', 'r')
# use "implicit" for loop:
# if the object is a file, python will cycle over lines
for line in f:
    print(line)

# close the file
f.close()

# Same example, skip blank lines
f = open('../Sandbox/test.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()
