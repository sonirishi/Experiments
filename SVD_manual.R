rm(list=ls(all=T))

a = matrix(c(1,3,2,4),2,2)

b = t(a) %*% a

for (i in 1:50){
  if (i == 1){
    tempb = b
    b = b %*% b
  } else{
    b = b %*% tempb
  }
}

r = as.matrix(rnorm(2,0,1))
Ar = a %*% r

gs_ortho = function(e1,e2){
  u1 = e1/norm(e1,'2')
  print(u1)
  u2 = e2 - dot(e2,u1)*u1
  u2 = u2/norm(u2,'2')
  print(u2)
  return(list(u1,u2))
}

veclist = gs_ortho(r,Ar)  
r = veclist[1][[1]]
Ar = veclist[2][[1]]

r = a %*% r; Ar = a %*% Ar

for (i in 1:1000){
  veclist = gs_ortho(r,Ar)
  r = veclist[1][[1]]
  Ar = veclist[2][[1]]
  print(dot(r,Ar))
}

