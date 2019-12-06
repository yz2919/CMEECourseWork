#!/usr/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: LV2.py
# Desc: runs the LV model with prey density dependence
# Arguments: 0
# Date: Nov 2019

"""Runs the LV model with prey density dependence"""

__appname__="LV1.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"
"""......"""
# plotting Lotka-Volterra model figures.

# Solving LV model using numerica intergarion
import sys
import scipy as sc
import scipy.integrate as integrate

#define a function that returns the growth rate of consumer and resource population at any given time step
def dCR_dt(pops, t=0):
    """returns the growth rate of consumer and resource population at any given time step"""
    R = pops[0]
    C = pops[1]
    dRdt = r * R * (1 - R/K) - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

# Assign parameter values

if len(sys.argv) != 5:
    r = 1.
    a = 0.1
    z = 1.5
    e = 0.75
else:
    r = float(sys.argv[1])
    a = float(sys.argv[2])
    z = float(sys.argv[3])
    e = float(sys.argv[4])
K = 50

    
# Integrate from time point 0 to 15, using 1000 sub-divisions of time.
t = sc.linspace(0,15,1000)

# Set the initial condition for the 2 populations(10 resources and 5 consumers per unit area), and convert the two into an array.
R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])

# Numerically integrate this system forward from those starting conditions:
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)


# Plotting
import matplotlib.pylab as p
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

with PdfPages('../results/LV2_model.pdf') as pdf:
    # LV_model_pdf = r'../results/LV_model.pdf'
    f1 = p.figure() # open an empty figure object.
    p.plot(t, pops[:,0], 'g-', label = 'Resource density')
    p.plot(t, pops[:,1], 'b-', label = 'Consumer density')
    p.grid()
    p.legend(loc='best')
    p.xlabel('Time')
    p.ylabel('Population density')
    p.title('Consumer-Resource population dynamics')


# f1.savefig('../results/LV_model.pdf') # Save figure
    pdf.savefig(f1)

    f2 = p.figure() # open an empty figure object.

    p.plot(pops[:,0], pops[:,1], 'r-')
    p.grid()
    p.xlabel('Resource density')
    p.ylabel('Consumer density')
    p.title('Consumer-Resource population dynamics\n r = %s, a = %s, z = %s, e = %s, K = %s' %(r, a, z, e, K))
   

    pdf.savefig(f2)

