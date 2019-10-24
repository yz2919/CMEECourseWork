# Import data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
dim(MyDF)
require(dplyr)
require(tidyr)
dplyr::glimpse(MyDF)

# Make lattice graphs and save as pdf
require(lattice)


pdf("../results/Pred_Lattice.pdf", 11.6, 8.3)
densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data=MyDF)
graphics.off()

pdf("../results/Prey_Lattice.pdf", 11.6, 8.3)
densityplot(~log(Prey.mass) | Type.of.feeding.interaction, data=MyDF)
graphics.off()

pdf("../results/SizeRatio_Lattice.pdf", 11.6, 8.3)
densityplot(~log(Prey.mass/Predator.mass) | Type.of.feeding.interaction, data=MyDF)
graphics.off()

# Calculate mean and median and save as .csv
PredMM <- MyDF %>% group_by(Type.of.feeding.interaction) %>% summarise(Pred.mean = mean(log(Predator.mass)), Pred.median = median(log(Predator.mass)))
PreyMM <- MyDF %>% group_by(Type.of.feeding.interaction) %>% summarise(Prey.mean = mean(log(Prey.mass)), Prey.median = median(log(Prey.mass)))
SizeRatioMM <- MyDF %>% group_by(Type.of.feeding.interaction) %>% summarise(SizeRatio.mean = mean(log(Prey.mass/Predator.mass)), SizeRatio.median = median(log(Prey.mass/Predator.mass)))
PP_Results <- cbind(PredMM, PreyMM[,2:3], SizeRatioMM[,2:3])
write.csv(PP_Results,"../results/PP_Results.csv")