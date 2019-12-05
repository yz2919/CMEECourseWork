#!/bin/bash

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: run_get_TreeHeight.sh
# Desc: test `get_TreeHeight.R`, include `trees.csv` as example file
# Arguments: 1
# Date: Oct 2019

if [ "$1" = "" ]; then
echo "NO INPUT, used ../data/trees.csv as example file."
Rscript get_TreeHeight.R ../data/trees.csv
else 
Rscript get_TreeHeight.R $1
exit 0

fi

