#!/usr/bin/env python3
# Filename: using_name.python
"""Illustrate `__name__ == '__main__'`"""

__appname__="using_name.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

if __name__ == '__main__':
    print('This program is being run by itself')
else:
    print('I am being imported from another module')
