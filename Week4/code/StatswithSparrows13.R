#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: StatswithSparrows13.R
# Desc: Script for handout of StatsWithSparrows 13
# Arguments: 0
# Date: Oct 2019

rm(list=ls())
d<-read.table("../data/SparrowSize.txt", header=TRUE)
d1<-subset(d, d$Wing!="NA")
model1<-lm(Wing~Sex.1,data=d1)
summary(model1)
boxplot(d1$Wing~d1$Sex.1, ylab="Wing length (mm)")
anova(model1)
t.test(d1$Wing~d1$Sex.1, var.equal=TRUE)
boxplot(d1$Wing~d1$BirdID, ylab="Wing length (mm)")
require(dplyr)
tbl_df(d1)
glimpse(d1)
d$Mass %>% cor.test(d$Tarsus, na.rm=TRUE)
d1 %>%group_by(BirdID) %>%summarise (count=length(BirdID))%>%count(count)
#Run a linear model on a subset of data
model3<-lm(Wing~as.factor(BirdID), data=d1)
anova(model3)
boxplot(d$Mass~d$Year)
m2<-lm(d$Mass~as.factor(d$Year))
anova(m2)
summary(m2)
t(model.matrix(m2))
  