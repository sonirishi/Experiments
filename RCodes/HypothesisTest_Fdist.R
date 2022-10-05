n <- 10000
count <- 100 ## df = 99

stat <- matrix(rep(0,n),n,1)

pval <- matrix(rep(0,n),n,1)

rv1 <- matrix(rep(0,n),n,count)

rv2 <- matrix(rep(0,n),n,count)

var_rv1 <- matrix(rep(0,n),n,1)
var_rv2 <- matrix(rep(0,n),n,1)

for(i in 1:n){
  rv1[i,] <- rnorm(count,5,3)
  rv2[i,] <- rnorm(count,5,3)
  var_rv1[i,1] <- var(rv1[i,])
  var_rv2[i,1] <- var(rv2[i,])
  stat[i,1] <- var_rv1[i,1]/var_rv2[i,1]
  pval[i,1] <- pf(stat[i,1],count-1,count-1)
}

hist(pval)  ## p vals are uniformly distributed

sample_chisq <- rchisq(n,df=count-1,ncp = 9)
sample_chisq <- sample_chisq*mean(var_rv1)/mean(sample_chisq)
### scaled chisq to have the same mean as the hist of var_rv1

hist(var_rv1,col="peachpuff",prob=T)
lines(density(sample_chisq),col = "chocolate3",lwd=4)

############################################################

n <- 10000
count <- 100 ## df = 99

stat <- matrix(rep(0,n),n,1)

pval <- matrix(rep(0,n),n,1)

rv1 <- matrix(rep(0,n),n,count)

rv2 <- matrix(rep(0,n),n,count)

var_rv1 <- matrix(rep(0,n),n,1)
var_rv2 <- matrix(rep(0,n),n,1)

for(i in 1:n){
  rv1[i,] <- rlnorm(count,5,3)
  rv2[i,] <- rlnorm(count,5,3)
  var_rv1[i,1] <- var(rv1[i,])
  var_rv2[i,1] <- var(rv2[i,])
  stat[i,1] <- var_rv1[i,1]/var_rv2[i,1]
  pval[i,1] <- pf(stat[i,1],count-1,count-1)
}

hist(pval)  ## p vals are uniformly distributed

sample_chisq <- rchisq(n,df=count-1,ncp = 9)
sample_chisq <- sample_chisq*mean(var_rv1)/mean(sample_chisq)
### scaled chisq to have the same mean as the hist of var_rv1

hist(var_rv1,col="peachpuff",prob=T)
lines(density(sample_chisq),col = "chocolate3",lwd=4)

#######################################################
## Uniform has lighter tails than normal

n <- 10000
count <- 100 ## df = 99

stat <- matrix(rep(0,n),n,1)

pval <- matrix(rep(0,n),n,1)

rv1 <- matrix(rep(0,n),n,count)

rv2 <- matrix(rep(0,n),n,count)

var_rv1 <- matrix(rep(0,n),n,1)
var_rv2 <- matrix(rep(0,n),n,1)

for(i in 1:n){
  rv1[i,] <- runif(count,2,8)
  rv2[i,] <- runif(count,2,8)
  var_rv1[i,1] <- var(rv1[i,])
  var_rv2[i,1] <- var(rv2[i,])
  stat[i,1] <- var_rv1[i,1]/var_rv2[i,1]
  pval[i,1] <- pf(stat[i,1],count-1,count-1)
}

hist(pval)  ## p vals are uniformly distributed

sample_chisq <- rchisq(n,df=count-1,ncp = 9)
sample_chisq <- sample_chisq*mean(var_rv1)/mean(sample_chisq)
### scaled chisq to have the same mean as the hist of var_rv1

hist(var_rv1,col="peachpuff",prob=T)
lines(density(sample_chisq),col = "chocolate3",lwd=4)


##########################

norm1 <- rnorm(10000,5,sqrt(3))
unif <- runif(10000,2,8)

plot(density(norm1),col='chocolate3')
lines(density(unif),lwd=3,col='peachpuff') 

## intuitively also the uniform distribution is cut at the ends while
## Normal goes on