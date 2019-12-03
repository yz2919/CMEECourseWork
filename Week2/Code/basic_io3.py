#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: basic_io3.py
# Desc: Save a complex object for later use.
# Arguments: 0
# Date: Oct 2019

"""Save a complex object for later use"""

__appname__="basic_io3.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

#############################
# STORING OBJECTS
#############################
# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

import pickle

f = open ('../Sandbox/testp.p', 'wb') ## b: accepy binary files
pickle.dump(my_dictionary, f)
f.close()

## Load the data again
f = open('../Sandbox/testp.p', 'rb')
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)
