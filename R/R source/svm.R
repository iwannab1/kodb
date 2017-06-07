library(caret)

#R CMD INSTALL kernlab_0.9-24.zip
x = iris[,1:4]
y = iris[,5]

folds = createMultiFolds(y, k = 10, times = 5)

#Linear SVM
L_model = train(x,y,method="svmLinear",tuneLength=5,
                trControl=trainControl(method='repeatedCV',index=folds,classProbs=TRUE))

#Poly SVM
P_model = train(x,y,method="svmPoly",tuneLength=5,
                trControl=trainControl(method='repeatedCV',index=folds,classProbs=TRUE))

#Fit a Radial SVM
R_model = train(x,y,method="svmRadial",tuneLength=5,
                trControl=trainControl(method='repeatedCV',index=folds,classProbs=TRUE))

#Compare 3 models
resamps = resamples(list(Linear = L_model, Poly = P_model, Radial = R_model))
summary(resamps)
bwplot(resamps, metric = "Accuracy")
densityplot(resamps, metric = "Accuracy", auto.key=TRUE)

pred = predict(L_model,x,type='prob')

library(caTools)
colAUC(pred,y,plot=TRUE)