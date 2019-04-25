library(class)
library(ISLR)

a <- cut(1:10000, 10, labels = FALSE)[sample(1:10000)]
a
order(a)

library(class)

k_knn = function(k,data,cl,max_k){
  # k is k-fold, data is the x, cl is the y, max_k is the max number of folds you want to try.
  # the output will be k-fold, confusion matrix, and acc
  for (n in 1:max_k){
    # cut original data
    sub_group = cut(1:nrow(data),k,labels=FALSE)[sample(1:nrow(data))]
    # run knn for each fold
    pred = lapply(1:k,function(i,data,cl,n){
      omit = which(sub_group == i)
      pcl = knn(data[-omit,],data[omit,],cl[-omit],k=n)
    },data,cl,n)
    # get the table of pred acc
    wh = unlist(pred)
    show(n)
    show(table(wh,cl[order(sub_group)]))
    show(mean(wh == cl[order(sub_group)]))
  }
}
k_knn(10,iris[1:4],iris$Species,10)






vknn = function(v,data,cl,k){
  # 分割原始数据
  grps = cut(1:nrow(data),v,labels=FALSE)[sample(1:nrow(data))]
  # 对每份数据分别运行KNN函数
  pred = lapply(1:v,function(i,data,cl,k){
    omit = which(grps == i)
    pcl = knn(data[-omit,],data[omit,],cl[-omit],k=k)
  },data,cl,k)
  # 整合预测结果
  wh = unlist(pred)
  table(wh,cl[order(grps)])
}
vknn(5,iris[1:4],iris$Species,5)


View(iris)
pcl <- knn(iris[1:4], iris[1:4], iris$Species, k=5)
table(pcl, iris$Species)

iris[1:4]


a <- c(1,2,3)
b <- c(2,2,3)
table(a,b)



data <- iris
grps = cut(1:nrow(data),5,labels=FALSE)[sample(1:nrow(data))]

pred = lapply(1:5,function(i,data,iris$Species,k){
  omit = which(grps == i)
  pcl = knn(data[-omit,],data[omit,],cl[-omit],k=k)},data,iris$Species,)












