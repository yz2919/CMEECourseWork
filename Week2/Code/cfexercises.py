#!/usr/bin/env python3
"""Some functions modified by using control statements"""
__appname__ = 'cfexercises.py'
__author__ = 'Yuqing Zhou (yz2919@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "None"

import sys

def foo_1(x=4):
    """Calculate the square root of x"""
    return x ** 0.5

def foo_2(x=3, y=8):
    """Find the larger number"""
    if x > y:
        return x
    return y
    
def foo_3(x=5, y=2, z=1):
    """Put the smaller one of two adjacent numbers in the front of the sequence"""    
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo_4 (x=10):
    """Calculate the factorial of x"""
    result = 1
    for i in range (1, x + 1):
        result = result * i
    return result

def foo_5(x=10):
    """a recursive function that calculates the factorial of x"""
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x=10):
    """Calculate the factorial of x in a different way"""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

def main(argv):
    """main entry"""
    print(foo_1(9))
    print(foo_2(6,4))
    print(foo_3(833,529,641))
    print(foo_4(25))
    print(foo_5(25))
    print(foo_6(25))
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
