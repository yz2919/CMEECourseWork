#!/bin/bash
# Author: Yuqing Zhou y.zhou@imperial.ac.uk
# Script: run_MiniProject.sh
# Desc: run the workflow of miniproject
# Date: Mar 2020


echo -e "\nInstall some necessary packages\n"

python3 Data_preparation.py
Rscript NLLS_fitting.R
echo -e "\Running plotting script\n"
Rscript Plotting_Analysis.R
mv ../results/Aerobic\ Psychotropic._Raw\ Chicken\ Breast_2_1_2.png ../results/example.png

echo -e "\nGenerating report\n"
bash CompileLaTeX.sh report 2>/dev/null
