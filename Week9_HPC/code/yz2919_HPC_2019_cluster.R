#!/bin/env R

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: yz2919_HPC_2019_cluster.R
# Description: CMEE 2019 HPC excercises R code HPC run code proforma
# Arguments: 0
# Date: Nov 2019


rm(list=ls()) # good practice 
source("yz2919_HPC_2019_main.R")
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
set.seed(iter) # set random seed as iter
# iter<- sample(1:100, 1)
sizes <- c(500, 1000, 2500, 5000) # select your simulation parameter
size = sizes[(iter%%4)+1] 
interval_oct = size/10
burn_in_generations = 8*size
cluster_run(speciation_rate = 0.005177, 
            size,
            wall_time = 690,
            interval_rich = 1, 
            interval_oct, 
            burn_in_generations, 
            output_file_name = paste0("yz2919_",iter,".rda"))# do simulation
