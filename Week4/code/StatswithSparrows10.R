#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: StatsWithSparrows10.R
# Desc: Script for handout of StatsWithSparrow 10
# Arguments: 0
# Date: Oct 2019

rm(list=ls())
d<-read.table("../data/SparrowSize.txt", header=TRUE)
plot(d$Mass~d$Tarsus, ylab="Mass (g)", xlab="Tarsus (mm)", pch=19, cex=0.4)
x<-c(1:100)
b<-0.5
m<-1.5
y<-m*x+b
plot(x,y, xlim=c(0,100), ylim=c(0,100), pch=19, cex=0.5)

plot(d$Mass~d$Tarsus, ylab="Mass (g)", xlab="Tarsus (mm)", pch=19, cex=0.4,ylim=c(-5,38), xlim=c(0,22))
plot(d$Mass~d$Tarsus, ylab="Mass (g)", xlab="Tarsus (mm)", pch=19, cex=0.4)
# strip dataset
d1<-subset(d, d$Mass!="NA")
d2<-subset(d1, d1$Tarsus!="NA")
length(d2$Tarsus)
model1<-lm(Mass~Tarsus, data=d2)
summary(model1)
hist(model1$residuals)
model2<-lm(y~x)
summary(model2)

d2$z.Tarsus<-scale(d2$Tarsus)
model3<-lm(Mass~z.Tarsus, data=d2)
summary(model3)

plot(d2$Mass~d2$z.Tarsus, pch=19, cex=0.4)
abline(v = 0, lty = "dotted")

d$Sex<-as.numeric(d$Sex)
par(mfrow = c(1, 2))
plot(d$Wing ~ d$Sex.1, ylab="Wing(mm)")
plot(d$Wing ~ d$Sex, xlab="Sex", xlim=c(-0.1,1.1), ylab="")
abline(lm(d$Wing ~ d$Sex), lwd = 2)
text(0.15, 76, "intercept")
text(0.9, 77.5, "slope", col = "red")

d4<-subset(d, d$Wing!="NA")
m4<-lm(Wing~Sex, data=d4)
t4<-t.test(d4$Wing~d4$Sex, var.equal=TRUE)
summary(m4)

t4
par(mfrow=c(2,2))
plot(model3)
par(mfrow=c(2,2))
plot(m4)