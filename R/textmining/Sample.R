library(caret)
library(kernlab)
data(spam)

inTrain = createDataPartition(y=spam$type, p=0.75, list=F)

training = spam[inTrain,]
testing = spam[-inTrain,]

hist(training$capitalAve, main="", xlab="ave. capital run length")
mean(training$capitalAve)
sd(training$capitalAve)


## Standardizing
trainCapAve = training$capitalAve
trainCapAveS = (trainCapAve - mean(trainCapAve))/sd(trainCapAve)
mean(trainCapAveS)
sd(trainCapAveS)

testCapAve = testing$capitalAve
testCapAveS = (testCapAve - mean(testCapAve))/sd(testCapAve)
mean(testCapAveS)
sd(testCapAveS)


## Standardizing(Caret)
preObj = preProcess(training[,-58], method=c("center","scale"))
trainCapAveS = predict(preObj, training[,-58])$capitalAve
sd(trainCapAveS)

## Box-cox(정규화)
preObj = preProcess(training[,-58], method=c("BoxCox"))
trainCapAveS = predict(preObj, training[,-58])$capitalAve
par(mfrow=c(1,2))
hist(trainCapAveS)
qqnorm(trainCapAveS)
