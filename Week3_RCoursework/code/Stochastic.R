rm(list=ls())

stochrick<-function(pop,r=1.2,K=1,sigma=0.2,numyears=100){

  N[numyears,pop] <- N[numyears-1,pop]*exp(r*(1-N[numyears-1,pop]/K)+rnorm(1,0,sigma)) #fluctuated within years
    
 return(N)

}

p0 = runif(1000,.5,1.5)
numyears=100
N<-matrix(NA,numyears,length(p0))
N[1,]<-p0

stochrickvect <- function(p0=runif(1000,.5,1.5), r=1.2,K=1, numyears=100){
    res2 <- lapply((1:length(p0)), function(i) lapply((2:numyears), function(j) stochrick()))
    return(res2)
}



print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))


