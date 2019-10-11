#!/bin/bash
#Author: Yuqing yz2919@imperial.ac.uk
#Script:tabtocsv.sh
#Description: substitute the tabs in the files with commas

#saves the output into a .csv file
#Arguments: 1 -> tab delimited file
#Date: Oct 2019

echo "Creating a comma delimited version of $1 ..."
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"
exit