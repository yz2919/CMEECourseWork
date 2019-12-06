#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: timeitme.py
# Desc: quick profiling, takes a sample of runs and returns the average
# Arguments: 0
# Date: Nov 2019

"""quick profiling, takes a sample of runs and returns the average"""

__appname__="timeitme.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"
##############################################################################
# loops vs. list comprehensions: which is faster?
##############################################################################

iters = 100000

import timeit

from profileme import my_squares as my_squares_loops

from profileme2 import my_squares as my_squares_lc


##############################################################################
# loop vs. the join methods for strings: which is faster?
##############################################################################

mystring = "my string"

from profileme import my_join as my_join_join

from profileme2 import my_join as my_join

# %timeit my_squares_loops(iters)
# %timeit my_squares_lc(iters)

# %timeit(my_join_join(iters, mystring))
# %timeit(my_join(iters, mystring))
