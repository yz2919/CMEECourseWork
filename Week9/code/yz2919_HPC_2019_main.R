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
personal_speciation_rate <- 0.005177 # will be assigned to each person individually in class and should be between 0.002 and 0.007

# Question 1
species_richness <- function(community){
  return(length(unique(community))) # spcies richness of input community
}

# Question 2
init_community_max <- function(size){
  return(seq(size)) # return community with species id from 1 to size
}

# Question 3
init_community_min <- function(size){
  return(rep(1, size)) # return community with 1 species with "size" number of individuals
}

# Question 4
choose_two <- function(max_value){ # randomly choose two numbers from 1 to max value
  sample(1:max_value, size = 2, replace = FALSE)
}

# Question 5
neutral_step <- function(community){ 
  index = choose_two(length(community)) # choose 2 individuals to be operated
  community[index[1]] <- community[index[2]] # one to die and the other reproduce to fill the gap
  return(community)
}

# Question 6
neutral_generation <- function(community){
  length_sample = length(community)/2  
  length_sample = sample(c(ceiling(length_sample), floor(length_sample)), 1) # get integer as number of steps
  for (i in 1:length_sample){
    community = neutral_step(community)
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  richness <- c(species_richness(community))
  for (i in 1:duration){
    community = neutral_generation(community) # state of community
    richness <- c(richness,species_richness(community)) # store richness of community
  }
  return(richness)
}

# Question 8
question_8 <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(neutral_time_series(community=init_community_max(100), duration = 200), 
       xlab = "Generation", ylab = "Species Richness",type = 'l', main = "Neutral model simulation \nCommunity size = 100, maximal diversity ")
  return("The system will always converge to state of species richness of 1. This is because species are removed to until only 1 left and no new species are added.")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  index = choose_two(length(community))
  if (runif(1,0,1) < speciation_rate){ # probability of scpeciation
    newspp <- max(community)+1 # new species
    community[index[1]] <- newspp # replace dead individual with new species
  } else {
    community[index[1]] <- community[index[2]] # or neutral step
  }
  return(community)
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  length_sample = length(community)/2
  length_sample = sample(c(ceiling(length_sample), floor(length_sample)), 1) # get integer as number of steps
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
    richness <- c(richness,species_richness(community)) # store sepcies richness
  }
  return(richness)
}

# Question 12
question_12 <- function(community_size = 100, speciation_rate = 0.1, duration = 200)  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(neutral_time_series_speciation(community=init_community_max(community_size), speciation_rate, duration ), 
       ylim = c(0,100),xlab = "Generation", ylab = "Species Richness",type = 'l',col = "indianred", lwd = 1.2)
  lines(neutral_time_series_speciation(community=init_community_min(community_size), speciation_rate, duration), 
       xlab = "Generation", ylab = "Species Richness",type = 'l', col = "steelblue3", lwd = 1.2)
  legend("topright",legend = c("Maximal initial diversity", "Minimal initial diversity"), col = c("indianred", "steelblue3"),title = "Community size = 100", lty = 1,lwd = 1.2)
  title("Neutral model simulation with speciation")
  return("The system will always converge to the similar state regardless of the initial conditions. This is because that species richness will decrease through neutral step and increase through speciation, which result in a dynamic equilibrium. As the speciation rate and time step is the same for both communities, both communities converge to a similar level of equilibrium.")
}

# Question 13
species_abundance <- function(community)  { 
  abundance_vector = c(sort(as.data.frame(table(community))[,2], decreasing = TRUE)) # sort abundance in decending order and store it
  return(abundance_vector)
}

# Question 14
octaves <- function(abundance_vector) {
  octave_classes <- tabulate(1 + floor(log2(abundance_vector))) # log each abundance value by 2 and add 1 for bin number, `tabulate` to put it in corresponding bin
  return(octave_classes)
}

# Question 15
sum_vect <- function(x, y) {
  if (length(x) < length(y)){ # if vector x is short, fill it with 0 to bring it up to the same length as y vector
    x <- c(x,rep(0, times = (length(y)-length(x))))
  }
  if (length(y) < length(x)) { # if vector y is short, fill it with 0 to bring it up to the same length as x vector
    y <- c(y,rep(0, times = (length(x)-length(y))))
  }
  else { # if the length are the same, keep it
    x <- x
    y <- y
  }
  return(x + y) # sum them
}

# Question 16 
question_16 <- function(community_size = 100, speciation_rate = 0.1, duration = 2200, burn_in_generation = 200)  {
  #graphics.off()# clear any existing graphs and plot your graph within the R window
  community_1 <- init_community_max(community_size) # generate communities
  community_2 <- init_community_min(community_size)
  octaves_sum1 <- c() # empty vector for octaves
  octaves_sum2 <- c()
  for (i in 1:burn_in_generation){ # run simulation for a burn in period
    community_1 <- neutral_generation_speciation(community_1, speciation_rate)
    community_2 <- neutral_generation_speciation(community_2, speciation_rate)
  }
    # record species abundance octave vector for burn in generations
    octaves_sum1 <- sum_vect(octaves_sum1,octaves(species_abundance(community_1)))
    octaves_sum2 <- sum_vect(octaves_sum2,octaves(species_abundance(community_2)))

  for (i in (burn_in_generation+1):duration){
    if (i %% 20 == 0){ # record species abundance octave vector after burn in generations every 20 generations
      octaves_sum1 <- sum_vect(octaves_sum1,octaves(species_abundance(community_1)))
      octaves_sum2 <- sum_vect(octaves_sum2,octaves(species_abundance(community_2)))
    }
  }
  average = 1+(duration-burn_in_generation)/20 # average the species abundance distribution, 1 for record of burn in generation
  octaves_sum1 = octaves_sum1/average
  octaves_sum2 = octaves_sum2/average
  ymax <- max(max(octaves_sum1),max(octaves_sum2)) # select maximum value for y axis
  # plot
  par(mfrow = c(1,2))
  par(oma = c(4, 4, 3, 3)) # make room (i.e. the 4's) for the overall x and y axis titles
  par(mar = c(2, 2, 1, 1))
  barplot(octaves_sum1, names.arg =  seq(1:length(octaves_sum1)),
          col="indianred2",ylim=c(0,ymax*1.1))
  barplot(octaves_sum2, names.arg =  seq(1:length(octaves_sum2)),
          col="steelblue2",ylim=c(0,ymax*1.1))
  mtext("Species abundance",side = 1, outer = T, line = 2)
  mtext("Number of speices",side = 2, outer = T, line = 2)
  mtext("Speices abundance distribution (as octaves)",side = 3, outer = T, font = 2,line = 1)
  #legend('topright',fill=colours,legend=c('High initial diversity','Low initial diversity'), title = "Community")
  return("The initial condition of the system does not have significant effect on species abundance distribution. This is because in the neutral model dominant species are more likely to be replaced while species with low abundance are less likely to spread or be replaced. Over long enough simulation, communities of both initial conditions will reach to similar species abundance distribution")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  g1 <- 1 # initial generation
  time_series <- c() # vector of species richness
  sppabd = list() # list of species abundance
  community = init_community_min(size)
  t0 <- proc.time()[3] # start timer
  while ((proc.time()[3] - t0)/60 < wall_time) { # run simulation while running time less than wall time
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
  cluster_files <- list.files(".",pattern = "yz2919_output_") #read in files
  for (i in cluster_files){ # process the files
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
  par(oma = c(2, 3, 5.5, 1))
  par(mar = c(2, 3, 3, 0))
  barplot(octaves_500, main="Community size = 500",
          ylim = c(0,max(octaves_500)*1.2),
          names.arg = seq(1,length(octaves_500)),border = NA, col = "Steelblue2")
  barplot(octaves_1000, main="Community size = 1000",ylim = c(0,max(octaves_1000)*1.2),
          names.arg = seq(1,length(octaves_1000)), border = NA, col = "Steelblue3")
  barplot(octaves_2500, main="Community size = 2500",ylim = c(0,max(octaves_2500)*1.2),
          names.arg = seq(1,length(octaves_2500)), border = NA, col = "Steelblue")
  barplot(octaves_5000, main="Community size = 5000",ylim = c(0,max(octaves_5000)*1.2),
          names.arg = seq(1,length(octaves_5000)), border = NA, col = "Steelblue4")
  mtext("Abundance octaves", side = 1, outer = TRUE, line = 0.5)
  mtext("Number of speices", side = 2, outer = TRUE,line = 0.6)
  mtext("Neutral model simulations using HPC \nMean species abundance octaves \n", side = 3, font = 2, cex = 1.3, outer = TRUE,line = 0.5)
  mtext("Personal speciation rate = 0.005177", side = 3, cex = .9,outer = TRUE, line = .3)
  combined_results <- list(octaves_500, octaves_1000, octaves_2500,octaves_5000) #create your list output here to return
  save(combined_results,file = "yz2919_cluster_results.rda")
  return(combined_results)
}


# Question 21
question_21 <- function()  {
  D <- log(8)/log(3)
  return(list(D, "Dimension is the exponent of number of the self-similar squares 8 with mignification factor 3, which can be calculated by logarithms."))
}

# Question 22
question_22 <- function()  {
  D <- log(20)/log(3)
  return(list(D, "This time dimension is the exponent of number of the self-similar cubes 20 with mignification factor 3, which can be calculated by logarithms."))
}

# Question 23
chaos_game <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  p_abc = list(c(0,0),c(3,4),c(4,1))
  X = c(0,0) 
  plot(x=X[1],y=X[2], xlim = c(-0.5,4.5),ylim = c(-0.5,4.5),
       cex = 0.5, pch=16, axes = F, xlab = NA, ylab = NA, main = "Fractal triangle") #plot first point
  init<-proc.time()[3]
  repeat{ # move the point to form fractal triangle
    move = sample(length(p_abc),1)
    X = (p_abc[[move]]+X)/2 # move half way towards the next point
    points(x=X[1],y=X[2], cex = 0.5, pch=16)
    if(proc.time()[3]-init>28){break} # stop at 28 seconds
  }
  return("The first point moves to form a fractal triangle with three pre-set points. The more the repeats of movement, the more the increasingly smaller fractal triangles will be drawn inside the pre-set triangle.")
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
  plot(x=0, y=0, xlim = c(-2,2), ylim = c(0,3), cex=0.2, pch = 16, xlab = "",ylab = "", axes = F, main = "Spiral")
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
  #plot
  plot(x=0,y=0,xlim = c(-2,2),ylim = c(0,3),cex=0.2,pch = 16,xlab = "",ylab = "", axes = F, main = "Tree")
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
  plot(x=0,y=0,xlim = c(-3,3),ylim = c(0,8),cex=0.2,pch = 16,xlab = "",ylab = "",axes = F, main = "Fern")
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
  plot(x=0,y=0,xlim = c(-4,4),ylim = c(0,8),cex=0.2,pch = 16,xlab = "",ylab = "", axes = F, main = "Fern 2")
  fern2(start_position = c(0,0),direction = pi/2,length = 1,dir=1)
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function(community_size = 100, speciation_rate = 0.1, burn_in_generation = 200, confidence_interval = 0.972) {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  community_h <- init_community_max(100)
  community_l <- init_community_min(100)
  spprich_h <- data.frame(matrix(ncol=burn_in_generation,nrow=0))
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
  # plot
  mycol_h <- rgb(0.4,0,0,alpha=0.6)
  mycol_l <- rgb(0,0.2,0.5,alpha=0.6)
  plot(c(1,burn_in_generation), c(0,max(spprich_h)), type = "n", 
       xlab = "Generation", ylab = "Species richness",main = "Neutral model simulations")
  #make polygon where coordinates start with lower limit and then upper limit in reverse order
  polygon(c(df_h$x,rev(df_h$x)),c(df_h$L,rev(df_h$U)), col = mycol_h, border = FALSE)
  lines(df_h$x, df_h$mean_high, lwd = 1,col = "maroon4")
  polygon(c(df_l$x,rev(df_l$x)),c(df_l$L,rev(df_l$U)),col = mycol_l, border = FALSE)
  lines(df_l$x, df_l$mean_low, lwd = 1,col = "navy")
  abline(v=high_eqm, col="lightpink4",lty=2) 
  abline(v=low_eqm, col="lightskyblue4",lty=3)
  legend("topright", col = c("maroon4", "navy"),
         legend = c("High initial diversity", "Low initial diversity"), 
         fill = c(mycol_h, mycol_l),bty="n",
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
  for (i in seq(from=1, to=community_size, by=9)){ # select community diversity
    ids <- sample(1:community_size,i, replace = F) # sample species identity
    community<-rep(ids, c(sample(1:community_size,(community_size+1)-i, replace = T)),len=100) # create initial community 
    spprich <- data.frame(matrix(ncol=burn_in_generation,nrow=0)) # empty data frame to store richness data
    for (j in 1:30){# repeat simulations 30 times
      spprich <- rbind(spprich, neutral_time_series_speciation(community, speciation_rate, burn_in_generation))
    }
    mean_richness = apply(spprich, 2, mean) #calculate mean species richness for different communities
    if (i == 1){plot(1:(burn_in_generation+1), mean_richness, type = "l",lwd = 1,col = "Steelblue4", ylim = c(1,community_size), 
                     xlab = "Generations", ylab = "Mean species richness", main = "Neutral model simulations with different initial species richnesses")}
    else {lines(1:(burn_in_generation+1), mean_richness, lwd = 1, col = "Steelblue4")} # add lines of different communities
  }
}

# Challenge question C
Challenge_C <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  spprich_500 <- data.frame(matrix(ncol=length(time_series),nrow=0))
  spprich_1000 <- data.frame(matrix(ncol=length(time_series),nrow=0))
  spprich_2500 <- data.frame(matrix(ncol=length(time_series),nrow=0))
  spprich_5000 <- data.frame(matrix(ncol=length(time_series),nrow=0)) #create vectors to store richness data
  count_500 <- 0
  count_1000 <- 0
  count_2500 <- 0
  count_5000 <- 0 #counter
  Gen<-0 # maximun generation 
  cluster_files <- list.files(".",pattern = "yz2919_output_")
  for (i in cluster_files){
    load(i)
    spprich <- rep(0, burn_in_generations)
    for (j in 1:length(time_series)){
      spprich[j] <- time_series[[j]]
      Gen<-ifelse(length(spprich)>Gen,length(time_series),Gen)
    }
    ## save species richness depends on community size
    if(size == 500){
      for(j in 1:length(time_series)){
        spprich[j] <- time_series[[j]]
      }
      spprich_500 <- rbind(spprich_500, spprich)
      count_500 <- count_500 + 1
    }
    if(size == 1000){
      for(j in 1:length(time_series)){
        spprich[j] <- time_series[[j]]
      }
      spprich_1000 <- rbind(spprich_1000, spprich)
      count_1000 <- count_1000 + 1
    }
    
    if(size == 2500){
      for(j in 1:length(time_series)){
        spprich[j] <- time_series[[j]]
      }
      spprich_2500 <- rbind(spprich_2500, spprich)
      count_2500 <- count_2500 + 1
    }
    
    if(size == 5000){
      for(j in 1:length(time_series)){
        spprich[j] <- time_series[[j]]
      }
      spprich_5000 <- rbind(spprich_5000, spprich)
      count_5000 <- count_5000 + 1
    }
  }
  # mean species richness
  mean_500 = apply(spprich_500, 2, mean)
  mean_1000 = apply(spprich_1000, 2, mean)
  mean_2500 = apply(spprich_2500, 2, mean)
  mean_5000 = apply(spprich_5000, 2, mean)
  # calculate how long burn in generation should have been allowed for different community sizes
  eqm_500 <- min(which(abs(mean_500[c(1:(length(mean_500)-200))]-mean_500[-c(1:200)])<1))
  eqm_1000 <- min(which(abs(mean_1000[c(1:(length(mean_1000)-200))]-mean_1000[-c(1:200)])<1))
  eqm_2500 <- min(which(abs(mean_2500[c(1:(length(mean_2500)-200))]-mean_2500[-c(1:200)])<1))
  eqm_5000 <- min(which(abs(mean_5000[c(1:(length(mean_5000)-200))]-mean_5000[-c(1:200)])<1))
  
  # plot
  plot(c(1,Gen), c(0,max(mean_5000)), type = "n", 
       xlab = "Generation", ylab = "Mean species richness", main = "Neutral model simulations using HPC \nPersonal speciation rate = 0.005177")
  lines(mean_500, col = "lightpink4")
  lines(mean_1000, col = "springgreen4")
  lines(mean_2500, col = "steelblue4")
  lines(mean_5000, col = "slategray4")
  abline(v=eqm_500, col="lightpink4",lty=2)
  abline(v=eqm_1000, col="springgreen4",lty=3)
  abline(v=eqm_2500, col="steelblue4",lty=4)
  abline(v=eqm_5000, col="slategray4",lty=5)
  legend(28000,120, col = c("lightpink4", "springgreen4","steelblue4","slategray4"),
         legend = c("500", "1000","2500","5000"), 
         title = "Community size", 
         lty = 1,cex=0.8, border = FALSE)
  legend(10000,45, legend = c(paste0("Size = 500: ", eqm_500), paste0("Size = 1000: ", eqm_1000),
                              paste0("Size = 2500: ", eqm_2500),paste0("Size = 5000: ", eqm_5000)),
         col = c("lightpink4", "springgreen4","steelblue4","slategray4"),
         lty = c(2,3,4,5), title = "Estimated minimum burn in generations to dynamic equilibrium", cex=0.6)
}


# Challenge question D
Challenge_D <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}



# Challenge question E
Challenge_E <- function(X=c(1,1),n=50) {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  p_abc = list(c(0,0),c(3,4),c(4,1))
  X = X
  plot(x=X[1],y=X[2], xlim = c(-0.5,4.5),ylim = c(-0.5,4.5), col = "Indianred",
       cex = 0.9, pch=16,xlab ="", ylab = "",axes = F, main = "Fractal triangle with different initial position") #plot first point
  legend("topright",legend=c("Initial position","First 50 steps","The rest steps"),
         col=c("Indianred","black","steelblue"), 
         pch=c(16,16,16), cex = 0.8 )
  steps <- 0
  init<-proc.time()[3]
  while (steps <= 50){ #first 50 steps
    move = sample(length(p_abc),1)
    X = (p_abc[[move]]+X)/2
    points(x=X[1],y=X[2], cex = 0.9, pch=16,col = "black")
    steps <- steps + 1
  }
  repeat{
        move = sample(length(p_abc),1)
        X = (p_abc[[move]]+X)/2
        points(x=X[1],y=X[2], cex = 0.5, pch = 16, col = "steelblue")
        if(proc.time()[3]-init>10){break}
      }
  return("Different initial position will make early points move outside the fractal triangle, but this effect will gradually decrease to ignorable state. This is because the distance of each movement decreases as the simulations goes on and the distance between new points and fractal triangle will become shorter and shorter.")
}

# Challenge question F
## Draw a dry tree
turtle_dry <- function(start_position, direction, length)  {
  endpoint = c(start_position[1]+length*cos(direction),start_position[2]+length*sin(direction))
  lines(x = c(start_position[1],endpoint[1]), y = c(start_position[2],endpoint[2]),col = "chocolate4")
  return(endpoint) # you should return your endpoint here.
}
dry <- function(start_position, direction, length,dir)  {
  endpoint<-turtle_dry(start_position, direction, length)
  if(length>0.08){
    dry(endpoint,direction+dir*pi/4,0.58*length,dir)
    dry(endpoint,direction+dir*pi/4,0.85*length,dir=-1*dir)
  }
}
draw_dry <- function()  {
  #graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(x=0,y=0, col = "brown", xlim = c(-4,2),ylim = c(0,5.5),cex=0.2,pch = 16,xlab = "",ylab = "", axes = F, main = "Dry tree")
  dry(start_position = c(0,0),direction = pi/2,length = 1,dir = 1)
}

## Draw an unbrella tree
turtle_unbrella <- function(start_position, direction, length)  {
  endpoint = c(start_position[1]+length*cos(direction),start_position[2]+length*sin(direction))
  newpoint = c(endpoint[1]+length*cos(direction),endpoint[2]+length*sin(direction))
  if (length > 0.069) mycolour <- "chocolate4" # branch colour
  else mycolour <- "springgreen" # set leaves colour
  lines(x = c(start_position[1],endpoint[1]), y = c(start_position[2],endpoint[2]),col=mycolour)
  return(newpoint) # you should return your endpoint here.
}
unbrella <- function(start_position, direction, length,dir)  {
  newpoint<-turtle_unbrella(start_position, direction, length)
  endpoint<-turtle(start_position, direction, length)
  if(length>0.06){
    unbrella(newpoint,direction+dir*pi/6,0.78*length,dir)
    unbrella(endpoint,direction,0.85*length,dir=-1*dir)
  }
}
draw_unbrella_tree <- function()  {
  #graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(x=0,y=0, col = "brown", xlim = c(-4,4),ylim = c(0,5.5),cex=0.2,pch = 16,xlab = "",ylab = "", axes = F, main = "Unbrella tree")
  unbrella(start_position = c(0,0),direction = pi/2,length = .75,dir = 1)
}
### Challenge_F
Challenge_F <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  par(mfrow = c(1, 2))
  par(oma = c(3, 0, 3, 0))
  par(mar = c(2, 0, 2, 0))
  draw_dry()
  draw_unbrella_tree()
  mtext("Lovely trees aren't they? Thank you for your efforts and help!", side = 1, outer = T)
  return("The smaller the line size threshold, the longer it takes to run the function and the lines in the image become denser.")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


