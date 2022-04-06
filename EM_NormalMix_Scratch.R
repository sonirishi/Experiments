rm(list=ls(all=T))

df <- scan("https://www.stat.washington.edu/peter/book.data/set1",skip=1)
df <- df[df>0]

library(mixtools)
#data(faithful)
#df <- faithful$waiting

loglik <- function(i,p,mu,sd,data){
  return(p[i]*(dnorm(data, mean = mu[i],sd = sd[i])))
}

expectation <- function(data,p,mu,sd){
  loglik.val <- sapply(1:length(p),loglik,p=p,mu=mu,sd=sd,data=data)
  loglik.fin <- log(apply(loglik.val,2,sum))
  return(loglik.fin/sum(loglik.fin))
}

fitparam <- function(param,data,lambdaval){
  lik <- 0
  for(i in 1:length(lambdaval)){
    lik <- lik + lambdaval[i]*dnorm(data,
                              mean = param[i],sd = param[i+length(lambdaval)])
  }
  lik <- -sum(log(lik))
  return(lik)
}

maximization <- function(data,lambda,mu,sd){
  model <- optim(c(mu,sd),fn = fitparam, data=df, lambdaval=lambda)
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
    p <- expectation(data,p,mu,sd)
    print(p)
    #print(mu);print(sd)
    model <- maximization(data,p,mu,sd)
    loglik <- -model$value
    #print(loglik)
    #print(model$par)
    mu <- model$par[1:clus]
    a = clus+1; b = 2*clus
    sd <- model$par[a:b]
    #print(mu);print(sd)
    thresh <- loglik-lastloglik
  }
  return(list(p,mu,sd,iter,loglik))
}

mix.model <- normalmixEM(df,k=2,epsilon = 0.000001)
clus=2
p = runif(clus)
p <- p/sum(p)
mu <- c(rnorm(1,mean(df),sd(df)),rnorm(1,mean(df),sd(df)),
        rnorm(1,mean(df),sd(df)))
sd <- runif(clus,min = sd(df)/20,max = 2*sd(df))

#output <- EMnorm(df,2,0.001,mix.model$lambda,mix.model$mu,mix.model$sigma)
output <- EMnorm(df,clus,0.000001,p,mu,sd)

