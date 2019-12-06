#!/bin/env R

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: yz2919_HPC_2019_main.R
# Description: Neutral theory simulations functions input and fractals functions script
# Arguments: 0
# Date: Nov 2019
# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Yuqing Zhou"
preferred_name <- "Yuqing"
email <- "yz2919@imperial.ac.uk"
username <- "yz2919"
personal_speciation_rate <- 0.002 # will be assigned to each person individually in class and should be between 0.002 and 0.007

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
  # clear any existing graphs and plot your graph within the R window
  plot(neutral_time_series(community=init_community_max(100), duration = 200), 
       xlab = "Generation", ylab = "Species Richness",type = 'l')
  return("The system will always converge to stae of low species richness. This is because most species are rapidly removed by natural selection.")
}
question_8()

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
question_12 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  plot(neutral_time_series_speciation(community=init_community_max(100), speciation_rate = 0.1, duration = 200), 
       xlab = "Generation", ylab = "Species Richness",type = 'l',col = "indianred")
  lines(neutral_time_series_speciation(community=init_community_min(100), speciation_rate = 0.1, duration = 200), 
       xlab = "Generation", ylab = "Species Richness",type = 'l', col = "steelblue3")
  legend("topright",legend = c("Community 1", "Community 2"), col = c("indianred", "steelblue3"), lty = 1)
  return("type your written answer here")
}
question_12()

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
question_16 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  community_1 <- init_community_max(100)
  octaves_sum <- c()
  # community_2 <- init_community_min(100)
  for (i in 1:2200){
    community_1 <- neutral_generation_speciation(community_1, speciation_rate = 0.1)
    if (i > 200 & (i %% 20 == 0)){
      octaves_sum <- sum_vect(octaves_sum,octaves(species_abundance(community_1)))
    }
  }
  # neutral_generation_speciation(community_2, speciation_rate = 0.1)
  barplot(octaves_sum/100, xlab = "Speices", ylab = "Specis abundance")
  return("type your written answer here")
}
question_16()

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  t0 <- proc.time()[3]
  g1 <- 1 # initial generation
  time_series <- c() # vector of species richness
  sppabd = list() # list of species abundance
  community_run = init_community_min(size)
  while ((proc.time()[3] - t0)/60 < wall_time) {
    community_run <- neutral_generation_speciation(community_run, speciation_rate)
    g1 <- g1 + 1
    if (g1 < burn_in_generations & g1 %% interval_rich == 0) {
      time_series <- c(time_series, species_richness(community_run)) # store species richness
    }
    if (g1 %% interval_oct == 0){
      sppabd[[length(sppabd)+1]] <- octaves(species_abundance(community_run))# store spp abundances as octaves
    }
  }
  save(time_series, sppabd, community_run, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, file= paste0("../results/",output_file_name))
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  
  combined_results <- list() #create your list output here to return
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
  return(D)
  return("type your written answer here")
}

# Question 23
chaos_game <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  p_abc <- as.matrix(data.frame(a=c(0,3,4),b=c(0,4,1)))
  
  X <- c(0,0)
  
  repeat{
    X <- sample(dim(p_abc)[1],1)
    plot(X, cex = 0.9, )
  }
  
  return("Fractal triangle")
}

# Question 24
turtle <- function(start_position, direction, length)  {

  return() # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  
}

# Question 26
spiral <- function(start_position, direction, length)  {
  return("type your written answer here")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
}

# Question 28
tree <- function(start_position, direction, length)  {
  
}
draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 29
fern <- function(start_position, direction, length)  {
  
}
draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 30
fern2 <- function(start_position, direction, length)  {
  
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


