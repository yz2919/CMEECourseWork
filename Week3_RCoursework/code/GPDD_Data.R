#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: GPDD_Data.R
# Desc: map locations from data on a world map
# Arguments: 0
# Date: Oct 2019


# Loads the maps package
library(maps)
library(ggplot2)
# Loads the GPDD data
load("../data/GPDDFiltered.RData")

# Creates a world map (use the map function, read its help
map(database = "world")
w<-map_data("world")
# Superimposes on the map all the locations from the GPDD dataframe
ggplot()+xlab("long")+ylab("lat")+
  geom_map(data = w,map = w,aes(map_id=region),fill="lightblue3")+
  geom_point(aes(x=gpdd$long,y=gpdd$lat),colour="indianred")+theme_bw()+
  expand_limits(x = w$long, y = w$lat)

# Answer:
# The location of inividuals cannot persuasively represent the niches of the species.

