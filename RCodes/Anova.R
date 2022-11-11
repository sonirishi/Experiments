set.seed(1232)
pop = data.frame(group=factor(c("A","B","C")),
                 mean=c(1,2,5),
                 sd=c(1,3,4))
d = do.call(rbind, rep(list(pop),13))
d$x = rnorm(nrow(d), d$mean, d$sd)

stripchart(x ~ group, data=d)

mod.aov = aov(x ~ group, data=d)
summary(mod.aov)

TukeyHSD(mod.aov)

oneway.test(x ~ group, data=d, var.equal=FALSE)

library(nlme)
mod.gls = gls(x ~ group, data=d,
                weights=varIdent(form= ~ 1 | group))
anova(mod.gls)
summary(mod.gls)

#######################################

set.seed(2020)
n = 20;  k = 4
x1 = rbinom(n, 12, .3) -6
x2 = rbinom(n, 12, .35)-6
x3 = rbinom(n, 12, .4) -6
x4 = rbinom(n, 12, .4) -6
x = c(x1, x2, x3, x4)
g = as.factor(rep(1:k, each=n))

var(x1); var(x2); var(x3); var(x4)
[1] 2.042105
[1] 4.642105
[1] 3.628947
[1] 2.515789

boxplot(x ~ g, col="skyblue2", pch=20, horizontal=T)

oneway.test(x ~ g)
t.test(x1, x3)
t.test(x3,x4)$p.val

######################
rm(list=ls(all=T))
set.seed(1)                        # this makes the simulation exactly reproducible
b0 = 10                            # this is the true value of the intercept
b1 = .5                            # this is the true value of the slope
n  = 10                            # this is the number of data I have at each point in X
x  = rep(c(0, 2, 4), each=n)       # these are the x data
wt = 1 / rep(c(1, 4, 16), each=n)  # these are a-priori correct weights
uw.p.vector = vector(length=10000) # these 2 vectors will hold the results of
w.p.vector  = vector(length=10000) #   the simulation
## weight inverse of variance
for(i in 1:10000){                        # I run this simulation 10k times
  y.x0 = rnorm(n, mean=b0,          sd=1) # here I am generating simulated data
  y.x2 = rnorm(n, mean=(b0 + 2*b1), sd=2) #  the SD at each point is different &
  y.x4 = rnorm(n, mean=(b0 + 4*b1), sd=4) #  the variances are 1, 4, & 16
  y    = c(y.x0, y.x2, y.x4)              # I put the data into a single vector
  unweighted.model = lm(y~x)              # I fit an identical model w/ the same data
  weighted.model   = lm(y~x, weights=wt)  #   w/o & then w/ the weights
  uw.p.vector[i]   = summary(unweighted.model)$coefficients[2,4]  # the p-values
  w.p.vector[i]    = summary(weighted.model)$coefficients[2,4]
}
mean(uw.p.vector<.05)  # using the unweighted regression, the power was ~39%
# [1] 0.3927
mean(w.p.vector<.05)   # w/ the weighted regression, the power was ~47%
# [1] 0.4732

#####################

set.seed(5678)
B = matrix(0,1000,2)
for(i in 1:1000)
{
  x = rnorm(4000) 
  y = 1 + 2*x + rt(4000,2.01)
  g = lm(y~x)
  B[i,] = coef(g)
}
qqnorm(B[,2])
qqline(B[,2])
