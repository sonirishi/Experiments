sigma = matrix(c(1,0,0,0,2,0,0,0,3),3,3)

solve(sigma)  ## inverse of diagonal

matrix = matrix(c(3,4,1,10,2,1,3,4,3),3,3)

norm(matrix,'2')
ortho = t(matrix(c(2/3,-2/3,1/3,1/3,2/3,2/3,2/3,1/3,-2/3),3,3))

abs(norm(matrix %*% ortho,'2') - norm(matrix,'2')) < 10^-10

abs(norm(matrix %*% ortho,'F') - norm(matrix,'F')) < 10^-10

#### Unit circle generation

circle = c()
angle = runif(10000,0,2*pi)
x = sin(angle)
y = cos(angle)

plot(x,y)  ## circle

transform = matrix(c(3,4,9,7),2,2)

append_mat = rbind(x,y)

final = transform %*% append_mat

x1 = final[1,]; y1 = final[2,]

plot(x1,y1)

new_norm = c()

for (i in 1:ncol(final)){
  new_norm = append(new_norm,norm(final[,i],'2'))
}

max(new_norm)  ## max singular

min(new_norm)  ## min singular

mean(new_norm)

svd_transform = svd(transform)

svd_transform$d  ## same as max and min

frob_norm = norm(transform,'F')  ## more than mean norm of new matrix

spectral_norm = norm(transform,'2')  ## same as first singular value

### Kernel Matrix

data = matrix(c(3,4,1,10,2,1,3,4,3,1,3,4,5,6,11),5,3)

gram_manual = matrix(rep(0,25),5,5)

for (i in 1:5){
  for (j in 1:5){
    gram_manual[i,j] = t(data[i,]) %*% data[j,]
  }
}

print(gram_manual)

print(data %*% t(data)) ### this is the gram matrix of kernel

svd(gram_manual)$d  ### all singular values are > 0 so PD

### poly kernel

data = matrix(c(3,4,1,10,2,3,4,3,1,3),5,2)

gram_manual = matrix(rep(0,25),5,5)

for (i in 1:5){
  for (j in 1:5){
    gram_manual[i,j] = (1+t(data[i,]) %*% data[j,])^2
  }
}

data_new = matrix(rep(0,5*6),5,6)

### Generate data in higher dimensions manually
## and then XXt to calculate the gram matrix

for (i in 1:5){
  data_new[i,1] = 1
  data_new[i,2] = data[i,1]^2
  data_new[i,3] = sqrt(2)*data[i,1]*data[i,2]
  data_new[i,4] = data[i,2]^2
  data_new[i,5] = sqrt(2)*data[i,1]
  data_new[i,6] = sqrt(2)*data[i,2]
}

gram_final = data_new %*% t(data_new)

norm(gram_manual-gram_final,'F')
