#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: blackbirds.py
# Desc: find Kingdom, Phylum and Species names in the `.txt` file
# Arguments: 0
# Date: Nov 2019

"""find Kingdom, Phylum and Species names in the `.txt` file"""

__appname__="blackbirds.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

import re

# Read the file (using a different, more python 3 way, just for fun!)
with open('../data/blackbirds.txt', 'r') as f:
    text = f.read()

# replace \t's and \n's with a spaces:
text = text.replace('\t',' ')
text = text.replace('\n',' ')
# You may want to make other changes to the text. 

# In particular, note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform to ASCII:

text = text.encode('ascii', 'ignore') # first encode into ascii bytes
text = text.decode('ascii', 'ignore') # Now decode back to string

# Now extend this script so that it captures the Kingdom, Phylum and Species
# name for each species and prints it out to screen neatly.

my_reg = r"(Kingdom\s+\w+)(?=.*?(Phylum\s+\w+))(?=.*?(Species\s+\w+\s+\w+))"
found_matches = re.findall(my_reg,text)
print(found_matches)

# Hint: you may want to use re.findall(my_reg, text)... Keep in mind that there
# are multiple ways to skin this cat! Your solution could involve multiple
# regular expression calls (easier!), or a single one (harder!)
