#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: 01_Alleles.R
# Desc: calculate several quantities of population genetics from `bears.csv`
# Arguments: 0
# Date: Nov 2019

# SNP
bears <- read.csv("../data/bears.csv", header = FALSE, stringsAsFactors= FALSE, colClasses= rep("character", 10000))
# Identify SNPs position.
SNPs <- c()
for (i in 1:ncol(bears)) {
  if (length(unique(bears[,i])) == 2)
    SNPs <- c(SNPs,i)
}
SNPs

# calculate, print and visualise allele frequencies
bears <- bears[, SNPs]
colnames(bears) = SNPs 
Freqbears <- c()
ncol(bears)
for (i in 1:ncol(bears)){
  alleles <- sort(unique(bears[,i]))
  cat("\nSNPs",i, "alleles", alleles)
  freq <- length(which(bears[,i]==alleles[2])/nrow(bears))
  cat("allele frequency",freq)
  Freqbears <- c(Freqbears, freq)
} 
hist(Freqbears, breaks = 15)

# calculate and print genotype frequencies
Freqbears <<- NULL
for (i in 1:nrow(bears)){
  genotype = c(bears[i,], bears[i+1,])
}
  alleles2 = as.data.frame(table(alleles))
  alleles4=cbind(alleles2,alleles2[,2]/sum(alleles2[,2]))
  output=cbind(i, bears[i], alleles4)
  Freqbears <<- rbind(Freqbears,output)

colnames(Freqbears) <- c("Number", "Locus","allele","count","frequency")
Allelefreqs=Freqbears[,-1]
write.table(Allelefreqs,file="../results/Allelefrequencies.txt",row.names=FALSE,col.names=TRUE,sep="\t",append=FALSE)

######
# calculate and print homozygosity and heterozygosity
### reuse the previous code and easily calculate the heterozygosity
nsamples <- 20
for (i in 1:ncol(bears)) {
  ### alleles in this SNPs
  alleles <- sort(unique(bears[,i]))
  cat("\nSNP", i, "with alleles", alleles)
  ### choose one allele as "reference"
  ### genotypes are Allele1/Allele1 Allele1/Allele2 Allele2/Allele2
  genotype_counts <- c(0, 0, 0)
  for (j in 1:nsamples) {
    ### indexes of genotypes for individual j
    genotype_index <- c( (j*2)-1, (j*2) )
    ### count the Allele2 instances
    genotype <- length(which(bears[genotype_index, i]==alleles[2])) + 1
    ### increase the counter for the corresponding genotype
    genotype_counts[genotype] <- genotype_counts[genotype] + 1
  }
  cat(" and heterozygosity", genotype_counts[2]/nsamples, "and homozygosity", 1-genotype_counts[2]/nsamples)
}
# test for HWE, with calculating of expected genotype counts

nonHWE <- c() # to store indexes of SNPs deviating from HWE
nsamples <- 20
for (i in 1:ncol(bears)) {
  
  ### alleles in this SNPs
  alleles <- sort(unique(bears[,i]))
  cat("\nSNP", i)
  
  ### "reference"
  freq <- length(which(bears[,i]==alleles[2])) / nrow(bears)
  
  ### calculate the expected genotype counts under HWE
  genotype_counts_expected <- c( (1-freq)^2, 2*freq*(1-freq), freq^2) * nsamples
  
  ### genotypes are Allele1/Allele1 Allele1/Allele2 Allele2/Allele2
  genotype_counts <- c(0, 0, 0)
  
  for (j in 1:nsamples) {
    ### indexes of genotypes for individual j
    genotype_index <- c( (j*2)-1, (j*2) )
    ### count the Allele2 instances
    genotype <- length(which(bears[genotype_index, i]==alleles[2])) + 1
    ### increase the counter for the corresponding genotype
    genotype_counts[genotype] <- genotype_counts[genotype] + 1
  }
  
  ### test for HWE: calculate chi^2 statistic
  chi <- sum( (genotype_counts_expected - genotype_counts)^2 / genotype_counts_expected )
  
  ## pvalue
  pv <- 1 - pchisq(chi, df=1)
  cat("with pvalue for test against HWE", pv)
  
  ## retain SNPs with pvalue<0.05
  if (pv < 0.05) nonHWE <- c(nonHWE, i)
  
}


## 6) calculate, print  and visualise inbreeding coefficients for SNPs deviating from HWE

### assuming we ran the code for point 5, we already have the SNPs deviating
F <- c()
nsamples <- 20
for (i in nonHWE) {

        ### alleles in this SNPs
        alleles <- sort(unique(bears[,i]))
        cat("\nSNP", i)

        ### as before, I can choose one allele as "reference"
        ### frequency (of the second allele)
        freq <- length(which(bears[,i]==alleles[2])) / nrow(bears)

        ### from the frequency, I can calculate the expected genotype counts under HWE
        genotype_counts_expected <- c( (1-freq)^2, 2*freq*(1-freq), freq^2) * nsamples

        ### genotypes are Allele1/Allele1 Allele1/Allele2 Allele2/Allele2
        genotype_counts <- c(0, 0, 0)

        for (j in 1:nsamples) {
                ### indexes of genotypes for individual j
                genotype_index <- c( (j*2)-1, (j*2) )
                ### count the Allele2 instances
                genotype <- length(which(bears[genotype_index, i]==alleles[2])) + 1
                ### increase the counter for the corresponding genotype
                genotype_counts[genotype] <- genotype_counts[genotype] + 1
        }

    ### calculate inbreeding coefficient
    inbreeding <- ( 2*freq*(1-freq) - (genotype_counts[2]/nsamples) ) / ( 2*freq*(1-freq) )
    F <- c(F, inbreeding)
    cat(" with inbreeding coefficient", inbreeding)
}
### plot
hist(F)
plot(F, type="h")
