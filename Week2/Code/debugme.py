#!/usr/bin/env python3

"""Testing `%pdb`"""

__appname__= 'debugme.py'
__author__ = 'Yuqing Zhou (yz2919@imperial.ac.uk)'
__version__ = '0.0.1'
__license__= 'None'


def createabug(x):
    """create bug"""
    y = x**4
    z = 0.
    y = y/z
    return y

createabug(25)
