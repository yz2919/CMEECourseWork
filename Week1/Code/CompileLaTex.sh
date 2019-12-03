#!/bin/bash

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: CompileLaTeX.sh
# Description: Compile LaTeX script with bibliography file into pdf
# Arguments: 1
# Date: Oct 2019


pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
evince $1.pdf &

## Cleanup
rm *~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc
rm *.bbl
rm *.blg
