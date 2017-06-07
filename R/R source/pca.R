data(iris)
summary(iris);head(iris)

#log transform
log.x = log(iris[, 1:4])
y = iris[, 5]

args(prcomp)
x.pca = prcomp(log.x, center = TRUE, scale. = TRUE) 
summary(x.pca)
plot(x.pca, type="line")
x.pca
biplot(x.pca, cex = c(0.7, 0.8))

library(caret)
library(kernlab)
data(spam)

sampling = createDataPartition(y=spam$type, p=0.75, list=F)
trainData = spam[sampling,]
testData = spam[-sampling,]
dim(trainData);dim(testData)

pre = preProcess(log10(trainData[,-58]+1), method="pca", pcaComp=2)
pred = predict(pre, log10(trainData[,-58]+1))
model = train(trainData$type~., method="glm", data=pred)

testPred = predict(pre, log10(testData[,-58]+1))
confusionMatrix(testData$type, predict(model, testPred))
