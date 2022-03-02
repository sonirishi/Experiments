library(np)

rm(list=ls(all=T))

n = 1000

x = rnorm(n,0,9)

y = 3 - 2*x + rnorm(n,0,sapply(x,function(x){1+0.5*x^2}))

wls <- function(maxiter){
  weight = rep(1,1000)
  df = matrix(rep(0,2*maxiter),maxiter,2)
  for (i in 1:maxiter){
    ols = lm(y~x,weights = 1/weight)
    residual = ols$residuals
    kreg = np::npreg(residual^2 ~ x)
    weight = fitted(kreg)
    df[i,1] = ols$coefficients[1]
    df[i,2] = ols$coefficients[2]
  }
  return(df)
}

coef_df <- wls(100)

ols = lm(y~x)

plot(y=ols$residuals,ols$fitted.values)
lines(loess(ols$residuals~ols$fitted.values,degree=1)$fitted)

logwls <- function(maxiter){
  weight = rep(1,1000)
  df = matrix(rep(0,2*maxiter),maxiter,2)
  for (i in 1:maxiter){
    ols = lm(y~x,weights = 1/weight)
    residual = ols$residuals
    kreg = np::npreg(log(residual^2) ~ x)
    weight = exp(fitted(kreg))
    df[i,1] = ols$coefficients[1]
    df[i,2] = ols$coefficients[2]
  }
  return(df)
}

logcoef_df <- logwls(10)

local_reg = loess(y~x,degree=1)
k_reg = np::npreg(y~x)

## no comments on heteroskedascility from here
plot(y=local_reg$residuals,x=local_reg$fitted)
points(y=ols$residuals,x=ols$fitted.values,col='red')
points(y=y-fitted(k_reg),x=fitted(k_reg),col='blue')

print(IQR(local_reg$residuals)/median(local_reg$fitted))
print(IQR(ols$residuals)/median(ols$fitted.values))
print(IQR(y-fitted(k_reg))/median(y-fitted(k_reg)))
