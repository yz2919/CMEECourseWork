# /usr/bin/env python


# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: run_fmr_R.py
# Desc: runs `fmr.R`
# Arguments: 0
# Date: Nov 2019

"""runs `fmr.R`"""

__appname__="profileme.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"
"""Running fmr.R from python"""


import subprocess

# Build subprocess command
cmd = ['Rscript', "--vanilla",'fmr.R']
try:
    # check_output will run the command and store to result
    x = subprocess.check_output(cmd, universal_newlines=True)
    print(x)
    print("Python successfully runs Rscript!")

except:
    print("Python failed to run Rscript......")
