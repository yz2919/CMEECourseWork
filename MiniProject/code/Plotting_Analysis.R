#!/bin/env R

# Author: Yuqing Zhou y.zhou19@imperial.ac.uk
# Script: plotting.R
# Desc: plotting 
# Input: none
# Output: none
# Arguments: 0
# Date: Jan 2020

options(warn=-1)
library("ggplot2")
library("plyr")
library("dplyr")
library("tidyr")

rm(list=ls()) #clear workspace
graphics.off()

data <- read.csv("../data/Sorteddata.csv")
fittings <- read.csv("../results/fitting.csv")
plotting <- read.csv("../results/plotting.csv")
data$Temp <- as.factor(data$Temp) #Making the temperature values factors - categorical instead of continuous
#model_frame <- read.csv("../results/plotting.csv", header = TRUE)

#unique datasets for combination of Temp, Medium, Species and Rep
dsub <- data %>%nest(-Temp,-Medium,-Species,-Rep,-Citation)
dsub$ID <- paste(dsub$Species, dsub$Medium, dsub$Temp, dsub$Rep, dsub$Citation, sep = "_") 

#fittings[fittings==0] <- NA
#fittings<-fittings[complete.cases(fittings$R.Squared),]

#plot_list = list()
#df_list = list()

for (i in 1:(length(unique(dsub$ID)))) { 
  id <- dsub$ID[i]
  data_fit <- dsub$data[[i]]
  data_plot<-dsub[which(dsub$ID==id),]
  ID_plots <- plotting[which(plotting$ID==id),]
  ID_stats <- fittings[which(fittings$ID==id),]
  
  ggplot(data_fit, aes(x = Time, y = Log10N)) + #Plotting the dataset points for the unique ID
    geom_point(size = 1.5) + #Data point size
    geom_line(data = ID_plots[which(ID_plots$ID==id),], aes(x = timepoints, y = predict_log10N, col = model, linetype = model), size = 1) + #Plotting on the line models of all the models that fitted
    scale_color_manual(values = c("darkolivegreen4", "grey45", "firebrick", "gold", "mistyrose4", "mediumpurple1")) + #Giving the models clour blind friendly colours
    theme(aspect.ratio = 1) + #Making it square
    xlab("Time (Hours)") + ylab(paste("Population Biomass (", data_fit$PopBio_units[1],")", sep = ""))+
    theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + #set background
    labs(title = paste(id)) #Labels
  ggsave(paste("../results/", id, ".png", sep = ""), device = pdf()) #Saving the plot in results
  dev.off()

}



####### delete subset which R square < 0.75
fittings_new <- data_frame(X=numeric(), X1=numeric(), R_square=numeric(), AIC=numeric(), BIC=numeric(), ID=character(), Model=character())
for (i in 1:length(unique(dsub$ID))) { 
  id <- dsub$ID[i]
  ID_stats <- fittings[which(fittings$ID==id),]
  if (length(ID_stats$R_square[which(is.na(ID_stats$R_square)==TRUE)]) + length(ID_stats$R_square[which(ID_stats$R_square<0.75)])>4){
    ID_stats$ID <- NA
  }
  if (!is.na(ID_stats$ID)){
    fittings_new <- rbind(fittings_new,ID_stats, stringsAsFactors = FALSE)
  }
}
#fittings_new<- fittings_new[-1,]
fittings_new <- as.data.frame(fittings_new)
#class(fittings_new)
#length(unique(fittings$ID))
#length(unique(fittings_new$ID))  
#SAVE BEST MODEL DATA TO DATAFRAME
AIC <- fittings_new%>%select(ID, AIC, Model)%>%nest(data = -Model)
cubic_AIC <- AIC$data[[1]]
logistic_AIC <- AIC$data[[2]]
logisticlag_AIC <- AIC$data[[3]]
gompertz_AIC <- AIC$data[[4]]
baranyi_AIC <- AIC$data[[5]]
buchanan_AIC <- AIC$data[[6]]

BIC <- fittings_new%>%select(ID, BIC, Model)%>%nest(data = -Model)
cubic_BIC <- BIC$data[[1]]
logistic_BIC <- BIC$data[[2]]
logisticlag_BIC <- BIC$data[[3]]
gompertz_BIC <- BIC$data[[4]]
baranyi_BIC <- BIC$data[[5]]
buchanan_BIC <- BIC$data[[6]]
#For both AIC and BIC, If model A has AIC lower by 2-3 or more than
#model B, it’s better — Differences of less than 2-3 don’t really matter
#row,column
#fittings_new<- fittings_new%>%nest(data = -ID)
#fittings_new <- as.data.frame(fittings_new)

#class(fittings_new)
#final_stats <- data.frame(ID = character(), Best_R = character(), Best_AIC = character(),stringsAsFactors = FALSE)

###Function to calculate the fit percentage of a given model
##########For AIC
fit_percentage_AIC <- function(model_AIC){
  counter <-  length(unique(fittings_new$ID)) #Counts the numbers of observations
  counter_fit <- 0
  for(i in model_AIC$AIC){
    if(is.na(i) == FALSE && is.infinite(i) == FALSE){ #If it's not infinite and not NA...
      counter_fit <- counter_fit + 1 #Count the AIC observation
    }
  }
  counter_fit_percentage_AIC <- round((counter_fit / counter * 100), digits = 1) #The percentage of fittingss of observations
  return(as.numeric(counter_fit_percentage_AIC)) #Return the percentage as a numeric
}

###Function that works out, specifically, of how many times the model coverges, what percentage of that does it fit the best
subset_best_AIC <- function(data, model_column, model_test_number){
  subset <- subset(data, subset = !is.na(model_column) & !is.infinite(model_column)) #Filtering out the rows with -Inf or NA for that model of interest
  counter <- 0 #To count the number of times that model has the lowest score
  for(i in 1:length(subset$ID)){ #To iterate through all observations in subset
    a <- c(cubic_AIC$AIC[i],logistic_AIC$AIC[i], logisticlag_AIC$AIC[i], gompertz_AIC$AIC[i], baranyi_AIC$AIC[i], buchanan_AIC$AIC[i]) #a is the vector of the AIC values for the dataset observation
    for(j in 1:length(a)){
      if(is.infinite(a[j]) == TRUE | is.na(a[j]) == TRUE){ #If a value in a, so if an AIC, is infinite or NA...
        a[j] <- NaN #Make it a NaN
      }
    }
    best_fit <- c(which(a == min(a, na.rm = TRUE))) #Which is the lowest AIC indexes
    second_best_fit <- c(which(abs(a-min(a,na.rm = TRUE))<2))
    fit_fit <- c(best_fit,second_best_fit)
    for(k in fit_fit){ #Loopoing because which(a == min, na.rm = T) can produce more than one index if the lowest AIC is a draw
      if(k == model_test_number){ #If the lowest AIC index corresponds to the model of interest
        counter <- counter + 1
      }
    }
  }
  counter <- round((counter / length(subset$ID) * 100), digits = 1) #Percentage of the times the model are the best, within the datasets it fitted
  return(counter)
}

##########For BIC
fit_percentage_BIC <- function(model_BIC){
  counter <-  length(unique(fittings_new$ID)) #Counts the numbers of observations
  counter_fit <- 0
  for(i in model_BIC$BIC){
    if(is.na(i) == FALSE && is.infinite(i) == FALSE){ #If it's not infinite and not NA...
      counter_fit <- counter_fit + 1 #Count the AIC observation
    }
  }
  counter_fit_percentage_BIC <- round((counter_fit / counter * 100), digits = 1) #The percentage of fittingss of observations
  return(as.numeric(counter_fit_percentage_BIC)) #Return the percentage as a numeric
}

subset_best_BIC <- function(data, model_column, model_test_number){
  subset <- subset(data, subset = !is.na(model_column) & !is.infinite(model_column)) #Filtering out the rows with -Inf or NA for that model of interest
  counter <- 0 #To count the number of times that model has the lowest score
  for(i in 1:length(subset$ID)){ #To iterate through all observations in subset
    a <- c(cubic_BIC$BIC[i],logistic_BIC$BIC[i], logisticlag_BIC$BIC[i], gompertz_BIC$BIC[i], baranyi_BIC$BIC[i], buchanan_BIC$BIC[i]) #a is the vector of the AIC values for the dataset observation
    for(j in 1:length(a)){
      if(is.infinite(a[j]) == TRUE | is.na(a[j]) == TRUE){ #If a value in a, so if an AIC, is infinite or NA...
        a[j] <- NaN #Make it a NaN
      }
    }
    best_fit <- c(which(a == min(a, na.rm = TRUE))) #Which is the lowest AIC indexes
    second_best_fit <- c(which(abs(a-min(a,na.rm = TRUE))<2))
    fit_fit <- c(best_fit,second_best_fit)
    for(k in fit_fit){ #Loopoing because which(a == min, na.rm = T) can produce more than one index if the lowest AIC is a draw
      if(k == model_test_number){ #If the lowest AIC index corresponds to the model of interest
        counter <- counter + 1
      }
    }
  }
  counter <- round((counter / length(subset$ID) * 100), digits = 1) #Percentage of how many times the model had the lowest AIC, within the datasets it fitted
  return(counter)
}


###Calculate the times of the model the fit the datasets
AIC_cubic_percentage <- fit_percentage_AIC(cubic_AIC)
BIC_cubic_percentage <- fit_percentage_BIC(cubic_BIC)
AIC_p <- data.frame("Cubic", AIC_cubic_percentage, stringsAsFactors = FALSE) 
BIC_p <- data.frame("Cubic", BIC_cubic_percentage, stringsAsFactors = FALSE) 
names(AIC_p) <- c("Model", "fit_percentage_AIC")
names(BIC_p) <- c("Model", "fit_percentage_BIC")

AIC_logistic_percentage <- fit_percentage_AIC(logistic_AIC)
A_logistic_percentage <- c("Logistic", AIC_logistic_percentage)
AIC_p <- rbind(AIC_p, A_logistic_percentage)
BIC_logistic_percentage <- fit_percentage_BIC(logistic_BIC)
B_logistic_percentage <- c("Logistic", BIC_logistic_percentage)
BIC_p <- rbind(BIC_p, B_logistic_percentage)

AIC_logisticlag_percentage <- fit_percentage_AIC(logisticlag_AIC)
A_logisticlag_percentage <- c("Logisticlag", AIC_logisticlag_percentage)
AIC_p <- rbind(AIC_p, A_logisticlag_percentage)
BIC_logisticlag_percentage <- fit_percentage_BIC(logisticlag_BIC)
B_logisticlag_percentage <- c("Logisticlag", BIC_logisticlag_percentage)
BIC_p <- rbind(BIC_p, B_logisticlag_percentage)

AIC_gompertz_percentage <- fit_percentage_AIC(gompertz_AIC)
A_gompertz_percentge <- c("Gompertz", AIC_gompertz_percentage)
AIC_p <- rbind(AIC_p, A_gompertz_percentge)
BIC_gompertz_percentage <- fit_percentage_BIC(gompertz_BIC)
B_gompertz_percentge <- c("Gompertz", BIC_gompertz_percentage)
BIC_p <- rbind(BIC_p, B_gompertz_percentge)


AIC_baranyi_percentage <- fit_percentage_AIC(baranyi_AIC)
A_baranyi_percentage <- c("Baranyi", AIC_baranyi_percentage)
AIC_p <- rbind(AIC_p, A_baranyi_percentage)
BIC_baranyi_percentage <- fit_percentage_BIC(baranyi_BIC)
B_baranyi_percentage <- c("Baranyi", BIC_baranyi_percentage)
BIC_p <- rbind(BIC_p, B_baranyi_percentage)

AIC_buchanan_percentage <- fit_percentage_AIC(buchanan_AIC)
A_buchanan_percentage <- c("Buchanan", AIC_buchanan_percentage)
AIC_p <- rbind(AIC_p, A_buchanan_percentage)
BIC_buchanan_percentage <- fit_percentage_BIC(buchanan_BIC)
B_buchanan_percentage <- c("Buchanan", BIC_buchanan_percentage)
BIC_p <- rbind(BIC_p, B_buchanan_percentage)


AIC_p <- transform(AIC_p, fit_percentage_AIC = as.numeric(fit_percentage_AIC)) #Making the percentage column numeric for the barplot
BIC_p <- transform(BIC_p, fit_percentage_BIC = as.numeric(fit_percentage_BIC)) 

###The percentage at which each model fits the best out of all (delta AIC)
AIC_fit <- c(0, 0, 0, 0, 0, 0) #Vector to hold all the counts for each time a model has the lowest AIC
for(i in 1:length(unique(fittings_new$ID))){ # iterate through all observations
  a <- c(cubic_AIC$AIC[i], logistic_AIC$AIC[i], logisticlag_AIC$AIC[i], gompertz_AIC$AIC[i], baranyi_AIC$AIC[i], buchanan_AIC$AIC[i]) #a is the vector of the AIC values for the dataset observation
  for(j in 1:length(a)){
    if(is.infinite(a[j]) == TRUE | is.na(a[j]) == TRUE){ # if an AIC is infinite or NA
      a[j] <- NaN #Make it a NaN
    }
  }
  best_fit <- c(which(a == min(a, na.rm = TRUE))) # find the minimum AIC
  second_best_fit <- c(which(abs(a-min(a,na.rm = TRUE))<2)) # if delta AIC < 2
  fit_fit <- c(best_fit,second_best_fit) 
  for(k in fit_fit){ # match the model index with the best fit model index
    if(k == 1){
      AIC_fit[1] <- AIC_fit[1] + 1 
    }
    else if(k == 2){
      AIC_fit[2] <- AIC_fit[2] + 1 
    }
    else if(k == 3){
      AIC_fit[3] <- AIC_fit[3] + 1 
    }
    else if(k == 4){
      AIC_fit[4] <- AIC_fit[4] + 1 
    }
    else if(k == 5){
      AIC_fit[5] <- AIC_fit[5] + 1 
    }
    else{
      AIC_fit[6] <- AIC_fit[6] + 1 
    }
  }
}
AIC_fit <- round((AIC_fit / length(unique(fittings_new$ID)) * 100), digits = 1) #Calculate the percentage of model fit total number of observation datasets
AIC_p$AIC_fit <- AIC_fit #Appending it into the dataframe of analysis results


BIC_fit <- c(0, 0, 0, 0, 0, 0) # vector to hold BIC
for(i in 1:length(unique(fittings_new$ID))){ # iterate through all observations
  a <- c(cubic_BIC$BIC[i], logistic_BIC$BIC[i], logisticlag_BIC$BIC[i], gompertz_BIC$BIC[i], baranyi_BIC$BIC[i], buchanan_BIC$BIC[i]) # vector of the BIC values
  for(j in 1:length(a)){
    if(is.infinite(a[j]) == TRUE | is.na(a[j]) == TRUE){ # if BIC is infinite or NA
      a[j] <- NaN
    }
  }
  best_fit <- c(which(a == min(a, na.rm = TRUE))) # find minimum BIC
  second_best_fit <- c(which(abs(a-min(a,na.rm = TRUE))<2))
  fit_fit <- c(best_fit,second_best_fit)
  for(k in fit_fit){ # match index
    if(k == 1){
      BIC_fit[1] <- BIC_fit[1] + 1 
    }
    else if(k == 2){
      BIC_fit[2] <- BIC_fit[2] + 1 
    }
    else if(k == 3){
      BIC_fit[3] <- BIC_fit[3] + 1 
    }
    else if(k == 4){
      BIC_fit[4] <- BIC_fit[4] + 1 
    }
    else if(k == 5){
      BIC_fit[5] <- BIC_fit[5] + 1 
    }
    else{
      BIC_fit[6] <- BIC_fit[6] + 1 
    }
  }
}
BIC_fit <- round((BIC_fit / length(unique(fittings_new$ID)) * 100), digits = 1) 
BIC_p$BIC_fit <- BIC_fit #Appending it into the dataframe of analysis results

######AIC
# The percentage of the models are the best out of the datasets it fitted
cubic_AIC_sp <- subset_best_AIC(cubic_AIC, cubic_AIC$AIC, 1) 
logistic_AIC_sp <- subset_best_AIC(logistic_AIC, logistic_AIC$AIC, 2) 
logisticlag_AIC_sp <- subset_best_AIC(logisticlag_AIC, logisticlag_AIC$AIC, 3) 
gompertz_AIC_sp <- subset_best_AIC(gompertz_AIC, gompertz_AIC$AIC, 4) 
baranyi_AIC_sp <- subset_best_AIC(baranyi_AIC, baranyi_AIC$AIC, 5)
buchanan_AIC_sp <- subset_best_AIC(buchanan_AIC, buchanan_AIC$AIC, 6) 

AIC_percentage_specifically <- c(cubic_AIC_sp, logistic_AIC_sp, logisticlag_AIC_sp, gompertz_AIC_sp, baranyi_AIC_sp, buchanan_AIC_sp)

AIC_p$AIC_percentage_specifically <- AIC_percentage_specifically #Adding the specific percentages onto my dataframe of results

#write.csv(AIC_p, file = "../results/AIC_results.csv")

######For BIC
# The percentage of the models are the best out of the datasets it fitted
cubic_BIC_sp <- subset_best_BIC(cubic_BIC, cubic_BIC$BIC, 1)
logistic_BIC_sp <- subset_best_BIC(logistic_BIC, logistic_BIC$BIC, 2) 
logisticlag_BIC_sp <- subset_best_BIC(logisticlag_BIC, logisticlag_BIC$BIC, 3) 
gompertz_BIC_sp <- subset_best_BIC(gompertz_BIC, gompertz_BIC$BIC, 4) 
baranyi_BIC_sp <- subset_best_BIC(baranyi_BIC, baranyi_BIC$BIC, 5) 
buchanan_BIC_sp <- subset_best_BIC(buchanan_BIC, buchanan_BIC$BIC, 6) 

BIC_percentage_specifically <- c(cubic_BIC_sp, logistic_BIC_sp, logisticlag_BIC_sp, gompertz_BIC_sp, baranyi_BIC_sp, buchanan_BIC_sp)

BIC_p$BIC_percentage_specifically <- BIC_percentage_specifically #Adding the specific percentages onto my dataframe of results
stats_all <- cbind(AIC_p,BIC_p[,2:4])
#write.csv(BIC_p, file = "../results/BIC_results.csv")

###Plotting scores
Model <- c(rep("Cubic", 4), rep("Logistic", 4), rep("Logisticlag", 4), rep("Gompertz", 4), rep("Baranyi", 4), rep("Buchanan", 4)) #Group, categorical
score_type <- rep(c("Convergence (AIC)", "Best fit AIC (%)", "Convergence (BIC)", "Best fit BIC (%)"),6) #Subgroup, categorical
scores <- c(stats_all$fit_percentage_AIC[1], 
            stats_all$AIC_fit[1], 
            stats_all$fit_percentage_BIC[1],
            stats_all$BIC_fit[1],
            stats_all$fit_percentage_AIC[2], 
            stats_all$AIC_fit[2], 
            stats_all$fit_percentage_BIC[2],
            stats_all$BIC_fit[2],
            stats_all$fit_percentage_AIC[3], 
            stats_all$AIC_fit[3], 
            stats_all$fit_percentage_BIC[3],
            stats_all$BIC_fit[3],
            stats_all$fit_percentage_AIC[4], 
            stats_all$AIC_fit[4], 
            stats_all$fit_percentage_BIC[4],
            stats_all$BIC_fit[4],
            stats_all$fit_percentage_AIC[5], 
            stats_all$AIC_fit[5], 
            stats_all$fit_percentage_BIC[5],
            stats_all$BIC_fit[5],
            stats_all$fit_percentage_AIC[6], 
            stats_all$AIC_fit[6], 
            stats_all$fit_percentage_BIC[6],
            stats_all$BIC_fit[6])
stats_plot <- data.frame(Model, score_type, scores) #Dataframe

write.csv(stats_plot, file = "../results/stats_results_2.csv")
#A. Percentage the model is the best fittings model for all dataset IDs
#B. Percentage the model fits all dataset IDs
#C. Of the dataset IDs the model fits, the percentage at which it fits the datast IDs the best

###Plotting the AIC_p2 into a grouped barplot
ggplot(data = stats_plot, aes(fill = score_type, x = Model, y = scores)) +
  geom_bar(position="dodge", stat="identity",color="grey45") +
  scale_fill_manual(values=c("lightskyblue1", "#E69F00", "#56B4E9","gold"))+
  theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(x = "Model", y = "Percentage (%)")
ggsave("../results/stats.png", device = png())
dev.off()
