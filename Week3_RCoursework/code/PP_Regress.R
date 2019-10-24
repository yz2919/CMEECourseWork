MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
library(lattice)
library(ggplot2)
require(lattice)
require(ggplot2)
p <- ggplot(MyDF, aes(x = Prey.mass, y = Predator.mass, colour = Predator.lifestage)) + geom_point(size=I(2), shape=I(3)) + theme_bw() + facet_grid(Type.of.feeding.interaction ~ .)
p <- p + labs(x = "Prey Mass in grams", y = "Predator mass in grams") + theme(legend.position="bottom")

pdf("../results/PP_Regress.pdf")
p
dev.off()


