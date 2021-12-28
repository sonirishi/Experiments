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



