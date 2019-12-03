#!/bin/bash

# Author: Yuqing yz2919@imperial.ac.uk
# Script: tabtocsv.sh
# Description: Convert tiff to `.jpg`
# Arguments: 1
# Date: Oct 2019

for f in *.tif;
    do
        echo "Converting $f";
        convert "$f"  "$(basename "$f" .tif).jpg";
    done
