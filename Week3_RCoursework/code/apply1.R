#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: apply1.R
# Desc: use `apply` to calculate the mean or variance of rows or columns of a matrix
# Arguments: 0
# Date: Oct 2019

## Build a random matrix
M <- matrix(rnorm(100), 10, 10)

## Take the mean of each row
RowMeans <- apply(M, 1, mean)
print (RowMeans)

## Variance
RowVars <- apply(M, 1, var)
print (RowVars)

## By column
ColMeans <- apply(M, 2, mean)
print (ColMeans)
