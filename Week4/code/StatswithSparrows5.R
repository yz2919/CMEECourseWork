#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: StatsWithSparrows5.R
# Desc: Script for handout of StatsWithSparrows 5
# Arguments: 0
# Date: Oct 2019

rm(list=ls())
d<-read.table("../data/SparrowSize.txt", header=TRUE)
boxplot(d$Mass~d$Sex.1, col = c("red", "blue"), ylab="Body mass (g)")
t.test1 <- t.test(d$Mass~d$Sex.1)
t.test1
d1<-as.data.frame(head(d, 50))
length(d1$Mass)
t.test2 <- t.test(d1$Mass~d1$Sex)
t.test2

## Excercise
d2<-subset(d, d$Year==2001)
library(ggplot2)
