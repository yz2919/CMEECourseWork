#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: StatswithSparrows18.R
# Desc: Script for handout of StatsWithSparrows 18 on observer repeatability
# Arguments: 0
# Date: Oct 2019


a<-read.table("../data/ObserverRepeatability.txt", header=T)
require(dplyr)
a %>%group_by(StudentID) %>%summarise (count=length(StudentID))%>%
  summarise (length(StudentID))
a %>%group_by(StudentID) %>%summarise (count=length(StudentID))%>%
  summarise (sum(count))
length(a$StudentID)
a %>%group_by(StudentID) %>%summarise (count=length(StudentID))%>%
  summarise (sum(count^2))
#check mean squares
mod<-lm(Tarsus~StudentID,data=a)
anova(mod)
# bill width
mod<-lm(Tarsus~Leg+Handedness+StudentID,data=a)
anova(mod)
require(lme4)
lmm<-lmer(Tarsus~Leg+Handedness+(1|StudentID),data=a)
summary(lmm)
