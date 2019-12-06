#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: StatswithSparrows17.R
# Desc: Script for handout of StatsWithSparrows 17 on non-parametric statistics
# Arguments: 0
# Date: Oct 2019

#Chi-square test
hairEyes<-matrix(c(34,59,3,10,42,47),ncol=2,
                 dimnames=list(Hair=c("Black","Brown","Blond"),
                               Eyes=c("Brown","Blue")))
hairEyes
rowTot<-rowSums(hairEyes)
colTot<-colSums(hairEyes)
tabTot<-sum(hairEyes)
Expected<-outer(rowTot,colTot)/tabTot
cellChi<-(hairEyes-Expected)^2/Expected
tabChi<-sum(cellChi)
tabChi
1-pchisq(tabChi,df=2)
hairChi<-chisq.test(hairEyes)
print(hairChi)
