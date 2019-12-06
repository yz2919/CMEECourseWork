#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: profileme2.py
# Desc: better profileme
# Arguments: 0
# Date: Nov 2019

"""better profileme"""

__appname__="profileme2.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

def my_squares(iters):
    """better square"""
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters, string):
    """better join"""
    out = ''
    for i in range(iters):
        out += "," + string
    return out

def run_my_funcs(x,y):
    """better run func"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")
