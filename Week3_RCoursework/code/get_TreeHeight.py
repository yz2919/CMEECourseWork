#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: get_TreeHeight.py
# Desc: takes a `.csv` file name from the command line and calculate tree height, a python version of `get_TreeHeight.R`
# Arguments: 0
# Date: Dec 2019

"""takes a `.csv` file name from the command line and calculate tree height"""

__appname__="get_TreeHeight.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

import math
import sys
import csv
import re
import os
import pandas as pd

def TreeHeight(degrees,distance):
    """calculates heights of trees given distance of each tree
    from its bas and angle to its top, using the trigometric formula"""
    radians = degrees * math.pi / 180
    height = distance * math.tan(radians)
    # print("Tree height is: %d" %height)

    return height

# TreeHeight(37,40)

if len(sys.argv) > 1:
    f = open(sys.argv[1], 'r') # open argv file
    Filen=os.path.splitext(os.path.basename(sys.argv[1]))[0] #define new filename
else:
    f = open("../data/trees.csv","r") # open `trees.csv` if no argument
    Filen = "trees" 

Treedata = list(csv.reader(f))
# Treedata.apply(TreeHeight(Treedata["Angle.degrees"].astype(float), Treedata["Distance.m"]),axis=1)
# Treedata["Tree.Height.m"] = TreeHeight(Treedata["Angle.degrees"].astype(float), Treedata["Distance.m"].astype(float))

for row in range(len(Treedata)):
    if row == 0:
        Treedata[row].append("Tree.Height.m")
    else:
        Treedata[row].append(TreeHeight(float(Treedata[row][2]), float(Treedata[row][1])))

with open(str("../results/"+Filen+"_treeheights.csv"), 'w',newline='') as myfile:
     wr = csv.writer(myfile)
     for i in range(len(Treedata)):
        wr.writerow(Treedata[i])


def main(argv):
    """main argv"""
    print("Done")
    return 0

if(__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
