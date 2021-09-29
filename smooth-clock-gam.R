library(doParallel)
library(gam)
cl <- makeCluster(8)
registerDoParallel(cl)


for(i in 1:136){
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
cv.out <- cv.clock.gam(dat)

graphics.off()
jpeg(sprintf("smoothparam-%s.jpeg", i),width=1000, height = 800)
plot(cv.out$spars, cv.out$negative.LLs, 
     xlab = 'Smoothing Parameter',
     ylab = 'CV-ed Negative Log-Likelihood')
abline(v = cv.out$spar.star)
dev.off()


mod <- gam(Y ~ s(x, spar = cv.out$spar.star), family = binomial)
graphics.off()
jpeg(sprintf("model-%s.jpeg", i),width=2000, height = 800)
plot(predict(mod, type = 'response')[1:ncol(dat)], type = 'l', ylim = c(0, 0.2),
     xlab = 'Time (1/2 Hour Segments)', ylab = 'Probability User is Active')
points(x, Y*0.2, pch = 16, cex = 0.1)

# Add smoothing spline fit via least-squares for comparison
lines(smooth.spline(x, Y), col = 'red', lty = 2)
dev.off()
}
