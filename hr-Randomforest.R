hr<-read.csv("data/hr_comma_sep.csv")
hr$left=as.factor(hr$left)

#Step 1:Split data in train and test data
library(caTools)
set.seed(123) 

split <- sample.split(hr, SplitRatio = 0.75)
split

training_set = subset(hr, split == TRUE)
test_set = subset(hr, split == FALSE)

#Step 2: Fitting Random Forest Classifier into the Training set
# install.packages('randomForest')
library(randomForest)
classifier <- randomForest(x = training_set[-7],
                           y = training_set$left,
                           ntree = 500)
bestmtry<-tuneRF(training_set,training_set$left,stepFactor = 1.2,improve = 0.01,trace = T,plot = T)

#Step 3: Predicting test set data by train set model
y_pred = predict(classifier, newdata = test_set[-7])
#y_pred


#Step 4: Model Evaluation by  checking accuracy using a confusion matrix
cm <- table(test_set$left,y_pred)
misClassError<-mean(test_set$left!=y_pred)
print(paste('Accuracy=',1-misClassError))

library(caret)
confusionMatrix(cm)
plot(classifier)
importance(classifier)
varImpPlot(classifier)

