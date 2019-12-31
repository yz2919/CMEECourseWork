#!/bin/bash

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: yz2919_HPC_2019_cluster.sh
# Description: Call trial run on 'yz2919_HPC_2019_cluster.R'
# Arguments: 0
# Date: Nov 2019

#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run"
cp $HOME/HPC.R $TMPDIR
R --vanilla < $HOME/yz2919_HPC_2019_cluster.R
mv yz2919_output_* $HOME/results
echo "R has finished running"
# this is a comment at the end of the file

exit
