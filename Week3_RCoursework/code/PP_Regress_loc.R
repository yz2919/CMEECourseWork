#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: PP_Regress_loc.R
# Desc: R coursework practicals extra credit. An analysis of Linear regression on subsets of the data corresponding to available Feeding Type × Predator life Stage × Location combination
# Arguments: 0
# Date: Dec 2019
#install.packages("broom")

#library(broom)
require(ggplot2)
require(dplyr)
# load data
MyDF <- as.data.frame(read.csv('../data/EcolArchives-E089-51-D1.csv'))
for(i in 1:dim(MyDF)[1]){
  if(as.character(MyDF[i,14])=="mg"){
    MyDF[i,13]<-MyDF[i,13]/1000
    MyDF[i,14]<-"g"
  }
}

# saving regression data
MyDF1<-as.data.frame(
  matrix(nrow = 
           length(unique(MyDF$Type.of.feeding.interaction))*
           length(unique(MyDF$Predator.lifestage))*
           length(unique(MyDF$Location)), ncol = 10))
# linear regression
MyDF2<- MyDF%>% group_by(Type.of.feeding.interaction,Predator.lifestage,Location)%>%do(mod = lm(log(Predator.mass) ~ log(Prey.mass), data=.))
MyDF2<-MyDF2%>%mutate(Slope = summary(mod)$coeff[2],
               Intercept = summary(mod)$coeff[1],
               R.squared = summary(mod)$r.squared,
               P.value=summary(mod)$coeff[8],
               F.statistic=as.numeric(summary(mod)$fstatistic)[1]
               )%>%select(Type.of.feeding.interaction,
                          Predator.lifestage,Location,
                          Slope,Intercept,
                          R.squared,F.statistic, P.value)
MyDF2$Location<-gsub(",",";",MyDF2$Location)

write.csv(MyDF2,"../results/PP_Regress_loc_Results.csv",row.names = FALSE,quote = FALSE)
