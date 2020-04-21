#!/bin/env R

# Author: Yuqing Zhou y.zhou19@imperial.ac.uk
# Script: NLLS_fitting.R
# Desc: complete the miniproject from scratch
# Input: python3 run_MiniProject.py
# Output: none -- see child scripts
# Arguments: 0
# Date: Jan 2020


rm(list = ls()) #clear workspace
graphics.off()
options(warn=-1)
library("tidyr")
library(minpack.lm)
library("readr")
library("dplyr")

# Opens the modified dataset from previous step.
data <- read.csv("../data/Sorteddata.csv", header = TRUE)
data$Temp <- as.factor(data$Temp) #Making the temperature values factors - categorical instead of continuous


#unique datasets for combination of Temp, Medium, Species and Rep
dsub <- data %>%nest(-Temp,-Medium,-Species,-Rep,-Citation)
dsub$ID <- paste(dsub$Species, dsub$Medium, dsub$Temp, dsub$Rep, dsub$Citation, sep = "_") 

# Specify model functions.
logistic_model <- function(N_0, N_max, r_max, t){ # The classic logistic equation
  return((N_0 * N_max * exp(r_max*t)) / (N_max + N_0 * (exp(r_max*t) - 1)))
}

logisticlag_model <- function(N_0, N_max, r_max, t, t_lag){# N_0:initial population size, r: maximum growth rate, K: carrying capacity
  return(N_0 + (N_max - N_0) / (1 + exp(4 * r_max * (t_lag - t) / (N_max - N_0) + 2)))
}

gompertz_model <- function(N_0, N_max, r_max, t, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (N_max - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((N_max - N_0) * log(10)) + 1)))
} 

baranyi_model <- function(N_0, N_max, r_max, t, t_lag){ # Baranyi model (Baranyi 1993)
  return(N_max + log10((-1+exp(r_max*t_lag) + exp(r_max*t))/(exp(r_max*t) - 1 + exp(r_max*t_lag) * 10^(N_max-N_0))))
}

buchanan_model <- function(t, r_max, N_max, N_0, t_lag){ # Buchanan model - three phase logistic (Buchanan 1997)
  return(N_0 + (t >= t_lag) * (t <= (t_lag + (N_max - N_0) * log(10)/r_max)) * r_max * (t - t_lag)/log(10) + (t >= t_lag) * (t > (t_lag + (N_max - N_0) * log(10)/r_max)) * (N_max - N_0))
}


###Dataframe for stats results
for (i in 1:length(dsub$data)){
  data_fit <- dsub$data[[i]] #datasubset
  ## Calculates starting values.
  N_0_start <- min(data_fit$Log10N) #Starting value for N0 being the mininmum of the PopBio data
  N_max_start <- max(data_fit$Log10N) #Starting value for Nmax being the maximum of the PopBio data 
  r_max_start <- max(diff(data_fit$Log10N) / mean(diff(data_fit$Time)))
  r_max_start <- as.numeric(r_max_start) #Make it a numeric class type
  t_lag_start <- data_fit$Time[which.max(diff(diff(data_fit$Log10N)))]
  ###Fiting the models
  ID <- dsub$ID[i]
  fit_cubic <- lm(Log10N ~ poly(Time, 3), data = data_fit)
  if(class(fit_cubic) !="try-error"){
    RSS_cubic <- sum(residuals(fit_cubic)^2) #Residual sum of squares
    TSS_cubic <- sum((data_fit$Log10N - mean(data_fit$Log10N))^2) #Total sum of squares 
    rsq_cubic <- 1 - (RSS_cubic/TSS_cubic)
    cubic_AIC <- AIC(fit_cubic)
    cubic_BIC <- BIC(fit_cubic)
    df_cubic <- data.frame(rsq_cubic, cubic_AIC, cubic_BIC, ID)
    df_cubic$Model <- "Cubic"
    names(df_cubic) <- c("R_square", "AIC", "BIC", "ID", "Model")
  } else {
    df_cubic <- data.frame(rsq_cubic = NA, cubic_AIC = NA, cubic_BIC = NA, ID = ID, Model = "Cubic")
    names(df_cubic) <- c("R_square", "AIC", "BIC", "ID", "Model")
  }
  fit_logistic <- try(nlsLM(Log10N ~ logistic_model(N_0, N_max, r_max, t = Time), data = data_fit, start = c(N_0 = N_0_start, N_max = N_max_start, r_max = r_max_start), control = nls.lm.control(maxiter = 100)), silent = T) #Running the logistic model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(fit_logistic) != 'try-error'){
    logistic_AIC <- AIC(fit_logistic)
    logistic_BIC <- BIC(fit_logistic)
    RSS_log <- sum(residuals(fit_logistic)^2) #Residual sum of squares
    TSS_log <- sum((data_fit$Log10N - mean(data_fit$Log10N))^2) #Total sum of squares 
    rsq_log <- 1 - (RSS_log/TSS_log)
    df_logistic <- data.frame(rsq_log, logistic_AIC, logistic_BIC, ID)
    df_logistic$Model <- "Logistic"
    names(df_logistic) <- c("R_square", "AIC", "BIC", "ID", "Model")
  } else {
    logistic_AIC <- "NA"
    logistic_BIC <- "NA"
    rsq_log <-  "NA"
    df_logistic <- data.frame(rsq_log, logistic_AIC, logistic_BIC, ID)
    df_logistic$Model <- "Logistic"
    names(df_logistic) <- c("R_square", "AIC", "BIC", "ID", "Model")
  }
  
  fit_logisticlag <- try(nlsLM(Log10N ~ logisticlag_model(N_0, N_max, r_max, t = Time, t_lag), data = data_fit, start = c(N_0 = N_0_start, N_max = N_max_start, r_max = r_max_start, t_lag = t_lag_start), control = nls.lm.control(maxiter = 100)), silent = T) #Running the Gompertz model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(fit_logisticlag) != 'try-error'){
    logisticlag_AIC <- AIC(fit_logisticlag)
    logisticlag_BIC <- BIC(fit_logisticlag)
    RSS_loglag <- sum(residuals(fit_logisticlag)^2) #Residual sum of squares
    TSS_loglag <- sum((data_fit$Log10N - mean(data_fit$Log10N))^2) #Total sum of squares 
    rsq_loglag <- 1 - (RSS_loglag/TSS_loglag)
    df_logisticlag <- data.frame(rsq_loglag, logisticlag_AIC, logisticlag_BIC, ID)
    df_logisticlag$Model <- "Logisticlag"
    names(df_logisticlag) <- c("R_square", "AIC", "BIC", "ID", "Model")
  } else {
    logisticlag_AIC <- "NA"
    logisticlag_BIC <- "NA"
    rsq_loglag <- "NA"
    df_logisticlag <- data.frame(rsq_loglag, logisticlag_AIC, logisticlag_BIC, ID)
    df_logisticlag$Model <- "Logisticlag"
    names(df_logisticlag) <- c("R_square", "AIC", "BIC", "ID", "Model")
  }
  
  fit_gompertz <- try(nlsLM(Log10N ~ gompertz_model(N_0, N_max, r_max, t = Time, t_lag), data = data_fit, start = c(N_0 = N_0_start, N_max = N_max_start, r_max = r_max_start, t_lag = t_lag_start), control = nls.lm.control(maxiter = 100)), silent = T) #Running the Gompertz model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(fit_gompertz) != 'try-error'){
    gompertz_AIC <- AIC(fit_gompertz)
    gompertz_BIC <- BIC(fit_gompertz)
    RSS_gompertz <- sum(residuals(fit_gompertz)^2) #Residual sum of squares
    TSS_gompertz <- sum((data_fit$Log10N - mean(data_fit$Log10N))^2) #Total sum of squares 
    rsq_gompertz <- 1 - (RSS_gompertz/TSS_gompertz)
    df_gompertz <- data.frame(rsq_gompertz, gompertz_AIC, gompertz_BIC, ID)
    df_gompertz$Model <- "Gompertz"
    names(df_gompertz) <- c("R_square", "AIC", "BIC", "ID", "Model")
    
  } else {
    gompertz_AIC <- "NA"
    gompertz_BIC <- "NA"
    rsq_gompertz <- "NA"
    df_gompertz <- data.frame(rsq_gompertz, gompertz_AIC, gompertz_BIC, ID)
    df_gompertz$Model <- "Gompertz"
    names(df_gompertz) <- c("R_square", "AIC", "BIC", "ID", "Model")
  }
  
  fit_baranyi <- try(nlsLM(Log10N ~ baranyi_model(N_0, N_max, r_max, t = Time, t_lag), data = data_fit, start = c(N_0 = N_0_start, N_max = N_max_start, r_max = r_max_start, t_lag = t_lag_start), control = nls.lm.control(maxiter = 100)), silent = T) #Running the Baranyi model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(fit_baranyi) != 'try-error'){
    baranyi_AIC <- AIC(fit_baranyi)
    baranyi_BIC <- BIC(fit_baranyi)
    RSS_baranyi <- sum(residuals(fit_baranyi)^2) #Residual sum of squares
    TSS_baranyi <- sum((data_fit$Log10N - mean(data_fit$Log10N))^2) #Total sum of squares 
    rsq_baranyi <- 1 - (RSS_baranyi/TSS_baranyi)
    df_baranyi <- data.frame(rsq_baranyi, baranyi_AIC, baranyi_BIC, ID)
    df_baranyi$Model <- "Baranyi"
    names(df_baranyi) <- c("R_square", "AIC", "BIC", "ID", "Model")
  } else {
    baranyi_AIC <- "NA"
    baranyi_BIC <- "NA"
    rsq_baranyi <- "NA"
    df_baranyi <- data.frame(rsq_baranyi, baranyi_AIC, baranyi_BIC, ID)
    df_baranyi$Model <- "Baranyi"
    names(df_baranyi) <- c("R_square", "AIC", "BIC", "ID", "Model")
  }
  
  fit_buchanan <- try(nlsLM(Log10N ~ buchanan_model(N_0, N_max, r_max, t = Time, t_lag), data = data_fit, start = c(N_0 = N_0_start, N_max = N_max_start, r_max = r_max_start, t_lag = t_lag_start), control = nls.lm.control(maxiter = 100)), silent = T) #Running the Baranyi model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(fit_buchanan) != 'try-error'){
    buchanan_AIC <- AIC(fit_buchanan)
    buchanan_BIC <- BIC(fit_buchanan)
    RSS_buchanan <- sum(residuals(fit_buchanan)^2) #Residual sum of squares
    TSS_buchanan <- sum((data_fit$Log10N - mean(data_fit$Log10N))^2) #Total sum of squares 
    rsq_buchanan <- 1 - (RSS_buchanan/TSS_buchanan)
    df_buchanan <- data.frame(rsq_buchanan, buchanan_AIC, buchanan_BIC, ID)
    df_buchanan$Model <- "Buchanan"
    names(df_buchanan) <- c("R_square", "AIC", "BIC", "ID", "Model")
  } else {
    buchanan_AIC <- "NA"
    buchanan_BIC <- "NA"
    rsq_buchanan <- "NA"
    df_buchanan <- data.frame(rsq_buchanan, buchanan_AIC, buchanan_BIC, ID)
    df_buchanan$Model <- "Buchanan"
    names(df_buchanan) <- c("R_square", "AIC", "BIC", "ID", "Model")
  }    
  
  ### Predicting
  timepoints <- seq(from = min(data_fit$Time), to = max(data_fit$Time), length.out = 200) #x-axis for the models
  ### rmax dataframe
  #rmax_df = data.frame("Gompertz"=rep(NA,length(ID)),"Baranyi"=rep(NA,length(ID)),"Buchanan"=rep(NA,length(ID)))  

  
  cubic_points <- predict.lm(fit_cubic, data.frame(Time = timepoints)) 
  df1 <- data.frame(ID, timepoints, cubic_points) # x and y coords
  df1$model <- "Cubic" 
  names(df1) <- c("ID","timepoints", "predict_log10N", "model") 
  model_frame <- df1  
  #rmax_1<-data.frame(ID,"NA","Cubic")
  #names(rmax_1) <- c("ID","rmax", "model")
  #rmax_df <- rmax_1
  
  if(logistic_AIC != "NA" && is.infinite(logistic_AIC) == FALSE){ 
    logistic_points <- logistic_model(t = timepoints, r_max = coef(fit_logistic)["r_max"], N_max = coef(fit_logistic)["N_max"], N_0 = coef(fit_logistic)["N_0"])
    df2 <- data.frame(ID, timepoints, logistic_points)
    df2$model <- "Logistic"
    names(df2) <- c("ID","timepoints", "predict_log10N", "model")
    model_frame <- rbind(model_frame, df2)
    rmax_2 <- data.frame(ID,coef(fit_logistic)["r_max"],"Logistic")
    names(rmax_2) <- c("ID","rmax", "model")
    rmax_df <- rmax_2
    
  } 
  if(logisticlag_AIC != "NA" && is.infinite(logisticlag_AIC) == FALSE){ 
    logisticlag_points <- logisticlag_model(t = timepoints, r_max = coef(fit_logisticlag)["r_max"], N_max = coef(fit_logisticlag)["N_max"], N_0 = coef(fit_logisticlag)["N_0"], t_lag = coef(fit_logisticlag)["t_lag"])
    df3 <- data.frame(ID, timepoints, logisticlag_points)
    df3$model <- "Logisticlag"
    names(df3) <- c("ID","timepoints", "predict_log10N", "model")
    model_frame <- rbind(model_frame, df3)
    rmax_3 <-data.frame(ID,coef(fit_logisticlag)["r_max"],"Logisticlag")
    names(rmax_3) <- c("ID","rmax", "model")
    rmax_df <- rbind(rmax_df, rmax_3)
  }
  if(gompertz_AIC != "NA" && is.infinite(gompertz_AIC) == FALSE){ 
    gompertz_points <- gompertz_model(t = timepoints, r_max = coef(fit_gompertz)["r_max"], N_max = coef(fit_gompertz)["N_max"], N_0 = coef(fit_gompertz)["N_0"], t_lag = coef(fit_gompertz)["t_lag"])
    df4 <- data.frame(ID,timepoints, gompertz_points)
    df4$model <- "Gompertz"
    names(df4) <- c("ID","timepoints", "predict_log10N", "model")
    model_frame <- rbind(model_frame, df4)
    rmax_4 <-data.frame(ID,coef(fit_gompertz)["r_max"],"Gompertz")
    names(rmax_4) <- c("ID","rmax", "model")
    rmax_df <- rbind(rmax_df, rmax_4)
  }
  if(baranyi_AIC != "NA" && is.infinite(baranyi_AIC) == FALSE){ 
    baranyi_points <- baranyi_model(t = timepoints, r_max = coef(fit_baranyi)["r_max"], N_max = coef(fit_baranyi)["N_max"], N_0 = coef(fit_baranyi)["N_0"], t_lag = coef(fit_baranyi)["t_lag"])
    df5 <- data.frame(ID,timepoints, baranyi_points)
    df5$model <- "Baranyi"
    names(df5) <- c("ID","timepoints", "predict_log10N", "model")
    model_frame <- rbind(model_frame, df5)
    rmax_5 <-data.frame(ID,coef(fit_baranyi)["r_max"],"Baranyi")
    names(rmax_5) <- c("ID","rmax", "model")
    rmax_df <- rbind(rmax_df, rmax_5)
  }
  if(buchanan_AIC != "NA" && is.infinite(buchanan_AIC) == FALSE){ 
    buchanan_points <- buchanan_model(t = timepoints, r_max = coef(fit_buchanan)["r_max"], N_max = coef(fit_buchanan)["N_max"], N_0 = coef(fit_buchanan)["N_0"], t_lag = coef(fit_buchanan)["t_lag"])
    df6 <- data.frame(ID, timepoints, buchanan_points)
    df6$model <- "Buchanan"
    names(df6) <- c("ID","timepoints", "predict_log10N", "model")
    model_frame <- rbind(model_frame, df6)
    rmax_6 <-data.frame(ID,coef(fit_buchanan)["r_max"],"Buchanan")
    names(rmax_6) <- c("ID","rmax", "model")
    rmax_df <- rbind(rmax_df, rmax_6)
  }

  ### save stats
  save(fit_cubic,fit_logistic, fit_logisticlag, fit_gompertz, fit_buchanan, fit_baranyi, file = "../data/fittings.RData")
  model_stats <- rbind(df_cubic,df_logistic, df_logisticlag, df_gompertz, df_baranyi, df_buchanan)
  write.csv(model_stats, paste0("../results/model_stats_",i,".csv"))
  #save(model_frame, file = "../data/predicts.RData")
  write.csv(rmax_df, paste0("../data/rmax_",i,".csv"))
  write.csv(model_frame, paste0("../results/plotting_",i,".csv"))
}

model_stats <- list.files(path = "../results/", pattern=glob2rx("model_stats*.csv"), full.names = TRUE) %>% 
  lapply(read_csv) %>% 
  bind_rows 

plotting <- list.files(path = "../results/", pattern=glob2rx("plotting*.csv"), full.names = TRUE) %>%
  lapply(read_csv) %>%
  bind_rows

rmax <-list.files(path = "../data/", pattern=glob2rx("rmax_*.csv"), full.names = TRUE) %>%
  lapply(read_csv) %>%
  bind_rows

write.csv(model_stats, ("../results/fitting.csv"))
write.csv(plotting, ("../results/plotting.csv"))
write.csv(rmax, ("../results/rmax.csv"))

#For both AIC and BIC, If model A has AIC lower by 2-3 or more than
#model B, it’s better — Differences of less than 2-3 don’t really matter
#row,column