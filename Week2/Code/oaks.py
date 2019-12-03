#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: oasks.py
# Desc: finds oak trees from a list of species
# Arguments: 0
# Date: Oct 2019

"""Finds taxa of oak trees from a list of species"""

__appname__="oaks.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

## Finds just those taxa that are oak trees from a list of species

taxa = [ 'Quercus robur',
         'Franxinus excelsior',
         'Pinus sylvestris',
         'Quercus cerris',
         'Quercus petraea',
        ]
def is_an_oak(name):
    """find oak"""
    return name.lower().startswith('quercus ')

##Using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

##Using list comprehensions
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

##Get names in UPPER CASE using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

##Get names in UPPER CASE using list comprehensions
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)
