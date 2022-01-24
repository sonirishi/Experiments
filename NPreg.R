rm(list=ls(all=TRUE))
library(np)

X = runif(1000,-4,4)

Y = exp(7*X)/(1+exp(7*X)) + rnorm(1000,0,0.01)

df = data.frame(cbind(Y,X)); colnames(df) = c('Y','X')

reg1 = npreg(Y~X,data=df,tol=0.01,ftol=0.01)

pred_compare = function(x,y,model){
  numerator = 0
  prediction = predict(model,new_data=data.frame(x))
  final = merge(prediction,prediction)
  xfin = merge(x,x)
  numerator = sum((final$x-final$y)*sign(xfin$x-xfin$y))
  denominator = sum(sign(xfin$x-xfin$y)*(xfin$x-xfin$y))
  return(numerator/denominator)
}

pred_compare(X,Y,reg1)

#####################
  
X1 = runif(1000,0,0.5)

Y1 = exp(7*X1)/(1+exp(7*X1)) + rnorm(1000,0,0.01)

df1 = data.frame(cbind(Y1,X1)); colnames(df1) = c('Y1','X1')

reg2 = npreg(Y1~X1,data=df1,tol=0.01,ftol=0.01)

pred_compare(X1,Y1,reg2)

###################

X2 = runif(1000,-0.25,0.25)

Y2 = exp(7*X2)/(1+exp(7*X2)) + rnorm(1000,0,0.01)

df2 = data.frame(cbind(Y2,X2)); colnames(df2) = c('Y2','X2')

reg3 = npreg(Y2~X2,data=df2,tol=0.01,ftol=0.01)

pred_compare(X2,Y2,reg3)

##################

X3 = runif(1000,0,8)

Y3 = exp(7*X3)/(1+exp(7*X3)) + rnorm(1000,0,0.01)

df3 = data.frame(cbind(Y3,X3)); colnames(df3) = c('Y3','X3')

reg3 = npreg(Y3~X3,data=df3,tol=0.01,ftol=0.01)

pred_compare(X3,Y3,reg3)
