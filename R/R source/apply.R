m <- matrix(data=cbind(rnorm(10, 0), rnorm(10, 2), rnorm(10, 5)), nrow=10, ncol=3)
m

rmean1 = c()
cmean1 = c()

## for loop
for (i in 1:10){
  rmean1[i] = mean(m[i,])
}

rmean1

for (i in 1:3){
  cmean1[i] = mean(m[,i])
}

cmean1


## apply
rmean2 = apply(m, 1, mean);rmean2
cmean2 = apply(m, 2, mean);cmean2

#sapply, lapply : traverse
mean3 = sapply(m, mean);mean3 # vector
mean4 = lapply(m, mean);mean4 # list

mean3[1]
mean4[1]
mean4[[1]]

#user defined function
apply(m, 1, function(x) x*-1)
apply(m, 2, function(x) x*-1)



rmean3 = sapply(1:10, function(x) mean(m[x,]));rmean3
cmean3 = sapply(1:3, function(x) mean(m[,x]));cmean3
cmean4 = sapply(1:3, function(x, y) mean(y[,x]), y=m); cmean4
