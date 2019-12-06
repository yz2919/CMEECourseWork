#!/usr/bin/env python3

""" Align two DNA sequences"""
__author__ = 'Yuqing Zhou (yz2919@imperial.ac.uk)'
__version__ = '0.0.1'

import sys
import csv

seq1 = []
seq2 = []

with open('../Data/testalign.csv','r') as csvfile:
    csvread = csv.reader(csvfile)
    i = list(i for i in csvread)
    seq1 = "".join(i[0])
    seq2 = "".join(i[1])


seq1 = str(seq1)
seq2 = str(seq2)

print(seq1)
print(seq2)


l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1

def calculate_score(s1, s2, l1, l2, startpoint=1):
    """computes a score by returning the number of matches starting from arbitrary startpoint (chosen by user)"""
    matched = "" 
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"
    
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

my_best_align = None
my_best_score = -1

for i in range(l1):
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # think about what this is doing!
        my_best_score = z 
print(my_best_align)
print(s1)
print("Best score:", my_best_score)

def main(argv):
    """main argv"""
    print(calculate_score(s1, s2, l1, l2, 2))
    print(my_best_align)
    print(s1)
    print("Best score:", my_best_score)
    return 0

if(__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
