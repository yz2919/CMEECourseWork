#!/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: dictionary.py
# Desc: populates a dictionary called taxa_dic derived from a given taxa.
# Arguments: 0
# Date: Oct 2019

"""Populates a dictionary called taxa_dic derived from a given taxa"""

__appname__="dictionary.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia'),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 

taxa_dic = {}
for i in taxa:
        taxa_dic.setdefault(i[1],set()).add(i[0])
print(taxa_dic)
