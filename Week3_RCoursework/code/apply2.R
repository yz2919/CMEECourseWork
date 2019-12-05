#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: apply2.R
# Desc: use `apply` to define a function `SomeOperation`
# Arguments: 0
# Date: Oct 2019

SomeOperation <- function(v){ # (What does this function do?)
    if(sum(v) > 0){
        return (v * 100)
    }
    return(v)
    }

M <- matrix(rnorm(100), 10, 10)
print (apply(M, 1, SomeOperation))
