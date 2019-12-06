#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: TestR.py
# Desc: test to call R script from pyhton
# Arguments: 0
# Date: Nov 2019

"""test to call R script from pyhton"""

__appname__="TestR.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

import subprocess
subprocess.Popen("Rscript --verbose TestR.R > ../results/TestR.Rout 2> ../results/TestR_errFile.Rout", shell=True).wait()
