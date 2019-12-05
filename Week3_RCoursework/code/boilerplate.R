#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: boilerplate.R
# Desc: illustrates how R function accepts "arguments" and "return" values
# Arguments: 0
# Date: Oct 2019

# A boilerplate R script

MyFunction <- function(Arg1, Arg2){

    # Statments involving Arg1, Arg2:
    print(paste("Argument", as.character(Arg1), "is a", class(Arg1)))
    print(paste("Argument", as.character(Arg2), "is a", class(Arg2)))

    return (c(Arg1, Arg2)) #Optional but useful
}

MyFunction(1,2) # Test the function
MyFunction("Riki","Tiki") # A diff. test
