# load, examine and plot Rdata
load("../data/KeyWestAnnualMeanTemperature.RData") 
ls()
plot(ats, xlab = "Years", ylab ="Temperature")

# plot the pattern of autocorrelation
plot(ats$Temp[-100], ats$Temp[-1], xlab = "Temp(t)", ylab = "Temp(t-1)")
abline(lm(ats$Temp[-100] ~ ats$Temp[-1])) # add regression line
# Correlation of temperature between successive years.
Autocorr <- cor(ats$Temp[-100],ats$Temp[-1])
# Autocorrelation plot of the data.
AutoCorrelation <- acf(ats$Temp, plot = FALSE)
plot(AutoCorrelation, main = "Key West Temperature Series ACF")


# Randomly permuting the time series and recalculating the correlation coefficient for each randomly permuted year sequence.
# Repeat the calculation 10000 times.
T_sample <- sample(ats$Temp, 100, replace = FALSE)
for (i in 10000){
    cor_sample <- cor(T_sample[-100], T_sample[-1])
}

# Plot random sample
plot(ats, xlab = "Years", ylab ="Temperature")
abline(lm(T_sample[-100] ~ T_sample[-1]))

# Plot acf
Randomsample <- acf(T_sample, plot = FALSE)
plot(Randomsample, main = "Random Temperature Series ACF")

print(paste("Correlation coefficient of temperature between successive years is", Autocorr))
print(paste("Correlation coefficient of temperature of random observation is", cor_sample))
print(paste("P_value =", (cor_sample-Autocorr)/Autocorr))