rm(list=ls(all=T))

df <- scan("https://www.stat.washington.edu/peter/book.data/set1",skip=1)
df <- df[df>0]

library(mixtools)
#data(faithful)
#df <- faithful$waiting

loglik <- function(i,p,rate,data){
  return(p[i]*(dexp(data, rate = rate[i])))
}

expectation <- function(data,p,rate){
  loglik.val <- sapply(1:length(p),loglik,p=p,rate=rate,data=data)
  ## no need of log likelihood, simple ratio is required
  loglik.comp <- loglik.val/apply(loglik.val,1,sum)
  return(apply(loglik.comp,2,mean))
}

fitparam <- function(param,data,lambdaval){
  lik <- matrix(rep(0,length(data)*length(lambdaval)),length(data),length(lambdaval))
  for(i in 1:length(lambdaval)){
    lik[,i] <- lambdaval[i]*dexp(data,rate = rate[i])
  }
  lik <- -sum(log(apply(lik, 1, sum)))
  #print(lik)
  return(lik)
}

maximization <- function(data,lambda,rate){
  model <- optim(rate,fn = fitparam, data=df, lambdaval=lambda,
                 method='CG')
  return(model)
}

EMnorm <- function(data,clus,epsilon,p,mu,sd){
  loglik = -99999999
  thresh = 999999
  iter <- 0
  while(thresh > epsilon){
    iter = iter + 1
    print("Iteration Started")
    lastloglik <- loglik
    p <- expectation(data,p,rate)
    print(p)
    #print(mu);print(sd)
    model <- maximization(data,p,rate)
    loglik <- -model$value
    #print(loglik)
    print(model$par)
    rate <- model$par
    thresh <- loglik-lastloglik
  }
  return(list(p,rate,iter,loglik))
}

#mix.model <- normalmixEM(df,k=3,epsilon = 0.000001)
clus=3
p = runif(clus)
p <- p/sum(p)
rate <- runif(clus,min = 1/(mean(df)*10),max = 1/(2*mean(df)))

#output <- EMnorm(df,2,0.001,mix.model$lambda,mix.model$mu,mix.model$sigma)
output <- EMnorm(df,clus,0.000001,p,rate)

