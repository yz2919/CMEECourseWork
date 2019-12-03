#!/bin/bash

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: CountLines.sh
# Desc: Count number of lines in the input file

# Arguments: 1
# Date: Oct 2019

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo
