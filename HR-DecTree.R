hr<-read.csv("data/hr_comma_sep.csv")
str(hr)
hr$left=as.factor(hr$left)
str(hr)
unlist(lapply(hr,class))

## Step 1: splitting the data into train and test

library(caTools)
set.seed(1234)
split<-sample.split(hr,SplitRatio = 0.75)
split

train<-subset(hr,split=="TRUE")
test<-subset(hr,split=="FALSE")
str(train)
str(test)

## Step 2: Training model with logistics regression using glm function
library("rpart") ##recursive partioning
library("rpart.plot")
DecTreeModel<-rpart(left~.,data=train,method = "class")
DecTreeModel

rpart.plot(DecTreeModel)

summary(DecTreeModel)
printcp(DecTreeModel)
plotcp(DecTreeModel)



## Step 3: Predicting test based on trained model
test$left_Pred<-predict(DecTreeModel,newdata = test,type = "class")

## Step 4: Evaluating model accuracy using confusion matrix
table(test$left,test$left_Pred)
library(caret)
confusionMatrix(table(test$left,test$left_Pred))
#cm(table(test$left,test$left_Pred))

##Tree pruning
#find the value of CP for which the cross validation error is minimum
min(DecTreeModel$cptable[,"xerror"])
which.min(DecTreeModel$cptable[,"xerror"])
cpmin<-DecTreeModel$cptable[8,"CP"]
cpmin

##prune the tree by setting the cp parameter = cpmin
DecTreeModelPruned=prune(DecTreeModel,cp=cpmin)
rpart.plot(DecTreeModelPruned)
#printcp(DecTreeModelPruned)
#plotcp(DecTreeModelPruned)

