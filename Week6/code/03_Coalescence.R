#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: 03_Coalescence.R
# Desc: estimate the effective population size, calculate and plot the site frequency spectrum for whale population
# Arguments: 0
# Date: Nov 2019

whalesN <- read.csv("../data/killer_whale_North.csv", header = FALSE, stringsAsFactors= FALSE, colClasses= rep("numeric", 50000))
whalesS <- read.csv("../data/killer_whale_South.csv", header = FALSE, stringsAsFactors= FALSE, colClasses= rep("numeric", 50000))
whalesN <- as.matrix(whalesN)
whalesS <- as.matrix(whalesS)
#Tajima
n <- nrow(whalesN)
pi_N=0
for (i in 1:(n-1)) {
  for (j in (i+1):n) {
    pi_N = pi_N + sum(abs(whalesN[i,]-whalesN[j,]))
  }
}
pi_N <- pi_N/(n*(n-1)/2)

n <- nrow(whalesS)
pi_S=0
for (i in 1:(n-1)) {
  for (j in (i+1):n) {
    pi_S = pi_S + sum(abs(whalesS[i,]-whalesS[j,]))
  }
}
pi_S <- pi_S/(n*(n-1)/2)

#Tajima effective population size
NeT_north =  pi_N/(4*(10^(-8)))
NeT_south =  pi_S/(4*(10^(-8)))
#Watterson's north
SNPn = 0
for (i in 1:ncol(whalesN)){
  if (length(unique(whalesN[,i])) != 1 )
    SNPn <- SNPn + 1
}
sumN = 0
for (i in 1:(nrow(whalesN)-1)){
 sumN = sumN + sum(1/i)
}
Wn <- SNPn/sumN
#Watterson's south
SNPs = 0
for (i in 1:ncol(whalesS)){
  if (length(unique(whalesS[,i])) != 1 )
    SNPs <- SNPs + 1
}
sumS = 0
for (i in 1:(nrow(whalesS)-1)){
  sumS = sumS + sum(1/i)
}
Ws <- SNPs/sumS
#Watterson effective population size
NeW_north =  Wn/(4*10^(-8))
NeW_south =  Ws/(4*10^(-8))



# #SFS
# freq = 0
# SFS <- c()
# lapply(whalesN[,i], table))
# for (i in 1:ncol(whalesN)) {
#   freq = sum(whalesN[,i]==1)
#   SFS <- c(SFS, freq)
# }

# apply(array, margin, ...)

# for (i in 1:ncol(whalesN)) {
#   if (i == 1)
#     freq = sum(whalesN[,i])/nrow(whalesN)
#   SFS <- c(SFS, freq)
# }
# freq
# hist(SFS)
# hist(whalesN[,i],prob=T,xlab='sth',main='STH',ylim=0:1,freq,breaks=seq(0,550,2))


# #Mutation rate per site need to multiple by length. the more the bases, the more the mutation might accumulate.





### North population
sfs_N <- rep(0, n-1)
### allele frequencies
derived_freqs <- apply(X=whalesN, MAR=2, FUN=sum)
### the easiest (but slowest) thing to do would be to loop over all possible allele frequencies and count the occurrences
for (i in 1:length(sfs_N)) sfs_N[i] <- length(which(derived_freqs==i))

### South population
sfs_S <- rep(0, n-1)
### allele frequencies
derived_freqs <- apply(X=whalesS, MAR=2, FUN=sum)
### the easiest (but slowest) thing to do would be to loop over all possible allele frequencies and count the occurrences
for (i in 1:length(sfs_S)) sfs_S[i] <- length(which(derived_freqs==i))

### plot
barplot(t(cbind(sfs_N, sfs_S)), beside=T, names.arg=seq(1,nrow(whalesS)-1,1), legend=c("North", "South"))

cat("\nThe population with the greater population size has a higher proportion of singletons, as expected.")

### bonus: joint site frequency spectrum

sfs <- matrix(0, nrow=nrow(whalesN)+1, ncol=nrow(whalesS)+1)
for (i in 1:ncol(whalesN)) {

	freq_N <- sum(whalesN[,i])
	freq_S <- sum(whalesS[,i])

	sfs[freq_N+1,freq_S+1] <- sfs[freq_N+1,freq_S+1] + 1

}
sfs[1,1] <- NA # ignore non-SNPs

image(t(sfs))