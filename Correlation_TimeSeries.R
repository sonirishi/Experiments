library(forecast)
library(TSA)

cor_ts <-  list()
cor_res <- list()

diff_cor <- list()
cor_prewhiten <- list()
diff_cor2 <- list()

for(i in 1:1000){
  ts1 <- arima.sim(list(order = c(1,0,0), ar = 0.5), n = 500, sd=0.4)
  ts2 <- arima.sim(list(order = c(1,0,0), ar = 0.5), n = 500, sd=0.5)
  
  cor_ts <- append(cor_ts,cor(ts1,ts2))
  model1 <- auto.arima(ts1)
  model2 <- auto.arima(ts2)
  
  cor_res <- append(cor_res,cor(model1$residuals,model2$residuals))
  diff_cor <- append(diff_cor,cor(ts1,ts2)-
                       cor(model1$residuals,model2$residuals))
  whiten <- prewhiten(ts1,ts2)
  lags <- length(whiten$ccf$acf)
  cor_prewhiten <- append(cor_prewhiten,whiten$ccf$acf[(lags+1)/2])
  
  diff_cor2 <- append(diff_cor2,cor(ts1,ts2)-whiten$ccf$acf[(lags+1)/2])
}

hist(unlist(diff_cor))
hist(unlist(diff_cor2))

#plot(density(unlist(cor_ts)),col='red')
#lines(density(unlist(cor_res),col='black'))

###################################
######### Test prewhitening more###
###################################
###

#   Essentially we need prewhitening to cross correlate 
#   two autocorrelated time series else results are useless
###
library(forecast)
library(TSA)

corr_orig <- list()
corr_whiten <- list()

for(i in 1:1000){
  ts1 <- arima.sim(list(order = c(1,1,0), ar = 0.7), n = 200, sd=1)
  y <- ts.intersect(ts1, lag(ts1,-3), lag(ts1,-4))
  ts2 <- 15+0.8*y[,2]+1.5*y[,3]
  a <- ccf(ts1,ts2)
  corr_orig <- append(corr_orig,sum(abs(a$acf) > 0.2))
  whiten <- prewhiten(ts1,ts2)
  corr_whiten <- append(corr_whiten,sum(abs(whiten$ccf$acf) > 0.2))
}

hist(unlist(corr_orig))
hist(unlist(corr_whiten))

sum(unlist(corr_whiten) == 2)/length(unlist(corr_whiten))
## 95% confidence correct correlation capture

sum(unlist(corr_orig) == 2)/length(unlist(corr_orig))
## always more correlation capture

###########################################
rm(list=ls(all=T))
corr_orig <- list()
corr_whiten <- list()

for(i in 1:1000){
  ts1 <- arima.sim(list(order = c(1,0,0), ar = 0.7), n = 200, sd=1)
  y <- ts.intersect(ts1, lag(ts1,-3), lag(ts1,-4))
  ts2 <- 15+0.8*y[,2]+1.5*y[,3]
  a <- ccf(ts1,ts2)
  corr_orig <- append(corr_orig,sum(abs(a$acf) > 0.2))
  whiten <- prewhiten(ts1,ts2)
  corr_whiten <- append(corr_whiten,sum(abs(whiten$ccf$acf) > 0.2))
}

hist(unlist(corr_orig))
hist(unlist(corr_whiten))

sum(unlist(corr_whiten) == 2)/length(unlist(corr_whiten))
## 96% confidence correct correlation capture

sum(unlist(corr_orig) == 2)/length(unlist(corr_orig))
## always more correlation captured than actual

pacf(ts2)  ## 2 lags
pacf(ts1)  ## 1 lag
