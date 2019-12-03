#!/usr/bin/env python3
""" Align two DNA sequences from fasta file"""
__appname__= 'align_seqs_better.py'
__author__ = 'Yuqing Zhou (yz2919@imperial.ac.uk)'
__version__ = '0.0.1'
__license__= 'None'

import sys
import pickle

seq1 = ""
seq2 = ""

if len(sys.argv) == 3:
    f1 = open(sys.argv[1], 'r')
    f2 = open(sys.argv[2], 'r')

    for line in f1:
        if not line.startswith('>'):
            seq1 = seq1 + line.strip('\n')
          
    for line in f2:
        if not line.startswith('>'):
            seq2 = seq2 + line.strip('\n')


else:
    path = "../Data"

    f1 = open(path+"/"+"407228326.fasta", "r") #open 407228326.fasta
    f2 = open(path+"/"+"407228412.fasta", "r") #open 407228412.fasta

    for line in f1:
        if not line.startswith('>'):
            seq1 = seq1 + line.strip('\n')
          
    for line in f2:
        if not line.startswith('>'):
            seq2 = seq2 + line.strip('\n')
         

f1.close()
f2.close()


l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths


def calculate_score(s1, s2, l1, l2, startpoint):
    """computes a score by returning the number of matches starting from arbitrary startpoint (chosen by user)"""
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
#    print("." * startpoint + matched)           
#    print("." * startpoint + s2)
#    print(s1)
#    print(score) 
#    print(" ")

    return score

# find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1


best_output = []

for i in range(l1): 
    z = calculate_score(s1, s2, l1, l2, i)
    if z == my_best_score:
        my_best_align = "." * i + s2 
        my_best_score = z 
        best_output.append(my_best_align)
        best_output.append(s1)
        best_output.append("Best score:" + str(my_best_score) + '\n')
    elif z > my_best_score:
        best_output = []
        my_best_align = "." * i + s2 
        my_best_score = z 
        best_output.append(my_best_align)
        best_output.append(s1)
        best_output.append("Best score:" + str(my_best_score) + '\n')

f = open('../results/my_best.p','wb') ## note the b: accept binary files
pickle.dump(best_output, f)
f.close()

## Load the data again
f = open('../results/my_best.p','rb')
my_best_align = pickle.load(f)
f.close()


def main(argv):
    print(calculate_score(s1, s2, l1, l2, 2))
    print(my_best_align)
    print(s1)
    print("Best score:", my_best_score)
    return 0

if(__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
