#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: 04_Demography.R
# Desc: inferring the history of a population of sea turtles
# Arguments: 0
# Date: Nov 2019

turtle <- as.matrix(read.csv("../data/turtle.csv", header = FALSE, stringsAsFactors= FALSE))
#calculate freq
fa <- apply(X=turtle[1:20,], MAR=2, FUN=sum)
fa <- fa/20

fb <- apply(X=turtle[21:40,], MAR=2, FUN=sum)
fb <- fb/20

fc <- apply(X=turtle[41:60,], MAR=2, FUN=sum)
fc <- fc/20

fd <- apply(X=turtle[61:80,], MAR=2, FUN=sum)
fd <- fd/20

#Fst ab
Hs_ab <- (2*fa*(1-fa) + 2*fb*(1-fb))/2
Ht_ab <- 2 *(fa+fb)*(1-(fa+fb)/2)/2
FST_ab <- (Ht_ab-Hs_ab)/Ht_ab
FST_ab <- mean(FST_ab, na.rm=TRUE)

#FST ac
Hs_ac <- (2*fa*(1-fa) + 2*fc*(1-fc))/2
Ht_ac <- 2 *(fa+fc)*(1-(fa+fc)/2)/2
FST_ac <- (Ht_ac-Hs_ac)/Ht_ac
FST_ac <- mean(FST_ac, na.rm=TRUE)

#FST ad
Hs_ad <- (2*fa*(1-fa) + 2*fd*(1-fd))/2
Ht_ad <- 2 *(fa+fd)*(1-(fa+fd)/2)/2
FST_ad <- (Ht_ad-Hs_ad)/Ht_ad
FST_ad <- mean(FST_ad, na.rm=TRUE)

#FST bc
Hs_bc <- (2*fc*(1-fc) + 2*fb*(1-fb))/2
Ht_bc <- 2 *(fc+fb)*(1-(fc+fb)/2)/2
FST_bc <- (Ht_bc-Hs_bc)/Ht_bc
FST_bc <- mean(FST_bc, na.rm=TRUE)

#FST bd
Hs_bd <- (2*fd*(1-fd) + 2*fb*(1-fb))/2
Ht_bd <- 2 *(fd+fb)*(1-(fd+fb)/2)/2
FST_bd <- (Ht_bd-Hs_bd)/Ht_bd
FST_bd <- mean(FST_bd, na.rm=TRUE)

#FST cd
Hs_cd <- (2*fc*(1-fc) + 2*fd*(1-fd))/2
Ht_cd <- 2 *(fc+fd)*(1-(fc+fd)/2)/2
FST_cd <- (Ht_cd-Hs_cd)/Ht_cd
FST_cd <- mean(FST_cd, na.rm=TRUE)


#FST function
FST_func <- function(fa,fb){
  fa <- (apply(X=turtle[1:20,], MAR=2, FUN=sum))/nrow(fa)
  fb <- (apply(X=turtle[1:20,], MAR=2, FUN=sum))/nrow(fb)
  Hs_ab <- (2*fa*(1-fa) + 2*fb*(1-fb))/2
  Ht_ab <- 2 *(fa+fb)*(1-(fa+fb)/2)/2
  FST_ab <- (Ht_ab-Hs_ab)/Ht_ab
  FST_ab <- mean(FST_ab, na.rm=TRUE)
  
  return(FST_ab)
}


snps <- which(apply(FUN=sum, X=turtle, MAR=2)/(nrow(turtle))>0.03)

cat("\nFST value (average):",
    "\nA vs B", mean(FST_func(turtle[1:20,snps], turtle[21:40,snps]), na.rm=T),
    "\nA vs C", mean(FST_func(turtle[1:20,snps], turtle[41:60,snps]), na.rm=T),
    "\nA vs D", mean(FST_func(turtle[1:20,snps], turtle[61:80,snps]), na.rm=T),
    "\nB vs C", mean(FST_func(turtle[21:40,snps], turtle[41:60,snps]), na.rm=T),
    "\nB vs D", mean(FST_func(turtle[21:40,snps], turtle[61:80,snps]), na.rm=T),
    "\nC vs D", mean(FST_func(turtle[41:60,snps], turtle[61:80,snps]), na.rm=T),"\n")




