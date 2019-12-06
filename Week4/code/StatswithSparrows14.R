#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: StatswithSparrows14.R
# Desc: Script for handout of StatsWithSparrows 14
# Arguments: 0
# Date: Oct 2019

rm(list=ls())
d<-read.table("../data/SparrowSize.txt", header=TRUE)
d1<-subset(d, d$Wing!="NA")
model3<-lm(Wing~as.factor(BirdID), data=d1)
require(dplyr)
d1 %>%group_by(BirdID) %>%summarise (count=length(BirdID))
d1 %>%group_by(BirdID) %>%summarise (count=length(BirdID))%>%summarise (sum(count^2))
(1/617)*(1695-7307/1695)
anova(model3)
print("Therepeatability is ")
((13.20-1.62)/2.74)/(1.62+(13.20-1.62)/2.74)
