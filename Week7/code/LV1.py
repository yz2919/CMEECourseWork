# plotting Lotka-Volterra model figures.

# Solving LV model using numerica intergarion
import scipy as sc
import scipy.integrate as integrate

#define a function that returns the growth rate of consumer and resource population at any given time step
def dCR_dt(pops, t=0):

    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

# Assign parameter values
r = 1.
a = 0.1
z = 1.5
e = 0.75

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

with PdfPages('../results/LV_model.pdf') as pdf:
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
    p.title('Consumer-Resource population dynamics')

    pdf.savefig(f2)

