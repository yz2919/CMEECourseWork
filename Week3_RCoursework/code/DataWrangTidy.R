#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: DataWrangTidy.R
# Desc: use `dplyr` and `tidyr` instead of `reshape2` for wrangling dataset
# Arguments: 0
# Date: Oct 2019

################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################
#Packages utlized
install.packages("tidyr")
library(dplyr)
library(tidyr)
library(utils)
require(dplyr)
require(tidyr)
require(utils)


############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../data/PoundHillData.csv",header = F)) 

# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv",header = T, sep=";", stringsAsFactors = F)

############# Inspect the dataset ###############
dplyr::tbl_df(MyData)
dim(MyData)
dplyr::glimpse(MyWrangledData) #like str()
utils::View(MyWrangledData) #same as fix()

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) 
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData %>% replace_na(0)

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
#Starts from -1 because deleting the column name
colnames(TempData) <- MyData[1,] # assign column names from original data

############# Convert from wide to long format  ###############
?gather #check out the gather function

# gather() instead of melt()
MyWrangledData <- gather(TempData, Species, Count, -Cultivation, -Block, -Plot, -Quadrat)

# Using mutate in dplyr to convert multiple columns
MyWrangledData <- MyWrangledData %>% mutate_at(c("Cultivation","Block","Plot","Quadrat"), as.factor)
MyWrangledData <- MyWrangledData %>% mutate(Count=as.integer(Count))

dplyr::glimpse(MyWrangledData) #like str()
dplyr::tbl_df(MyWrangledData) #like head()


############# Exploring the data (extend the script below)  ###############
