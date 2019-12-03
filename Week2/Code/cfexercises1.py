#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: cfexercises1.py
# Desc: six functions doing simple calculation
# Arguments: 0
# Date: Oct 2019

"""Six functions doing simple calculation"""

__appname__="cfexercises1.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

# What does each of foo_x do?
def foo_1(x):
    """Calculate the square root of x"""
    return x ** 0.5

def foo_2(x, y):
    """Choose the larger number in x and y"""
    if x > y:
        return x
    return y
    
def foo_3(x, y, z):
    """ NA """
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo_4 (x):
    """Calculates the farctorial of x"""
    result = 1
    for i in range (1, x + 1):
        result = result * i
    return result

# a recursive function that calculates the factorial of x
def foo_5(x):
    """A recursive function that calculates the factorial of x"""
    if x == 1:
        return 1
    return x * foo_5(x - 1)

# Calculate the factorial of x in a different way
def foo_6(x):
    """Calculate the factorial of x in a different way"""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto
