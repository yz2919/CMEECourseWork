#!/bin/bash

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Description: Concatenate the contents of two files

# Arguments: 1
# Date: Oct 2019

cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3
