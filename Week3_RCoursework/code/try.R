#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: try.R
# Desc: blocks of code illustrating `try`
# Arguments: 0
# Date: Oct 2019

doit <- function(x){
        temp_x <- sample(popn, replace = TRUE)
        if(length(unique(temp_x)) > 30){# only take mean if sample was sufficient
            print(paste("Mean of this sample was:", as.character(mean(temp_x))))
        }
    else {
        stop("Couldn't calculate mean: too few unique value!")
    }
        
}

popn <- rnorm(50) # Generate population

lapply(1:15, function(i) doit(popn))
result <- lapply(1:15, function(i) try(doit(popn), FALSE))

class(result)
result

result <- vector("list", 15) # Preallocate/Initialize
for(i in 1:15) {
    result[[i]] <- try(doit(popn), FALSE)
}