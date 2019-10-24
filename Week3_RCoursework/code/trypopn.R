doit <- function(x){
        temp_x <- sample(popn, replace = TRUE)
        if(length(unique(temp_x)) > 30){
            print(paste("Mean of this sample was:", as.character(mean(temp_x))))
        }
    else {stop("Couldn't calculate mean: too few unique value!")
    }
        
}