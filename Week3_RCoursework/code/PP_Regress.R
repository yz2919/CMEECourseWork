#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: PP_Regress.R
# Desc: R coursework practicals. An analysis of Linear regression on subsets of the data corresponding to available Feeding Type × Predator life Stage combination.
# Arguments: 0
# Date: Oct 2019
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
ybreak<-c(1e-6,1e-2,1e+2,1e+6)
xbreak<-c(1e-7,1e-3,1e+1)
# plot
pdf("../Results/PP_Regress.pdf",height = 10, width = 8)
qplot(Prey.mass,Predator.mass, data=MyDF, 
      colour = Predator.lifestage,shape=I(3),
      geom = "point",
      xlab = "Prey mass in grams", 
      ylab = "Predator mass in grams") + 
      geom_smooth(method = "lm", size=0.4,fullrange = TRUE)+
      facet_grid(Type.of.feeding.interaction ~ .) +
      scale_x_continuous(trans="log10",breaks = xbreak)+
      scale_y_continuous(trans="log10",breaks = ybreak)+
      theme_bw()+theme(panel.border = element_rect(colour = "grey60"),
                       axis.ticks = element_line(colour = "grey60"),
                       strip.background = element_rect(colour = "grey40", 
                                                       fill = "grey80"),
                       plot.margin = margin(.5, 5, .5, 5, "cm"),
                       legend.position = "bottom",
                       legend.title = element_text(face = "bold"),
                       panel.grid.minor = element_blank())+
      guides(colour = guide_legend(nrow = 1))
dev.off()

# saving regression data
MyDF1<-as.data.frame(
  matrix(nrow = 
           length(unique(MyDF$Type.of.feeding.interaction))*
           length(unique(MyDF$Predator.lifestage)), ncol = 7))
# linear regression
MyDF2<- MyDF%>% group_by(Type.of.feeding.interaction,Predator.lifestage)%>%do(mod = lm(log(Predator.mass) ~ log(Prey.mass), data=.))
MyDF2<-MyDF2%>%mutate(Slope = summary(mod)$coeff[2],
               Intercept = summary(mod)$coeff[1],
               R.squared = summary(mod)$r.squared,
               P.value=summary(mod)$coeff[8],
               F.statistic=as.numeric(summary(mod)$fstatistic)[1]
               )%>%select(Type.of.feeding.interaction,
                          Predator.lifestage,
                          Slope,Intercept,
                            R.squared, F.statistic, P.value)


write.csv(MyDF2,"../results/PP_Regress_Results.csv",row.names = FALSE,quote = FALSE)
