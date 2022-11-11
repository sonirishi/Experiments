rm(list=ls(all=T))
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

plot(density(var_rv1))
plot(density(var_rv2))

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

hist(pval)  

plot(density(var_rv1))
plot(density(var_rv2))

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

plot(density(var_rv1))
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

#######################################################
#### Auto Correlated RV #####

n <- 10000
count <- 100 ## df = 99

stat <- matrix(rep(0,n),n,1)

pval <- matrix(rep(0,n),n,1)

rv1 <- matrix(rep(0,n),n,count)

rv2 <- matrix(rep(0,n),n,count)

var_rv1 <- matrix(rep(0,n),n,1)
var_rv2 <- matrix(rep(0,n),n,1)

generate_AR_data <- function(coeff,start,n,std){
  temp <- matrix(rep(0,n),n,1)
  for(i in 1:n){
    if(i == 1){
      temp[i] = start
    } else{
      temp[i] = coeff*temp[i-1] + rnorm(1,0,std)
    }
  }
  return(temp)
}

generate_fdist <- function(n,corr,start,count,std){
  for(i in 1:n){
    rv1[i,] <- generate_AR_data(corr,start,count,std)
    rv2[i,] <- generate_AR_data(corr,start,count,std)
    var_rv1[i,1] <- var(rv1[i,])
    var_rv2[i,1] <- var(rv2[i,])
    stat[i,1] <- var_rv1[i,1]/var_rv2[i,1]
    pval[i,1] <- pf(stat[i,1],count-1,count-1)
  }
  return(list(rv1, rv2, var_rv1, var_rv2, stat, pval))
}

op_list = generate_fdist(n,0.5,0.8,count,1)

hist(op_list[[6]]) ## p vals are not uniformly distributed, auto-correlated data

plot(density(op_list[[3]]))
plot(density(op_list[[4]]))

sample_chisq <- rchisq(n,df=count-1,ncp = 9)
sample_chisq <- sample_chisq*mean(var_rv1)/mean(sample_chisq)
### scaled chisq to have the same mean as the hist of var_rv1

hist(var_rv1,col="peachpuff",prob=T)
lines(density(sample_chisq),col = "chocolate3",lwd=4)

clt <- function(n,corr,start,count,std){
  for(i in 1:n){
    rv1[i,] <- generate_AR_data(corr,start,count,std)
    stat[i,1] = mean(rv1[i,1])
  }
  return(stat)
}

plot(density(clt(n,0.5,0.8,count,1)))

######################################################
### autocorrelated series t-test simulation ####

n <- 10000
count <- 1000

stat1 <- matrix(rep(0,n),n,1)
stat2 <- matrix(rep(0,n),n,1)
stat3 <- matrix(rep(0,n),n,1)
stat4 <- matrix(rep(0,n),n,1)

pval1 <- matrix(rep(0,n),n,1)
pval2 <- matrix(rep(0,n),n,1)
pval3 <- matrix(rep(0,n),n,1)
pval4 <- matrix(rep(0,n),n,1)

rv1 <- matrix(rep(0,n),n,count)

rv2 <- matrix(rep(0,n),n,count)

df2 = matrix(rep(0,n),n,1)

NWtest <- function(ret,lag,count){
  vv = var(ret)
  temp = 0
  for (l in (1:lag)){
    cc=cov(ret[seq(1,count-l)],ret[seq(l+1,count)])
    temp=temp+2*(1-(l/lag))*cc
  }
  vv = vv + temp
  return(vv[1])
}

## (1-l/(lag+1)) is bartett kernel

generate_AR_data_1 <- function(coeff,start,n,mean,std){
  temp <- matrix(rep(0,n),n,1)
  for(i in 1:n){
    if(i == 1){
      temp[i] = start
    } else{
      temp[i] = coeff*temp[i-1] + rnorm(1,mean,std)
    }
  }
  return(temp)
}

mean_diff <- matrix(rep(0,n),n,1)


simulate_ar <- function(n,ar,start){
  for(i in 1:n){
    rv1[i,] <- generate_AR_data_1(ar,start,count,0,1)
    rv2[i,] <- generate_AR_data_1(ar,start,count,0,1)
    mean_diff <- (mean(rv1[i,]) - mean(rv2[i,]))
    stat1[i,1] <- (mean(rv1[i,]) - mean(rv2[i,]))/sqrt(var(rv1[i,])/count + 
                                                         var(rv2[i,])/count)
    
    ## as it is a 2 sided test hence we have to calc p values that ways
    pval1[i,1] <- ifelse((1-pt(stat1[i,1],df=count*2-2)) > 0.5, 
                         pt(stat1[i,1],df=count*2-2)*2,
                         (1-pt(stat1[i,1],df=count*2-2))*2)
    stat2[i,1] <- t.test(rv1[i,],rv2[i,],alternative="two.sided",var.equal=F)$statistic[[1]]
    
    pval2[i,1] <- t.test(rv1[i,],rv2[i,],alternative="two.sided",var.equal=F)$p.value
    df2[i,1] <- t.test(rv1[i,],rv2[i,],alternative="two.sided",var.equal=F)$parameter
    
    stat3[i,1] <- (mean(rv1[i,]) - mean(rv2[i,]))/sqrt((var(rv1[i,])/count)*(1/(1-ar^2)) + 
                                                         (var(rv2[i,])/count)*(1/(1-ar^2)))
    pval3[i,1] <- ifelse((1-pt(stat3[i,1],df=count*2-2)) > 0.5, 
                         pt(stat3[i,1],df=count*2-2)*2,
                         (1-pt(stat3[i,1],df=count*2-2))*2)
    
    stat4[i,1] <- (mean(rv1[i,]) - mean(rv2[i,]))/sqrt((NWtest(rv1[i,],1,count) + 
                                                          (NWtest(rv2[i,],1,count))))
    pval4[i,1] <- ifelse((1-pt(stat4[i,1],df=count*2-2)) > 0.5,
                         pt(stat4[i,1],df=count*2-2)*2,
                         (1-pt(stat4[i,1],df=count*2-2))*2)
  }
  return(list(pval1,pval2,pval3,pval4))
}

pval <- simulate_ar(n,0.5,0.8)

hist(pval[[1]]) ## bad p values due to wrong variance
hist(pval[[2]]) ## bad p values due to wrong variance
hist(pval[[3]])  ## some correction which is not enough, we need newey west
hist(pval[[4]])  ## newey west std errors hence better p values but still not great

############### TS correlation ##############

n <- 10000
count <- 100

corr_ts <- matrix(rep(0,n),n,1)

corr_model <- function(n,count,ar1,ar2,std1,std2){
  for(i in 1:n){
    ts1 <- arima.sim(list(order = c(1,0,0), ar = 0.5), n = 200, sd=0.4)
    ts2 <- arima.sim(list(order = c(1,0,0), ar = 0.5), n = 200, sd=0.5)
    corr_ts[i,1] <- cor(ts1,ts2)
  }
  return(corr_ts)
}

op <- corr_model(n,count,0.5,0.5,0.3,0.4)

plot(density(op))

qqnorm(op)

corr_model_1 <- function(n,count,ar1,ar2,std1,std2){
  for(i in 1:n){
    ts1 <- arima.sim(list(order = c(1,0,0), ar = 0.5), n = 200, sd=0.4)
    ts2 <- arima.sim(list(order = c(1,0,0), ar = 0.5), n = 200, sd=0.5)
    res1 <- arima(as.matrix(ts1),order = c(1,0,0))$residuals
    res2 <- arima(as.matrix(ts2),order = c(1,0,0))$residuals
    corr_ts[i,1] <- cor(res1,res2)
  }
  return(corr_ts)
}

op_1 <- corr_model_1(n,count,0.5,0.5,0.3,0.4)

plot(density(op_1),col='red')  ## correlation is more peaked hence confident
lines(density(op))  ## less peaked

qqnorm(op_1)

########################################

stat <- matrix(rep(0,n),n,1)

pval <- matrix(rep(0,n),n,1)

rv1 <- matrix(rep(0,n),n,count)

rv2 <- matrix(rep(0,n),n,count)

var_rv1 <- matrix(rep(0,n),n,1)
var_rv2 <- matrix(rep(0,n),n,1)

for(i in 1:n){
  for(j in 1:count){
    rv1[i,j] <- rnorm(1,5,3*runif(1))
    rv2[i,j] <- rnorm(1,5,3*runif(1))
  }
  var_rv1[i,1] <- var(rv1[i,])
  var_rv2[i,1] <- var(rv2[i,])
  stat[i,1] <- var_rv1[i,1]/var_rv2[i,1]
  pval[i,1] <- pf(stat[i,1],count-1,count-1)
}

hist(pval)  ## p vals are not uniformly distributed, heteroskesacity

sample_chisq <- rchisq(n,df=count-1,ncp = 9)
sample_chisq <- sample_chisq*mean(var_rv1)/mean(sample_chisq)
### scaled chisq to have the same mean as the hist of var_rv1

hist(var_rv1,col="peachpuff",prob=T)
lines(density(sample_chisq),col = "chocolate3",lwd=4)

qqnorm(var_rv1)

###############################################
#### diff distribution, else same

stat <- matrix(rep(0,n),n,1)

pval <- matrix(rep(0,n),n,1)

rv1 <- matrix(rep(0,n),n,count)

rv2 <- matrix(rep(0,n),n,count)

var_rv1 <- matrix(rep(0,n),n,1)
var_rv2 <- matrix(rep(0,n),n,1)

for(i in 1:n){
  rv1[i,] <- rnorm(count,5,2.88675)  # same mean and variance
  rv2[i,] <- runif(count,0,10) ## non normal issue
  var_rv1[i,1] <- var(rv1[i,])  
  var_rv2[i,1] <- var(rv2[i,])
  stat[i,1] <- var_rv1[i,1]/var_rv2[i,1]
  pval[i,1] <- pf(stat[i,1],count-1,count-1)
}

hist(pval)  ## p vals are slightly non uniform (deviation from normality issue)

sample_chisq <- rchisq(n,df=count-1,ncp = 9)
sample_chisq <- sample_chisq*mean(var_rv1)/mean(sample_chisq)
### scaled chisq to have the same mean as the hist of var_rv1

hist(var_rv1,col="peachpuff",prob=T)
lines(density(sample_chisq),col = "chocolate3",lwd=4)

