##extreme value simulation
n <- 100000

iter <- 1000
count <- c()
for(i in 1:iter){
  count <- append(count,sum(rnorm(n) >= 4.5)) ## we had to average out runs
  ## or rather create a very large sample indirectly.
}

print(mean(count)/n)
print(1-pnorm(4.5))
print((sum(rnorm(n) >= 4.5)/n))
### example of importance sampling using shifted distribution

generate_random <- function(n){
  rvs <- rnorm(n,4.5,1)
  return((rvs >= 4.5)*(dnorm(rvs)/dnorm(rvs,mean=4.5)))
}

mean(generate_random(n))

hist(x=pnorm(rnorm(10000)))
 
exp_rvs <- rexp(10000,rate=2)     

exp_rvs2 <- -0.5*log(1-runif(10000))
