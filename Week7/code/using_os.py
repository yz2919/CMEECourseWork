#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: using_os.py
# Desc: get a list of files and directories in home directory that start with C or c
# Arguments: 0
# Date: Nov 2019

"""get a list of files and directories in home directory that start with C or c"""

__appname__="using_os.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

""" This is blah blah"""

# Use the subprocess.os module to get a list of files and  directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess
import re

#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithC = []
DirsStartingWithC = []
# Use a for loop to walk through the home directory.
for (dir, subdir, files) in subprocess.os.walk(home):
  
#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:
    FilesDirsStartingWithC.extend(re.findall(r'/[Cc]\w+/',str(dir)))
    FilesDirsStartingWithC.extend(re.findall(r'[Cc]\w+', str(subdir)))    
    FilesDirsStartingWithC.extend(re.findall(r'[Cc]\w+', str(files)))

    print(FilesDirsStartingWithC)


#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:
    DirsStartingWithC.extend(re.findall(r'/[Cc]\w+/',str(dir)))
    DirsStartingWithC.extend(re.findall(r'[Cc]\w+', str(subdir)))
    print(DirsStartingWithC)
