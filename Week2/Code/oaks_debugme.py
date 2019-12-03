#!/usr/bin/env python3

"""Find oaks from list"""
__appname__= 'oaks_debugme.py'
__author__ = 'Yuqing Zhou (yz2919@imperial.ac.uk)'
__version__ = '0.0.1'
__license__= 'None'

import csv
import sys
import ipdb
import doctest

#Define function
def is_an_oak(name):
    """ Returns True if name is starts with 'quercus'
    >>> is_an_oak("Quercus robur")
    True
    >>> is_an_oak("Quercuss robur")
    False
    >>> is_an_oak("Quearcus robur")
    False
    >>> is_an_oak("Qurcus robur")
    False
    """
    return name.lower().startswith('querc') if len(name.split()[0]) <= 7 else False

def main(argv): 
    """main"""
    f = open('../data/TestOaksData.csv','r')
    g = open('../data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
#    oaks = set()
    for row in taxa:
#        ipdb.set_trace()
        if row[0] == 'Genus':
            csvwrite.writerow([row[0], row[1]])
        if row[0] != 'Genus':
#        print(row)
            print ("The genus is: ")
            print(row[0] + '\n')
            
            if is_an_oak(row[0]):
                print('FOUND AN OAK!\n')
                csvwrite.writerow([row[0], row[1]])
    csvwrite.writerow([row[0], row[1]])

    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)
