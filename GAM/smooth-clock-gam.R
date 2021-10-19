library(doParallel)
library(gam)
cl <- makeCluster(8)
registerDoParallel(cl)
param.LL <- matrix(data=NA, nrow=2, ncol=33)
param.LL.pad <- matrix(data=NA, nrow=2, ncol=33)

#for(i in 1:136){
#for(i in c(1)){
which.user <- i

# Read in by-week data as data.frame.
dat <- read.table(sprintf('BinSeq-MatrixWSpaces/matrix-%g.txt', which.user), sep = ' ', header = FALSE)

# Convert to matrix
dat <- data.matrix(dat)

# Take transpose to make column-oriented (one week per column), so 
# can flatten easily into long vector.
Y <- t(dat)

# Flatten matrix to long vector.
dim(Y) <- NULL

# Get out design points as clock times.
x <- rep(1:ncol(dat), nrow(dat))


source('cv-clock-gam.R')
cv.out <- cv.clock.gam(dat, spars=seq(0,1.6,by=0.05))

# Show Cross-validated Negative Log-likelihood as a Function of the Smoothing Parameter
# plot(cv.out$spars, cv.out$negative.LLs, 
#      xlab = 'Smoothing Parameter',
#      ylab = 'CV-ed Negative Log-Likelihood')
# abline(v = cv.out$spar.star)
param.LL[1,] <- cv.out$spars
param.LL[2,] <- cv.out$negative.LLs
rownames(param.LL) <- c("smoothparam", "negative.LL")
write.table(param.LL,file=sprintf("smoothpar-NLL-%s.txt", i), col.names = FALSE)


# Fit the GAM at the Optimal Smoothing Parameter
mod.unpadded <- gam(Y ~ s(x, spar = cv.out$spar.star), family = binomial)
graphics.off()
jpeg(sprintf("modelUNpadded-LSqu-%s.jpeg", i),width=2000, height = 800)
plot(predict(mod.unpadded, type = 'response')[1:ncol(dat)], type = 'l', ylim = c(0, 0.2),
     xlab = 'Time (1/2 Hour Segments)', ylab = 'Probability User is Active')
points(x, Y*0.2, pch = 16, cex = 0.1)

# Add smoothing spline fit via least-squares for comparison
lines(smooth.spline(x, Y), col = 'red', lty = 2)
dev.off()

# ==================================================================
# PAD the data
prepost.pad.amount <- 48
dat.padded <- cbind(matrix(0, nrow = nrow(dat), ncol = prepost.pad.amount),
                    dat,
                    matrix(0, nrow = nrow(dat), ncol = prepost.pad.amount))

dat.padded[2:nrow(dat.padded), 1:(prepost.pad.amount)] <- 
  dat[1:(nrow(dat)-1), (ncol(dat) - prepost.pad.amount + 1):ncol(dat)]

dat.padded[1:(nrow(dat.padded)-1), (ncol(dat.padded)-prepost.pad.amount + 1):ncol(dat.padded)] <-
  dat[2:(nrow(dat.padded)), 1:prepost.pad.amount]

# Drop first and last week, since 0-padded:
dat.padded <- dat.padded[2:(nrow(dat.padded) - 1), ]

Y.padded <- t(dat.padded)
dim(Y.padded) <- NULL


cv.out <- cv.clock.gam(dat.padded, spars=seq(0,1.6,by=0.05))

param.LL.pad[1,] <- cv.out$spars
param.LL.pad[2,] <- cv.out$negative.LLs
rownames(param.LL.pad) <- c("smoothparam", "negative.LL")
write.table(param.LL.pad,file=sprintf("smoothpar-NLL-Padded-%s.txt", i), col.names = FALSE)

x.wrapped <- rep(cv.out$clock.ticks, nrow(dat.padded))

graphics.off()
jpeg(sprintf("modelPadded-%s.jpeg", i),width=2000, height = 800)
mod.padded <- gam(Y.padded ~ s(x.wrapped, spar = cv.out$spar.star), family = binomial)
# PAD PLOT
plot(predict(mod.padded, type = 'response')[(1+prepost.pad.amount):(ncol(dat.padded) - prepost.pad.amount)], type = 'l', ylim = c(0, 0.2),
     xlab = 'Time (1/2 Hour Segments)', ylab = 'Probability User is Active')
points(x.wrapped, Y.padded*0.2, pch = 16, cex = 0.1)
dev.off()

# COMPARE Unpadded and Padded Fits
fit.without.padding <- predict(mod.unpadded, type = 'response')[1:ncol(dat)]

fit.with.padding <- predict(mod.padded, type = 'response')[(1+prepost.pad.amount):(ncol(dat.padded) - prepost.pad.amount)]

graphics.off()
jpeg(sprintf("modelCompare-%s.jpeg", i),width=2000, height = 800)
plot(fit.without.padding, type = 'l', col = 'red',
     xlab = 'Time (1/2 Hour Segments)', ylab = 'Probability User is Active',
     ylim = c(0, 0.2))
lines(fit.with.padding, type = 'l', col = 'blue')
legend('topright', legend = c('Unwrapped', 'Wrapped'), col = c('red', 'blue'), lty = 1)
dev.off()
}




# =============================================================


#graphics.off()
#jpeg(sprintf("smoothparam-%s.jpeg", i),width=1000, height = 800)
# plot(cv.out$spars, cv.out$negative.LLs, 
#      xlab = 'Smoothing Parameter',
#      ylab = 'CV-ed Negative Log-Likelihood')
# abline(v = cv.out$spar.star)
# #dev.off()
# 
# 
# mod <- gam(Y ~ s(x, spar = cv.out$spar.star), family = binomial)
# #graphics.off()
# #jpeg(sprintf("model-%s.jpeg", i),width=2000, height = 800)
# plot(predict(mod, type = 'response')[1:ncol(dat)], type = 'l', ylim = c(0, 0.2),
#      xlab = 'Time (1/2 Hour Segments)', ylab = 'Probability User is Active')
# points(x, Y*0.2, pch = 16, cex = 0.1)
# 
# # Add smoothing spline fit via least-squares for comparison
# lines(smooth.spline(x, Y), col = 'red', lty = 2)
# #dev.off()
# }
