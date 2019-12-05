#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: break.R
# Desc: use `break` to stop the loop execution
# Arguments: 0
# Date: Oct 2019

i <- 0 #Initialize i
        while(i < Inf) {
                if (i == 10) {
                    break
                } # Break out of the while loop!
                    else{
                            cat("i equals " , i ," \n")
                            i <- i + 1 #Update i
            }
}
