cv.clock.gam <- function(dat, fold.size = 26, spars = seq(0, 0.8, by = 0.05)){
  #' Compute the smoothing parameter for a GAM from the gam package using
  #' cross-validation.
  #'
  #' Compute the smoothing parameter for a GAM from the gam package using
  #' cross-validation. Cross-validation is done sequentially, using folds of
  #' size `fold.size`, by dividing the data into
  #' 
  #'      `n.folds <- ceiling(nrow(dat)/fold.size)`,
  #' 
  #' holding out the data within a fold, estimating the model with the
  #' remaining data, and evaluating the model (via the negative log-likelihood
  #' of the binomial model) on the held-out fold.
  #'
  #' @param dat the data as a matrix of 0s and 1s, with one row per week
  #' @param fold.size the size of each of the full folds
  #' @param spars the candidate values for the smoothing parameter
  #'
  #' @return A list containing the optimal value `spar.star` for the 
  #' smoothing parameter, the candidate smoothing values `spars`, and the
  #' negative log-likelihoods `negative.LLs` at each smoothing value.
  
  n.folds <- ceiling(nrow(dat)/fold.size) # Number of folds to use.
  
  D <- t(dat) # Make data column-oriented since R stores matrices
              # in a column-oriented fashion.
  
  # Create design points for one week's worth of time.
  
  clock.ticks <- 1:ncol(dat)
  
  # Create placeholder for the negative log-likelihoods of the data.
  
  Ls <- rep(0, length(spars))
  
  for (j in 1:n.folds){
    # The rows of data in dat that are in the current evaluation
    # set.
    
    fold.inds <- ((j-1)*fold.size+1):min((j*fold.size), nrow(dat))
    
    # Separate the data into the portion outside of and in 
    # the current evaluation set.
    
    Y.out <- D[, fold.inds]
    Y.in <- D[, -fold.inds]
    
    # Create design points for clock.
    
    x.out <- rep(clock.ticks, ncol(Y.out))
    x.in  <- rep(clock.ticks, ncol(Y.in))

    
    # Flatten the matrices to a flat vector.
    
    dim(Y.in) <- NULL
    dim(Y.out) <- NULL
    
    # Store the estimation data in a data frame.
    
    df <- data.frame(x = x.in, Y = Y.in)
    
    # Compute the contribution to the negative log-likelihood at each
    # value of the value of the smoothing parameter spar.
    
    # for (s in 1:length(spars)){
    dls <- foreach(s = 1:length(spars), .packages='gam') %dopar%{
      sp <- spars[s]
      
      .GlobalEnv$sp <- sp
      
      mod <- gam(Y ~ s(x, spar = sp), data = df, family = binomial)
      
      probs <- predict(mod, newdata = data.frame(x = x.out), type = 'response')
      
      sum(-(Y.out*log(probs) + (1 - Y.out)*log(1 - probs)))
    }
    
    # Accumulate the contributions of the current fold at each value of the
    # smoothing parameter spar.
    
    Ls <- Ls + unlist(dls)
  }
  
  # Find minimizing value for sparsity and the corresponding sparsity value.
  
  L.star <- which.min(Ls)
  
  spar.star <- spars[L.star]
  
  return(list(spar.star = spar.star, spars = spars, negative.LLs = Ls, clock.ticks = clock.ticks))
}