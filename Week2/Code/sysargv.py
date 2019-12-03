#!/usr/bin/env python3
"""Illustrate `sys.argv`"""

__appname__="sysargv.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

import sys
print("This is the name of the script: ", sys.argv[0])
print("Number of argument: ", len(sys.argv))
print("The arguments are: ", str(sys.argv))
