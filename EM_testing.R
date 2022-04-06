rm(list=ls(all=T))

df <- scan("https://www.stat.washington.edu/peter/book.data/set1",skip=1)
df <- df[df>0]
summary(df)
library(mixtools)

mix.model <- normalmixEM(df,k=2)

summary(mix.model)

loglik <- function(df){
  lik <- matrix(rep(0,2*length(df)),length(df),2)
  for(i in 1:2){
    lik[,i] <- 
      mix.model$lambda[i]*(dnorm(df,mix.model$mu[i],
                                mix.model$sigma[i]))
  }
  return(lik)
}

likelihood <- loglik(df)

final_lik <- likelihood[,1] + likelihood[,2]

sum(log(final_lik))

fit <- mixtools::boot.comp(df,max.comp = 3,B=20,mix.type='normalmix',
                           maxit=400,epsilon=0.01)

summary(fit)

generatedata <- function(lambda,mu,sigma){
  clustno <- sample(1:length(lambda),1,
                    replace=FALSE,prob=lambda)
  return(rnorm(1,mu[clustno],sigma[clustno]))
}

replicatedata <- function(n,lambda,mu,sigma){
  replicate(n,generatedata(lambda,mu,sigma))
}
  
#replicatedata(10,c(0.5,0.5),c(0,1),c(1,2))

normalfit <- function(param,data){
  -sum(log(dnorm(data,mean = param[1],sd = param[2])))
}

bootfit <- function(df,maxclus,bootiter){
  p = 0; clus = 1; bootlik <- list()
  pmatrix <- matrix(rep(0,maxclus),maxclus,1)
  model.lik <- matrix(rep(0,maxclus),maxclus,1)
  while(p <= 0.05 | clus <= maxclus){
    if(clus==1){
      mix.model <- optim(c(100,100),fn = normalfit, data=df)
      lambda = 1
      mu = mix.model$par[1]
      sigma = mix.model$par[2]
      mix.model.2 <- normalmixEM(df,k=clus+1) 
      ### model with more params should increase the likelihood
      ## compare the simpler model to complex one
      ## adding as we minimize in optim
      likelihood_ratio <- 2*(mix.model.2$loglik + mix.model$value)
    } else{
      mix.model <- normalmixEM(df,k=clus)
      mix.model.2 <- normalmixEM(df,k=clus+1) 
      lambda = mix.model$lambda
      mu = mix.model$mu
      sigma = mix.model$sigma
      likelihood_ratio <- 2*(mix.model.2$loglik - mix.model$loglik)
    }
    likelihood_boot <- matrix(rep(0,bootiter),bootiter,1)
    for(i in 1:bootiter){
      df_new <- replicatedata(length(df),lambda,mu,sigma)
      mix.model.boot <- normalmixEM(df_new,k=clus+1)
      if (clus == 1){
        mix.model.orig <- optim(c(100,100),fn = normalfit, data=df_new)
        lik <- -mix.model.orig$value
      } else{
        mix.model.orig <- normalmixEM(df_new,k=clus) 
        lik <- mix.model.orig$loglik
      }
      if(2*(mix.model.boot$loglik - lik) > 0){
        likelihood_boot[i] <- 
          2*(mix.model.boot$loglik - lik)
      } else{
        i = i-1
      }
    }
    bootlik = list(bootlik,likelihood_boot)
    p <- sum(likelihood_boot > likelihood_ratio)/bootiter
    pmatrix[clus] <- p
    model.lik[clus] <- likelihood_ratio
    print(clus)
    clus = clus+1
  }
  return(list(model.lik,pmatrix,bootlik))
}

output <- bootfit(df,3,10)

