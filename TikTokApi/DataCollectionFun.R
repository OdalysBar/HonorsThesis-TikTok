
# /////////////////// CONVERT.BINARY.SEQ() ///////////////////
#
#
#' convert.binary.seq() is a function that will convert timestamps that are in unix 
#' time (in min) into a binary sequence of ones and zeros (one indicating the were 
#' active and a zero indicating they were not active)
#' 
#' @param time : A vector contianing the unix time stamps in min
#' @param interval : An whole number that will create bins of time in min
#' @param starttime : A number in unix time in min at which the first bin should start 
#' @param endtime : A number in unix time in min at which we the last bin should end
#' 
#' @return binary.seq : A vector of ones and zeros 
#' 
convert.binary.seq <- function(time, interval, starttime, endtime){
  max.bins <- round((endtime -starttime)/interval) 
  # this give us back the total number of bins to have 
  bin.num <- ((time-starttime)%/%interval)+1
  
  binary.seq <- c(rep(0,length.out=max.bins)) # creating a vector of 0s
  binary.seq[bin.num] <- 1 # putting a 1 in the bin where the user was active 
  return(binary.seq) # returns a binary sequence (vector) of 0s and 1s
}


# /////////////////// SAVE.BINSEQ() ///////////////////
#
#
#' save.binseq() is a function that will save the binary sequence data in different 
#' formats of all the TikTok users 
#' 
#' @param starttime
#'
#'
save.binseq <- function(starttime , endtime) {
  weeks <- 118 # number of weeks in our data collection
  intervals <- 336 # the number of 30min intervals in a week
  matrix <- matrix(NA, nrow=weeks, ncol=intervals) 
  # matrix will hold 0s and 1s for the given user
  mat.logistic.reg <- matrix(NA, nrow=2, ncol=weeks*intervals) 
  mat.logistic.reg[2,] <- rep(1:336, 118)
  
  user.index <- c(1:136)
  # this vector will be used when saving the plots and individual matrix
  
  list.out <- list() # list that will contain all 136 matrices (for 136 users) 
  list.matintervals <- list()
  
  usersdata.time <-Sys.glob("HonThesis-OdalysBar/extract-from-odalyss-list/timestamps/*")
  
  for(i in 1:length(usersdata.time)){ # from the first to last user
    # DATA CLEANING
    my_data <- read.delim(usersdata.time[i],header = FALSE)$V1/60
    # importing user timestamps & converting sec to min
    my_data <- my_data[which(my_data >= starttime)] 
    # removing data from before start time
    
    # Converting unix timestamps into a binary sequence
    bin.seq <-convert.binary.seq(my_data, interval = 30, starttime = starttime , endtime = endtime) 
    
    
    # Preparing to save binary time stamps 
    # we will save this matrix going week by week, every 336 time intervals 
    endweek <- 336 
    begweek <- 1  
    string.binary <- vector()
    for (n in 1:weeks){ 
      # separating bin.seq into weeks 
      # creating a matrix to see the data week by week (from week 1 to week 118)
      
      # Saving into different formats
      matrix[n, ] <- bin.seq[begweek:endweek] # matrix with spaces week by week
      mat.logistic.reg[1,begweek:endweek] <- bin.seq[begweek:endweek] # matrix with 2 rows 
      string.binary[n] <- paste0(matrix[n,], collapse = "") # cssr modeling 
      
      # moving on to the following week 
      endweek <- endweek + 336
      begweek <- begweek + 336
    }
    # ///////////SAVE OUT DATA///////////
    # writeLines(string.binary, sprintf("cssrData-%s.txt", user.index[i]))
    # write.table(matrix, file=sprintf("matrix-%s.txt", user.index[i]), row.names=FALSE, col.names=FALSE)
    # write.table(mat.log, file=sprintf("matlogistic-%s.txt", user.index[i]), row.names=FALSE, col.names=FALSE)
    
    matrix.spaces[[i]] <- matrix # saving bin seq matrix into a list
    matrix.logit[[i]] <- mat.logistic.reg # saving bin seq matrix into a list
  }
  return(list(weeklymatrix.users = matrix.spaces, users = usersdata.time, matrixbyintervals = matrix.logit))
}
