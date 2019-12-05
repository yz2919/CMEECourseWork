#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: preallocate.R
# Desc: compare function speed with & without preallocation
# Arguments: 0
# Date: Oct 2019


a <- NA
for (i in 1:10) {
  a <- c(a, i)
  print(a)
  print(object.size(a))
}

a <- rep(NA,10)

for (i in 1:10){
  a[i] <- i
  print(a)
  print(object.size(a))
}
