n1=60;n2=90;
tdf=5;
delta=1;al=0.05;nsim=10000
res = replicate(nsim,{y1=rt(n1,tdf);y2=rt(n2,tdf)+delta;wilcox.test(y1,y2)$p.value<=al})
mean(res) # res will be logical ("TRUE" = reject); mean is rej rate

res = replicate(nsim,{y1=rt(n1,tdf);y2=rt(n2,tdf)+delta;
wilcox.test(y1,y2,mu=-1)$p.value<=al})
mean(res) ### Test works

res = replicate(nsim,{y1=rt(n1,tdf);y2=rt(n2,tdf)+delta;
t.test(y1,y2)$p.value<=al})
mean(res)  ## t test also has enough rejection power

res = replicate(nsim,{y1=rweibull(n1,shape=2);y2=rweibull(n2,shape=2)+delta;
wilcox.test(y1,y2,mu=-1)$p.value<=al})
mean(res) ### Test works

res = replicate(nsim,{y1=rweibull(n1,shape=2);y2=rweibull(n2,shape=2)+delta;
t.test(y1,y2,mu=-1)$p.value<=al})
mean(res)  ## t test also has enough rejection power

#### Calculate manually ##
y1=rweibull(n1,shape=2);y2=rweibull(n2,shape=2)+delta

t.test(y1,y2)

(mean(y1) - mean(y2))/sqrt(var(y1)/n1+var(y2)/n2)

list_mean_y1 = c()
list_mean_y2 = c()
list_mean_diff = c()
list_tstat = c()

for(i in 1:nsim){
  y1=rweibull(n1,shape=2);y2=rweibull(n2,shape=2)+delta
  list_mean_y1 = c(list_mean_y1,mean(y1))
  list_mean_y2 = c(list_mean_y2,mean(y2))
  list_mean_diff = c(list_mean_diff,mean(y1)-mean(y2))
  list_tstat =  c(list_tstat,(mean(y1) - mean(y2))/sqrt(var(y1)/n1+var(y2)/n2))
}

plot(density(list_mean_y1))
             
plot(density(list_mean_y2))

plot(density(list_mean_diff))

par(mfrow = c(1, 2))
plot(density(list_tstat))  ## looks like t distributed actually long tail
#axis(2, col.ticks="blue", col.axis="blue")
plot(density(list_mean_diff),col='red')
#axis(4, col.ticks="red", col.axis="red")

list_mean_y1 = c()
list_mean_y2 = c()
list_mean_diff = c()
list_tstat = c()

for(i in 1:nsim){
  y1=rt(n1,df=5);y2=rt(n2,df=5)+delta
  list_mean_y1 = append(list_mean_y1,mean(y1))
  list_mean_y2 = append(list_mean_y2,mean(y2))
  list_mean_diff = append(list_mean_diff,mean(y1)-mean(y2))
  list_tstat =  append(list_tstat,(mean(y1) - mean(y2))/sqrt(var(y1)/n1+var(y2)/n2))
}

plot(density(list_mean_y1))

plot(density(list_mean_y2))

plot(density(list_mean_diff))

plot(density(list_tstat))

############### Time series data ##
list_mean_y1 = c()
list_mean_y2 = c()
list_mean_diff = c()
list_tstat = c()
pval_welch = c()
pval_mwu = c()
pval_ttest = c()

generate_AR_data_ndist <- function(coeff,start,n,std){
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

for(i in 1:nsim){
  y1 = generate_AR_data_ndist(0.6,1.1,100,2)[41:100]
  ##leaving first few for cleanliness
  y2 = generate_AR_data_ndist(0.6,1.1,150,8)[61:150]
  list_mean_y1 = append(list_mean_y1,mean(y1))
  list_mean_y2 = append(list_mean_y2,mean(y2))
  list_mean_diff = append(list_mean_diff,mean(y1)-mean(y2))
  list_tstat =  append(list_tstat,(mean(y1) - mean(y2))/sqrt(var(y1)/n1+var(y2)/n2))
  pval_ttest = append(pval_ttest,t.test(y1,y2,var.equal = T)$p.value)
  pval_welch = append(pval_welch,t.test(y1,y2,var.equal = F)$p.value)
  pval_mwu = append(pval_mwu,wilcox.test(y1,y2,paired = F)$p.value)
}

plot(density(list_mean_y1))

plot(density(list_mean_y2))

plot(density(list_mean_diff))

mean(pval_ttest<0.05)

mean(pval_welch<0.05)

mean(pval_mwu<0.05)

hist(pval_mwu)
hist(pval_welch)
hist(pval_ttest)

###############

list_mean_y1 = c()
list_mean_y2 = c()
list_mean_diff = c()
list_tstat = c()
pval_welch = c()
pval_mwu = c()
pval_ttest = c()


for(i in 1:nsim){
  y1 = rt(n1,df=2.1)
  ##leaving first few for cleanliness
  y2 = rt(n2,df=12)
  list_mean_y1 = append(list_mean_y1,mean(y1))
  list_mean_y2 = append(list_mean_y2,mean(y2))
  list_mean_diff = append(list_mean_diff,mean(y1)-mean(y2))
  list_tstat =  append(list_tstat,(mean(y1) - mean(y2))/sqrt(var(y1)/n1+var(y2)/n2))
  pval_ttest = append(pval_ttest,t.test(y1,y2,var.equal = T)$p.value)
  pval_welch = append(pval_welch,t.test(y1,y2,var.equal = F)$p.value)
  pval_mwu = append(pval_mwu,wilcox.test(y1,y2,paired = F)$p.value)
}

plot(density(list_mean_y1))

plot(density(list_mean_y2))

plot(density(list_mean_diff))

plot(density(list_tstat))

mean(pval_ttest<0.05)

mean(pval_welch<0.05)

mean(pval_mwu<0.05)

hist(pval_mwu)

############# compare with non autocorrelated ##
list_mean_y1 = c()
list_mean_y2 = c()
list_mean_diff = c()
list_tstat = c()
pval_welch = c()
pval_mwu = c()
pval_ttest = c()


for(i in 1:nsim){
  y1 = rnorm(n1,0,0.4)
  ##leaving first few points of the simulation for cleanliness
  y1 = rnorm(n1,0,1)
  list_mean_y1 = append(list_mean_y1,mean(y1))
  list_mean_y2 = append(list_mean_y2,mean(y2))
  list_mean_diff = append(list_mean_diff,mean(y1)-mean(y2))
  list_tstat =  append(list_tstat,(mean(y1) - mean(y2))/sqrt(var(y1)/n1+var(y2)/n2))
  pval_ttest = append(pval_ttest,t.test(y1,y2,var.equal = T)$p.value)
  pval_welch = append(pval_welch,t.test(y1,y2,var.equal = F)$p.value)
  pval_mwu = append(pval_mwu,wilcox.test(y1,y2,paired = F)$p.value)
}

plot(density(list_mean_y1))

plot(density(list_mean_y2))

plot(density(list_mean_diff))

plot(density(list_tstat))

mean(pval_ttest<0.05)  ## 99% power

mean(pval_welch<0.05) ## 98% power shouldn't this be better than t test
## may be in case of less variance diff it doesnt matter.

mean(pval_mwu<0.05) ## % 98% power 

hist(pval_mwu)
hist(pval_ttest)
hist(pval_welch)

####################

############### Time series data ##
list_mean_y1 = c()
list_mean_y2 = c()
list_mean_diff = c()
list_tstat = c()
pval_welch = c()
pval_mwu = c()
pval_ttest = c()

for(i in 1:nsim){
  y1 = arima.sim(list(order = c(1,0,0), ar = 0.5), n = 200, sd=0.4)
  ##leaving first few for cleanliness
  y2 = arima.sim(list(order = c(1,0,0), ar = 0.5), n = 200, sd=1)
  list_mean_y1 = append(list_mean_y1,mean(y1))
  list_mean_y2 = append(list_mean_y2,mean(y2))
  list_mean_diff = append(list_mean_diff,mean(y1)-mean(y2))
  list_tstat =  append(list_tstat,(mean(y1) - mean(y2))/sqrt(var(y1)/n1+var(y2)/n2))
  pval_ttest = append(pval_ttest,t.test(y1,y2,var.equal = T)$p.value)
  pval_welch = append(pval_welch,t.test(y1,y2,var.equal = F)$p.value)
  pval_mwu = append(pval_mwu,wilcox.test(y1,y2,paired = F)$p.value)
}

plot(density(list_mean_y1))

plot(density(list_mean_y2))

plot(density(list_mean_diff))

mean(pval_ttest<0.05)   ## series is mean 0 hence both test have only 75% power
## 0.2596
mean(pval_welch<0.05)
## 0.2587
mean(pval_mwu<0.05)
## 0.2641

hist(pval_mwu)
hist(pval_welch)
hist(pval_ttest)
