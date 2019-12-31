# CMEE 2019 HPC excercises R code challenge G proforma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

name <- "Yuqing Zhou"
preferred_name <- "Yuqing"
email <- "yz2919@imperial.ac.uk"
username <- "yz2919"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here

plot.new();f=function(x=.3,y=0,d=pi/2,l=.1,g=1){lines(c(x,a<-x+l*cos(d)),c(y,b<-y+l*sin(d)));if(l>.001){f(a,b,d+g*pi/4,.38*l,g);f(a,b,d,.87*l,-g)}};f()

