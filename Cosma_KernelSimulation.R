library(np)

data("oecdpanel")

popinv2 = npudens(~exp(popgro)+exp(inv),data=oecdpanel)

n.train = length(popinv2$dens)

ndim = popinv2$ndim
n=2000
points = sample(1:n.train,n,replace = T)

for (i in 1:ndim){
  coordinates = popinv2$eval[points,i] ## actual data exponentiated
  z[,i] = rnorm(n,coordinates,popinv2$bw[i]) ## kernel bandwidth
  ## using bw as std
}