#!/bin/env python3

# Author: Yuqing Zhou y.zhou19@imperial.ac.uk
# Script: Data_preparation.py
# Desc: imports the data and prepares it for NLLS fitting
# Input: 
# Output: 
# Arguments: 0
# Date: Jan 2020

"""
Imports the data, prepares it for NLLS fitting.
"""

__appname__="Data_preparation.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

import pandas as pd
import scipy as sc
import numpy as np
from numpy import *

# imports the data, prepares it for NLLS fitting
data = pd.read_csv("../data/LogisticGrowthData.csv")




# Creates unique ids so that you can identify unique datasets 
# (e.g., single thermal responses or functional responses). 
# This may not always be necessary 
# because your data might already contain a field that delineates single curves 
# (e.g., an ID field/column)
#data = data.assign(ID = (data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation + "_" + data.Rep.map(str)).astype('category').cat.codes)
#data = data.assign(ID = (data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation + "_" + data.Rep.map(str)).astype('category'))
data['Citation'] = (data.Citation).astype('category').cat.codes #creates unique id for citation for saving figures latter
#data.insert(0, "ID", data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation + "_" + data.Rep.map(str))

# Filters out datasets with less than x data points, 
# where x is the minimum number of data points needed to fit the models. 
# Note that this step is not necessary because in any case, 
# the model fitting (or estimation of goodness of fit statistics) 
# will fail for datasets with small sample sizes anyway, 
# and you can then filter these datasets after 
# the NLLS fitting script (see below) has finished running and you are in the analysis phase.



# Deals with missing, and other problematic data values.
## filter negative value
data = data.loc[data['PopBio'] > 0]
data['LogN']=np.log(data.PopBio, where=data.PopBio > 0) # log the population
data['Log10N']=np.log10(data.PopBio, where=data.PopBio > 0)


# Saves the modified data to one or more csv file(s).
data.to_csv('../data/Sorteddata.csv', index=False)