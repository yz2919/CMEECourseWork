#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: scope.py
# Desc: examples of using local and global variables
# Arguments: 0
# Date: Oct 2019

"""Examples of using local and global variables"""

__appname__="scope.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"



#block 1
print("block 1")
_a_global = 10 #a global variable

if _a_global >= 5:
    _b_global = _a_global + 5 #a global variable

def a_function():
    """block 1"""
    _a_global = 5 #local

    if _a_global >= 5:
        _b_global = _a_global + 5 #local
    
    _a_local = 4
    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _b_global is ", _b_global)
    print("Inside the function, the value of _a_local is ", _a_local)
    
    return None

a_function()

print("Outside the function, the value of _a_global is ", _a_global)
print("Outside the function, the value of _b_global is ", _b_global)


#block 2
print("block 2")
_a_global = 10

def a_function():
    """block 2"""
    _a_local = 4

    print("Inside the function, the value of _a_local is ", _a_local)
    print("Inside the function, the value of _a_global is ", _a_global)
    
    return None

a_function()
print("Outside the function, the value of _a_global is ", _a_global)

#block 3
print("block 3")
_a_global = 10

print("Outside the function, the value of _a_global is", _a_global)

def a_function():
    """block 3"""
    global _a_global
    _a_global = 5
    _a_local = 4
    
    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value _a_local is ", _a_local)
    
    return None

a_function()

print("Outside the function, the value of _a_global now is", _a_global)

#block 4
print("block 4")
def a_function():
    """block 4"""
    _a_global = 10
    
    def _a_function2():
        """block 4.1"""
        global _a_global
        _a_global = 20
    
    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()
    
    print("After calling _a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)

#block 5
print("block 5")
_a_global = 10

def a_function():
    """"block 5"""
    def _a_function2():
        """block 5.1"""
        global _a_global
        _a_global = 20
    
    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()
    
    print("After calling _a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)
