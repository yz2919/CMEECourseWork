# /usr/bin/env python
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
