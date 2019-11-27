import networkx as nx
import scipy as sc
import numpy
import matplotlib.pyplot as p

def GenRdmAdjList(N = 2, C = 0.5): 
    """ 
    """ 
    Ids = range(N) 
    ALst = [] 
    for i in Ids: 
        if sc.random.uniform(0,1,1) < C: 
            Lnk = sc.random.choice(Ids,2).tolist() 
            if Lnk[0] != Lnk[1]: 
                ALst.append(Lnk) 
    return ALst          

MaxN = 30
C = 0.75
AdjL = sc.array(GenRdmAdjList(MaxN,C))
AdjL

Sps = sc.unique(AdjL)
SizRan = ([-10,10])
Sizs = sc.random.uniform(SizRan[0],SizRan[1], MaxN)
Sizs
p.hist(Sizs)
p.hist(10 ** Sizs)
p.close('all')

f = p.figure()
pos = nx.circular_layout(Sps)
G = nx.Graph()
G.add_nodes_from(Sps)
G.add_edges_from(tuple(AdjL))

# Generate node sizes that are proportional to (log) body sizes
NodSizs = 1000 * (Sizs - min(Sizs))/(max(Sizs)-min(Sizs))


# Render the graph
# colormap = plt.get_cmap('BuGn')
nx.draw_networkx(G, pos, node_size = NodSizs, node_color = 'r')
f.savefig('../results/DrawFW.pdf')