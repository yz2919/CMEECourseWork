#!/bin/env R

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: HPC.R
# Description: Neutral theory simulations functions input and fractals functions script for HPC
# Arguments: 0
# Date: Nov 2019
# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Yuqing Zhou"
preferred_name <- "Yuqing"
email <- "yz2919@imperial.ac.uk"
username <- "yz2919"
personal_speciation_rate <- 0.005177 # will be assigned to each person individually in class and should be between 0.002 and 0.007

# Question 1
species_richness <- function(community){
  return(length(unique(community)))
}

# Question 2
init_community_max <- function(size){
  return(seq(size))
}

# Question 3
init_community_min <- function(size){
  return(rep(1, size))
}

# Question 4
choose_two <- function(max_value){
  sample(1:max_value, size = 2, replace = FALSE)
}

# Question 5
neutral_step <- function(community){
  index = choose_two(length(community))
  community[index[1]] <- community[index[2]]
  return(community)
}

# Question 6
neutral_generation <- function(community){
  length_sample = length(community)/2
  length_sample = sample(c(ceiling(length_sample), floor(length_sample)), 1)
  for (i in 1:length_sample){
    community = neutral_step(community)
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  richness <- c(species_richness(community))
  for (i in 1:duration){
    community = neutral_generation(community)
    richness <- c(richness,species_richness(community))
  }
  return(richness)
}

# Question 8
question_8 <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(neutral_time_series(community=init_community_max(100), duration = 200),
       xlab = "Generation", ylab = "Species Richness",type = 'l')
  return("The system will always converge to state of species richness of 1. This is because species are removed to until only 1 left and no new species are added.")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  index = choose_two(length(community))
  if (runif(1,0,1) < speciation_rate){
    community[index[1]] <- sample(1:99, size = 1)
  } else {
    community[index[1]] <- community[index[2]]
  }
  return(community)
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  length_sample = length(community)/2
  length_sample = sample(c(ceiling(length_sample), floor(length_sample)), 1)
  for (i in 1:length_sample){
    community = neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  richness <- c(species_richness(community))
  for (i in 1:duration){
    community = neutral_generation_speciation(community, speciation_rate)
    richness <- c(richness,species_richness(community))
  }
  return(richness)
}

# Question 12
question_12 <- function(community_size = 100, speciation_rate = 0.1, duration = 200)  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(neutral_time_series_speciation(community=init_community_max(community_size), speciation_rate, duration ),
       ylim = c(0,100),
       xlab = "Generation", ylab = "Species Richness",type = 'l',col = "indianred")
  lines(neutral_time_series_speciation(community=init_community_min(community_size), speciation_rate, duration),
       xlab = "Generation", ylab = "Species Richness",type = 'l', col = "steelblue3")
  legend("topright",legend = c("Community 1", "Community 2"), col = c("indianred", "steelblue3"), lty = 1)
  return("The system will always converge to the similar state regardless of the initial conditions. This is because the speciation rate and time step is the same.")
}

# Question 13
species_abundance <- function(community)  {
  abundance_vector = c(sort(as.data.frame(table(community))[,2], decreasing = TRUE))
  return(abundance_vector)
}

# Question 14
octaves <- function(abundance_vector) {
  octave_classes <- tabulate(1 + floor(log2(abundance_vector)))
  return(octave_classes)
}

# Question 15
sum_vect <- function(x, y) {
  if (length(x) < length(y)){
    x <- c(x,rep(0, times = (length(y)-length(x))))
  }
  if (length(y) < length(x)) {
    y <- c(y,rep(0, times = (length(x)-length(y))))
  }
  else {
    x <- x
    y <- y
  }
  return(x + y)
}

# Question 16
question_16 <- function(community_size = 100, speciation_rate = 0.1, duration = 2200, burn_in_generation = 200)  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  community_1 <- init_community_max(community_size)
  octaves_sum1 <- c()
  community_2 <- init_community_min(community_size)
  octaves_sum2 <- c()
  for (i in 1:duration){
    community_1 <- neutral_generation_speciation(community_1, speciation_rate)
    community_2 <- neutral_generation_speciation(community_2, speciation_rate)
    if (i > burn_in_generation & (i %% 20 == 0)){
      octaves_sum1 <- sum_vect(octaves_sum1,octaves(species_abundance(community_1)))
      octaves_sum2 <- sum_vect(octaves_sum2,octaves(species_abundance(community_2)))
    }
  }
  octaves_sum1 = octaves_sum1/100
  octaves_sum2 =octaves_sum2/100
  octaves_sum <- t(as.matrix(data.frame(octaves_sum1, octaves_sum2)))
  colnames(octaves_sum) <- seq(length(octaves_sum1))
  # plot
  colours = c("indianred2","steelblue2")
  barplot(octaves_sum,beside = T, main = "Speices abundance octaves",
          xlab = "Species abundance", ylab = "Number of speices",
          col=colours,ylim=c(0,max(octaves_sum)*1.2))
  legend('topright',fill=colours,legend=c('High initial diversity','Low initial diversity'))
  return("The initial condition of the system does not matter. This is because in the created model both the communities will converge to the state of one species left.")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  g1 <- 1 # initial generation
  time_series <- c() # vector of species richness
  sppabd = list() # list of species abundance
  community = init_community_min(size)
  t0 <- proc.time()[3]
  while ((proc.time()[3] - t0)/60 < wall_time) {
    community <- neutral_generation_speciation(community, speciation_rate)
    g1 <- g1 + 1
    if (g1 < burn_in_generations & (g1 %% interval_rich == 0)) { # burn in generations
      time_series <- c(time_series, species_richness(community)) # store species richness
    }
    if (g1 %% interval_oct == 0){ # intervals
      sppabd[[length(sppabd)+1]] <- octaves(species_abundance(community))# store spp abundances as octaves
    }
  }
  save(time_series, sppabd, community, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, file=output_file_name)
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20
process_cluster_results <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  octaves_500 <- c()
  octaves_1000 <- c()
  octaves_2500 <- c()
  octaves_5000 <- c() #create vectors to store octave data
  count_500 <- 0
  count_1000 <- 0
  count_2500 <- 0
  count_5000 <- 0 #counter
  cluster_files <- list.files(".",pattern = ".rda")
  for (i in cluster_files){
    load(i)
    noburn <- burn_in_generations/interval_oct #loop after burn in generation
    for (j in noburn:length(sppabd)){
      if (size == 500){
        octaves_500 <- sum_vect(octaves_500, sppabd[[j]])
        count_500 <- count_500 + 1
      }
      if (size == 1000){
        octaves_1000 <- sum_vect(octaves_1000, sppabd[[j]])
        count_1000 <- count_1000 + 1
      }
      if (size == 2500){
        octaves_2500 <- sum_vect(octaves_2500, sppabd[[j]])
        count_2500 <- count_2500 + 1
      }
      if (size == 5000){
        octaves_5000 <- sum_vect(octaves_5000, sppabd[[j]])
        count_5000 <- count_5000 + 1
      }
    }
  }
  octaves_500 <- octaves_500/count_500 #calculate mean
  octaves_1000 <- octaves_1000/count_1000
  octaves_2500 <- octaves_2500/count_2500
  octaves_5000 <- octaves_5000/count_5000
  #plot
  par(mfrow = c(2, 2))
  par(oma = c(3, 3, 0, 0))
  par(mar = c(2, 2, 2, 2))
  barplot(octaves_500, main="Community size = 500",
          ylim = c(0,max(octaves_500)*1.1),
          names.arg = seq(1,length(octaves_500)))
  #xlab = "Species abundance", ylab = "Number of speices"
  barplot(octaves_1000, main="Community size = 1000",ylim = c(0,max(octaves_1000)*1.1))
  barplot(octaves_2500, main="Community size = 2500",ylim = c(0,max(octaves_2500)*1.1))
  barplot(octaves_5000, main="Community size = 5000",ylim = c(0,max(octaves_5000)*1.1))
  mtext("Species abundance", side = 1, outer = TRUE, line = 0.5)
  mtext("Number of speices", side = 2, outer = TRUE,line = 0.5)
  combined_results <- list(octaves_500, octaves_1000, octaves_2500,octaves_5000) #create your list output here to return
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  D <- log(8)/log(3)
  return(D)
  return("")
}

# Question 22
question_22 <- function()  {
  D <- log(20)/log(3)
  return(list(D, "Dimension is the exponent of number of the self-similar cubes 20 with mignification factor 3, which can be calculated by logarithms."))
}

# Question 23
chaos_game <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  p_abc = list(c(0,0),c(3,4),c(4,1))
  X = c(0,0)
  plot(x=X[1],y=X[2], xlim = c(-0.5,4.5),ylim = c(-0.5,4.5),
       cex = 0.5, pch=16,xlab ="", ylab = "" ) #plot first point
  init<-proc.time()[3]
  repeat{
    move = sample(length(p_abc),1)
    X = (p_abc[[move]]+X)/2
    points(x=X[1],y=X[2], cex = 0.5, pch=16)
    if(proc.time()[3]-init>30){break}
  }
  return("Fractal triangle with three pre-set points.")
}

# Question 24
turtle <- function(start_position, direction, length)  {
  endpoint = c(start_position[1]+length*cos(direction),start_position[2]+length*sin(direction))
  lines(x = c(start_position[1],endpoint[1]), y = c(start_position[2],endpoint[2]))
  return(endpoint) # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  endpoint<-turtle(start_position, direction, length)
  turtle(endpoint,direction+pi/4,0.95*length)
}

# Question 26
spiral <- function(start_position, direction, length)  {
  endpoint<-turtle(start_position, direction, length)
  if(length>1e-10){
    spiral(endpoint,direction+pi/4,0.95*length)
  }
  return("The spiral function calls itself recursively until the line is too short for the computer to draw.")
}

# Question 27
draw_spiral <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(x=0,y=0,xlim = c(-2,2),ylim = c(0,3),cex=0.2,pch = 16)
  spiral(start_position = c(0,0),direction = pi/4,length = 1)
}

# Question 28
tree <- function(start_position, direction, length)  {
  endpoint<-turtle(start_position, direction, length)
  if(length>0.01){
    tree(endpoint,direction-pi/4,0.65*length)
    tree(endpoint,direction+pi/4,0.65*length)
  }
}
draw_tree <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(x=0,y=0,xlim = c(-2,2),ylim = c(0,3),cex=0.2,pch = 16,xlab = "",ylab = "")
  tree(start_position = c(0,0),direction = pi/2,length = 1)
}

# Question 29
fern <- function(start_position, direction, length)  {
  endpoint<-turtle(start_position, direction, length)
  if(length>0.01){
    fern(endpoint,direction+pi/4,0.38*length)
    fern(endpoint,direction,0.87*length)
  }
}
draw_fern <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(x=0,y=0,xlim = c(-3,3),ylim = c(0,8),cex=0.2,pch = 16,xlab = "",ylab = "")
  fern(start_position = c(0,0),direction = pi/2,length = 1)
}

# Question 30
fern2 <- function(start_position, direction, length,dir)  {
  endpoint<-turtle(start_position, direction, length)
  if(length>0.01){
    fern2(endpoint,direction+dir*pi/4,0.38*length,dir)
    fern2(endpoint,direction,0.87*length,dir=-1*dir)
  }
}
draw_fern2 <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(x=0,y=0,xlim = c(-4,4),ylim = c(0,8),cex=0.2,pch = 16,xlab = "",ylab = "")
  fern2(start_position = c(0,0),direction = pi/2,length = 1,dir=1)
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function(community_size = 100, speciation_rate = 0.1, burn_in_generation = 200, confidence_interval = 0.972) {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  community_h <- init_community_max(100)
  spprich_h <- data.frame(matrix(ncol=burn_in_generation,nrow=0))
  community_l <- init_community_min(100)
  spprich_l <- data.frame(matrix(ncol=burn_in_generation,nrow=0))
  repeat{# repeat simulations
    spprich_h <- rbind(spprich_h, neutral_time_series_speciation(community_h, speciation_rate, burn_in_generation))
    spprich_l <- rbind(spprich_l, neutral_time_series_speciation(community_l, speciation_rate, burn_in_generation))
    if(nrow(spprich_h)>50 & (median(spprich_h[1:(nrow(spprich_h)-1),burn_in_generation]) - median(spprich_h[1:nrow(spprich_h),burn_in_generation]) < 1)
      & (median(spprich_l[1:(nrow(spprich_l)-1),burn_in_generation]) - median(spprich_l[1:nrow(spprich_l),burn_in_generation]) < 1)){break}
    }
  err_high <- rep(NA,(burn_in_generation+1)) #empty vector for errors
  err_low <- rep(NA,(burn_in_generation+1))
  for(i in 1:(burn_in_generation + 1)){
    err_high[i]<-qnorm(confidence_interval)*sqrt(var(spprich_h[,i])/nrow(spprich_h)) ## calculate errors
    err_low[i]<-qnorm(confidence_interval)*sqrt(var(spprich_l[,i])/nrow(spprich_l))
  }
  #combine data
  df_h <- data.frame(x =1:(burn_in_generation+1),
                   mean_high = apply(spprich_h, 2, mean),
                   L = apply(spprich_h, 2, median)+err_high,
                   U = apply(spprich_h, 2, median)-err_high)
  df_l <- data.frame(x =1:(burn_in_generation+1),
                     mean_low= apply(spprich_l, 2, mean),
                     L = apply(spprich_l, 2, median)+err_low,
                     U = apply(spprich_l, 2, median)-err_low)
  # estimate the number of generations needed for the system to reach dynamic equilibrium
  high_eqm<-min(which(abs(df_h$mean_high[c(1:(length(df_h$mean_high)-15))]-df_h$mean_high[-c(1:15)])<1))
  low_eqm<-min(which(abs(df_l$mean_low[c(1:(length(df_l$mean_low)-15))]-df_l$mean_low[-c(1:15)])<1))
  plot(c(1,burn_in_generation), c(0,max(spprich_h)), type = "n", 
       xlab = "Generations", ylab = "Species richness")
  #make polygon where coordinates start with lower limit and 
  # then upper limit in reverse order
  polygon(c(df_h$x,rev(df_h$x)),c(df_h$L,rev(df_h$U)), col = alpha("lightpink3",0.6), border = FALSE)
  lines(df_h$x, df_h$mean_high, lwd = 1,col = "lightpink4")
  polygon(c(df_l$x,rev(df_l$x)),c(df_l$L,rev(df_l$U)),col = alpha("lightskyblue3",0.6), border = FALSE)
  lines(df_l$x, df_l$mean_low, lwd = 1,col = "lightskyblue4")
  abline(v=high_eqm, col="lightpink4",lty=2) 
  abline(v=low_eqm, col="lightskyblue4",lty=3)
  legend("topright", col = c("lightpink4", "lightskyblue4"),
         legend = c("High initial diversity", "Low initial diversity"), 
         fill = c(alpha("lightpink3",0.6), alpha("lightskyblue3",0.6)),bty="n",
         title = paste0("Mean with ", confidence_interval," C.I."), 
         lty = 1,merge=T, border = FALSE)
  legend(30,50, legend = c(paste0("High initial diversity: ", high_eqm), 
                           paste0("Low initial diversity: ", low_eqm)),
         col = c("lightpink4", "lightskyblue4"),
         lty = c(2,3), title = "Estimated minimum generation to dynamic equilibrium", cex=0.6)
}

# Challenge question B
Challenge_B <- function(community_size = 100, speciation_rate = 0.1, burn_in_generation = 200) {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  spprich <- data.frame(matrix(ncol=burn_in_generation,nrow=0))
  #mean_rich <- data.frame(matrix(ncol=burn_in_generation,nrow=0))
  for (i in seq(from=1, to=(community_size+1), by=10)){
    ids <- sample(1:100,i, replace = F) # sample species identity
    community<-rep(ids, c(sample(1:100,i, replace = T)),len=100) # create initial community 
    #spprich = matrix(data = 0, nrow = burn_in_generation + 1 , ncol = 30)
    for (j in 1:30){# repeat simulations 30 times
      spprich <- rbind(spprich, neutral_time_series_speciation(community, speciation_rate, burn_in_generation))
      #spprich[,j] = neutral_time_series_speciation(community, 
      #speciation_rate, 
      #burn_in_generation)
      #df <- data.frame(x =1:(burn_in_generation+1), mean = apply(spprich, 2, mean))
    }
    #mean_rich <- rbind(mean,apply(spprich, 2, mean))
    df <- data.frame(x =1:(burn_in_generation+1), mean_rich = apply(spprich, 2, mean))
    #mean_richness = apply(spprich, 2, mean)
    if (i == 1){plot(df$x, df$mean_rich, type = "l",lwd = 1,ylim = c(1,community_size), 
                     xlab = "Generations", ylab = "Species richness")}
    else {lines(df$x, df$mean_rich, lwd = 1)}
  }
}

# Challenge question C
Challenge_C <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
}

# Challenge question D
Challenge_D <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


