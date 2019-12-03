#!/bin/bash

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: variables.sh
# Description: Examples of assigning values to variables
# Arguments: interactive
# Date: Oct 2019

# Shows the use of variables
MyVar='some string'
echo 'the current value of the variable is' $MyVar
echo 'Please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVar

## Reading multiple values
echo 'Enter two numbers sperated by space(s)'
read a b
echo 'you entered' $a 'and' $b '. Their sum is:'mysum=`expr $a + $b`
echo $mysum
