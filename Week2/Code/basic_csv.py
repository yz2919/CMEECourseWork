#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: basic_csv.py
# Desc: write a `.csv` file containing only species name and Body mass from a `.csv` file containing 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male (Kg)'
# Arguments: 0
# Date: Oct 2019

"""Write a `.csv` file containing only species name and Body mass from a `.csv` file containing 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male (Kg)'"""

__appname__="basic_csv.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

import csv

# Read a file containing:
# 'Species','Infraorder', 'Family', 'Distribution', 'Body mass male (Kg)'
f = open('../Data/testcsv.csv','r')

csvread = csv.reader(f)
temp = []
for row in csvread:
    temp.append(tuple(row))
    print(row)
    print("The species is", row[0])

f.close()

# write a file containing only speceis name and Body mass
f = open('../Data/testcsv.csv','r')
g = open('../Data/bodymass.csv','w')

csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()
