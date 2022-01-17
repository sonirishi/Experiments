rm(list=ls(all=True))

df = matrix(c(rep(0,1000*101)),nrow=1000,ncol=101)

pval_fstat = matrix(c(rep(0,100)),nrow=100)

for(j in 1:100){
  for(i in 1:101){
    df[,i] = rnorm(1000,0,1)
  }
  y = df[,1]
  x = df[,2:101]
  model = lm(y~x)
  fstat = summary(model)$fstatistic
  p = pf(fstat[1], fstat[2], fstat[3], lower.tail = FALSE)
  pval_fstat[j] = p
}

plot(density(pval_fstat))

pval_fstat_step = matrix(c(rep(0,100)),nrow=100)

for(j in 1:100){
  for(i in 1:101){
    df[,i] = rnorm(1000,0,1)
  }
  y = df[,1]
  x = df[,2:101]
  model = lm(y~x)
  model_sparse = step(model)
  fstat = summary(model_sparse)$fstatistic
  p = tryCatch(pf(fstat[1], fstat[2], fstat[3], lower.tail = FALSE),
               error = function(e) 1)
  pval_fstat_step[j] = p
}

plot(density(pval_fstat_step))


pval_fstat_step2 = matrix(c(rep(0,100)),nrow=100)

for(i in 1:101){
  df[,i] = rnorm(1000,0,1)
}
y = df[,1]
x = df[,2:101]

for(j in 1:100){
  model = lm(y~x)
  model_sparse = step(model)
  fstat = summary(model_sparse)$fstatistic
  p = tryCatch(pf(fstat[1], fstat[2], fstat[3], lower.tail = FALSE),
               error = function(e) 1)
  pval_fstat_step2[j] = p
}

plot(density(pval_fstat_step2))
