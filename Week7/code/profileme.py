#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: profileme.py
# Desc: illustrates profiling in Python
# Arguments: 0
# Date: Nov 2019

"""illustrates profiling in Python"""

__appname__="profileme.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"


def my_squares(iters):
    """square loop"""
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    """join strings"""
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out
    
def run_my_funcs(x,y):
    """results of my_squares and my_join"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000, "My string")
