#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: StatsWithSparrows1_4.R
# Desc: Script for handout of StatsWithSparrow 1-4
# Arguments: 0
# Date: Oct 2019

rm(list = ls())
getwd()
d <- read.table("../data/SparrowSize.txt", header = TRUE)
str(d)
names(d)
head(d)
length(d$Tarsus)
hist(d$Tarsus)
#mean and median
help(mean)
mean(d$Tarsus, na.rm = TRUE)
median(d$Tarsus, na.rm = TRUE)
par(mfrow= c(2,2))
hist(d$Tarsus, breaks = 3, col = "grey")
hist(d$Tarsus, breaks = 10, col = "grey")
hist(d$Tarsus, breaks = 30, col = "grey")
hist(d$Tarsus, breaks = 100, ccol = "grey")
require(plyr)
count(d$Tarsus)
range(d$Tarsus, na.rm = TRUE)
d2 <- subset(d, d$Tarsus!= "NA")
range(d2$Tarsus, na.rm = TRUE)  
var(d$Tarsus, na.rm = TRUE)
var(d2$Tarsus, na.rm = TRUE)
sum((d2$Tarsus - mean(d2$Tarsus))^2)/(length(d2$Tarsus) - 1)
sqrt(var(d2$Tarsus))
sqrt(0.74)
sd(d2$Tarsus)
#z score
zTarsus <- (d2$Tarsus - mean(d2$Tarsus))/sd(d2$Tarsus)
sd(zTarsus)
par(mfrow = c(1,1))
hist(zTarsus)
var(zTarsus)
set.seed(123)
znormal <- rnorm(1e+06)
hist(znormal, breaks = 100)
summary(znormal)
qnorm(c(0.025, 0.975))
pnorm(.Last.value)
qnorm(c(0.25, 0.75))
pnorm(.Last.value)
?.Last.value
par(mfrow = c(1,2))
hist(znormal, breaks = 100)
abline(v=qnorm(c(0.25,0.5,0.75)), lwd = 2)
abline(v=qnorm(c(0.025, 0.975)), lwd = 2, lty = "dashed")
plot(density(znormal))
abline(v=qnorm(c(0.25, 0.5, 0.75)), col="gray")
abline(v = qnorm(c(0.025, 0.975)), lty = "dotted", col = "black")
abline(h = 0, lwd = 3, col = "blue")
text(2, 0.3, "1.96", col = "red", adj = 0)
text(-2, 0.3, "-1.96", col = "red", adj = 1)
#Standard errors
d1 <- subset(d, d$Tarsus!="NA")
seTarsus <- sqrt(var(d1$Tarsus)/length(d1$Tarsus))
seTarsus
d12001 <- subset(d1, d1$Year==2001)                 
seTarsus2001 <- sqrt(var(d12001$Tarsus)/length(d12001$Tarsus))
seTarsus2001
dMass <- subset(d, d$Mass!="NA")
seMass <- sqrt(var(dMass$Mass)/length(dMass$Mass))
seMass
dWing <- subset(d, d$Wing!="NA")
seWing <- sqrt(var(dWing$Wing)/length(dWing$Wing))
seWing
dBill <- subset(d, d$Bill!="NA")
seBill <- sqrt(var(dBill$Bill))/length(dBill$Bill)
seBill
d1 <- subset(d, d$Year==2001)
dMass <- subset(d1, d1$Mass!="NA")
seMass <- sqrt(var(dMass$Mass)/length(dMass$Mass))
seMass
dWing <- subset(d1, d1$Wing!="NA")
seWing <- sqrt(var(dWing$Wing)/length(dWing$Wing))
seWing
dBill <- subset(d1, d1$Bill!="NA")
seBill <- sqrt(var(dBill$Bill))/length(dBill$Bill)
seBill
