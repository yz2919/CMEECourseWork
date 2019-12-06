#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: get_TreeHeight.R
# Desc: takes a `.csv` file name from the command line and calculate tree height.
# Arguments: 0
# Date: Oct 2019

# This function calculates heights of trees given distance of each tree
# from its bas and angle to its top, using the trigometric formula
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees: The andgle of elevation of tree
# distance: The distance from base of tree (e.g., meters)

# OUTPUT
# The heights of the tree, same units as "distance"

TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    print(paste("Tree height is:", height))

    return (height)
}

# TreeHeight(37,40)

# Write output
args=(commandArgs(TRUE))
if(length(args)==0){ # if no argument, load `trees.csc`
  args<-"../data/trees.csv"
}
Filen <- sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(args))
TreeData <- read.csv(args)

TreeData$Tree.Height.m <- TreeHeight(TreeData$Angle.degrees, TreeData$Distance.m)

write.csv(TreeData, paste0("../results/",Filen,"_treeheights.csv"), row.names=FALSE)
