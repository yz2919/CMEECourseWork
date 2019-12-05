#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: Ricker.R
# Desc: a simulation of the Ricker model
# Arguments: 0
# Date: Oct 2019


Ricker <- function(N0=1, r=1, K=10, generations=50)
{
    # Runs a sumilation of the Ricker model
    # Returns a vector of length generations

    N <- rep(NA, generations)  # Creates a vector of NA

    N[1] <- N0
    for (t in 2:generations)
    {
        N[t] <- N[t-1] * exp(r*(1.0-(N[t-1]/K)))
    }
    return (N)
}

plot(Ricker(generations=10), type = "l")
