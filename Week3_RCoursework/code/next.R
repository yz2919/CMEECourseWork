#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: next.R
# Desc: prints odd number in 1~10 using the "modulo" operation
# Arguments: 0
# Date: Oct 2019


for (i in 1:10) {
    if ((i %% 2) == 0)
        next # pass to next iteration of loop
    print(i)
}
