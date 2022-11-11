rm(list=ls(all=T))
ts <- c()
for(i in seq(0,1000,runif(1))){
  print(i)
  val <- runif(1)
  if( val <= 0.25){
    ts[i] = cos(i)
  } else if (val <= 0.5) {
    ts[i] = -cos(i)
  } else if (val <= 0.75){
    ts[i] = -sin(i)
  } else{
    ts[i] = sin(i)
  }
}

plot(ts,type='l')

library(tseries)

adf.test(ts)

### this is a WSS process however the joint distribution isnt same