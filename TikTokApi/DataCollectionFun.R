jan1.18 <- 1546318800/60 # start time
april13.21 <- 26971697 # end time 

# time = data, all the timestamps 
# interval = will create the bins (ex: 30 min intervals)
convert.binary.seq <- function(time, interval, starttime = jan1.18 , endtime = april13.21){
  max.bins <- round((endtime -starttime)/interval) 
  # this give us back the total number of bins to have 
  bin.num <- ((time-starttime)%/%interval)+1
  
  binary.seq <- c(rep(0,length.out=max.bins)) # creating a vector of 0s
  binary.seq[bin.num] <- 1 # putting a 1 in the bin where the user was active 
  return(binary.seq) # returns a binary sequence (vector) of 0s and 1s
}


save.binseq <- function(starttime = jan1.18, endtime = april13.21) {
  weeks <- 118 # number of weeks in our data collection
  intervals <- 336
  matrix <- matrix(NA, nrow=weeks, ncol=intervals) # maxtrix with spaces
  # 336 30 min intervals in a week 
  # matrix will hold 0s and 1s for the given user
  # rows are weeks and columns are the 30 intervals
  matrix.nospaces <- matrix(NA, nrow=weeks, ncol=1)
  mat.logistic.reg <- matrix(NA, nrow=2, ncol=weeks*intervals) 
  mat.logistic.reg[2,] <- rep(1:336, 118)
  
  user.index <- c(1:136)
  # this vector will be used when saving the plots and individual matrix
  
  list.out <- list() # list that will contain all the matrices (136 matrices) 
  list.matintervals <- list()
  
  usersdata.time <-Sys.glob("HonThesis-OdalysBar/extract-from-odalyss-list/timestamps/*")
  
  for(i in 1:length(usersdata.time)){ # from the first to last user
    #for(i in c(1)){  
    # DATA CLEANING
    my_data <- read.delim(usersdata.time[i],header = FALSE)$V1/60
    # importing user timestamps & converting sec to min
    my_data <- my_data[which(my_data >= starttime)] 
    # removing data from before Jan 1 2018
    
    # Converting unix timestamps into a binary sequence
    bin.seq <-convert.binary.seq(my_data, interval = 30, starttime = starttime , endtime = endtime) 
    
    # Preparing to save binary time stamps into matrix called "matrix"
    # we will save this matrix going week by week, every 336 time intervals 
    endweek <- 336 # there are 336 30 min intervals in a week 
    begweek <- 1  
    string.binary <- vector()
    
    
    for (n in 1:weeks){ 
      
      # separating binary seq into weeks from week 1 to week 118
      # creating a matrix to see the data week by week
      matrix[n, ] <- bin.seq[begweek:endweek]
      mat.logistic.reg[1,begweek:endweek] <- bin.seq[begweek:endweek]
      # cleaning matrix.nospaces so there are no spaces between 0s and 1s 
      string.binary[n] <- paste0(matrix[n,], collapse = "")
      
      # moving on to the following week 
      endweek <- endweek + 336
      begweek <- begweek + 336
    }
    
    # ///////////SAVE OUT DATA///////////
    writeLines(string.binary, sprintf("cssrData-%s.txt", user.index[i]))
    # write.table(matrix, file=sprintf("matrix-%s.txt", user.index[i]), row.names=FALSE, col.names=FALSE)
    # write.table(mat.log, file=sprintf("matlogistic-%s.txt", user.index[i]), row.names=FALSE, col.names=FALSE)
    
    list.out[[i]] <- matrix # saving bin seq matrix into a list
    list.matintervals[[i]] <- mat.logistic.reg # saving bin seq matrix into a list
  }
  return(list(weeklymatrix.users = list.out, users = usersdata.time, matrixbyintervals = list.matintervals))
}

# USED TO SAVE TXT FILES
# for each use with the binary seq
# split.string <- strsplit(data.time[i], "/")[[1]][4] # to find user name
# username <- strsplit(split.string, "_timestamps")[[1]][1] # to find user name
# write.table(list(tmp), file = paste0("seq", "_", username, ".txt")) # saving binary seq as txt file


# 168 hours in 1 week so 169*2 = 336 for 30min intervals
# 52 weeks in 1 year
# our data is roughly 2 years 3 months and 2 weeks
# 52*2+3*4+2 = 118 weeks/ rows 


