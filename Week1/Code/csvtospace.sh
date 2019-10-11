#!/bin/bash
# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: csvtospace.sh
# Description: converts a comma separated values file to a space separated values file
#
# Date: Oct 2019

for f in $1;
    do
        echo -e "Converting $f";
        cat $f | tr -s "," " " >> $f.txt;
        echo "Done"
    done

#exit