#!/bin/bash

# Author: Yuqing Zhou
# Email: yz2919@imperial.ac.uk
# Script: yz2919_HPC_2019_cluster.sh
# Desc: call trial run on `yz2919_HPC_2019_main.R`
# Input: qsub -J 1-100 yz2919_HPC_2019_cluster.sh
# Output: none
# Arguments: 0
# Date: 28 Nov 2019

#PBS -l walltime=00:10:00
#PBS -l select=1:ncpus=1: mem=1gb
module load anaconda3/personal
echo "R is about to run"
R --vanilla < $HOME/Rtest/ForwardsNTC_V5.R
mv y_$1.rda $HOME
echo "R has finished running"
# this is a comment at the end of the file

exit