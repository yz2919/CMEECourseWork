#!/usr/bin/env python3

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: Nets.py
# Desc: visualizes the QMEE CDT collaboration network
# Arguments: 0
# Date: Nov 2019
"""visualizes the QMEE CDT collaboration network"""

__appname__="Nets.py"
__author__="Yuqing Zhou"
__version__="0.0.1"
__license__="None"


# import package
import matplotlib.pyplot as plt
import networkx as nx 
import csv
import pandas as pd
import scipy as sc
from matplotlib.lines import Line2D

# load data
links=pd.read_csv('../data/QMEE_Net_Mat_edges.csv')
nodes=pd.read_csv('../data/QMEE_Net_Mat_nodes.csv')
ndn=list(nodes.id)
# links=sc.matrix(links)
#Create graph object
G=nx.Graph()

# link 
lklist = []
for i in range(len(links)):
    for j in range((i+1),len(links)):
        if links.iloc[i][j] > 0:
            lklist.append((links.columns[i],links.columns[j],links.iloc[i][j]))
    

# nodes
# Generate colors based on partner type:
colrs = []
for i in nodes.Type:
    if i == "University":
        colrs.append("blue")
    elif i =="Hosting Partner":
        colrs.append("green")
    else: colrs.append("red")


# Set node size based on Number of PIs:
# V(net)$size <- V(net)$Pis*0.9

# V(net)$size <- 50

# Set edge width based on weight (PhD Students):
# E(net)$width <- E(net)$weight

#change arrow size and edge color:
# E(net)$arrow.size <- 1
# E(net)$edge.color <- "gray80"

# E(net)$width <- 1+E(net)$weight/10
edgewidth = [1+i[2]/10 for i in lklist]

G.add_nodes_from(ndn)
G.add_weighted_edges_from(tuple(lklist))
G1=nx.circular_layout(ndn)
# plotting
f=plt.figure(figsize=(6,6))
pos = nx.spring_layout(G)

nx.draw_networkx(G,pos=pos,node_size=2100,node_color=colrs, 
                edge_color="grey",width=edgewidth,with_labels=True)
plt.legend(("University","Hosting Partner", "Non-hosting Partner"),loc='best',scatterpoints=1, ncol=1,fontsize=8)
plt.axis('off')
f.savefig("../results/QMEENet_yz2919.svg")

# plot(net, edge.curved=0, vertex.label.color="black") 

# legend(x=-1.5, y=-0.1, c("University","Hosting Partner", "Non-hosting Partner"), pch=21,
    #    col="#777777", pt.bg=colrs, pt.cex=2, cex=.8, bty="n", ncol=1)
# nx.draw_networkx_labels(G, pos=nx.spring_layout(G), labels=("University","Hosting Partner", "Non-hosting Partner"))
# dev.off()


