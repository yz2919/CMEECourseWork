#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: TreeHeight.R
# Desc: calculate tree heights given distance of each tree from its base and angle to its top and write output into `TreeHts.csv` file
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

TreeData <- read.csv("../data/Trees.csv")

TreeData$Tree.Height.m <- TreeHeight(TreeData$Angle.degrees, TreeData$Distance.m)

write.csv(TreeData, file = "../results/TreeHts.csv",row.names=FALSE)
