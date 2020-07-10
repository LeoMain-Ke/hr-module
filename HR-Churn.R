hr<-read.csv("data/hr_comma_sep.csv",stringsAsFactors = F,na.strings = c("","NA",""))
str(hr)
colnames(hr)

#data type conversion
hr$department=as.factor(hr$department)
hr$salary=as.factor(hr$salary)
hr$left=as.factor(hr$left)
str(hr)

#Exporatory Data Analysis
unlist(lapply(hr,class))
ftable<-table(hr$department,hr$salary)
ftable

mosaicplot(ftable,main="Distribution of Departments by their Salary",color=TRUE)
library(ggplot2)
ggsave("figs/mosaicplot.png")

chisq.test(ftable)

# insample distribution
logit_model<-glm(left~satisfaction_level+last_evaluation+number_project+
                 Work_accident+promotion_last_5years+average_montly_hours+
                   time_spend_company,data = hr, family = "binomial")
summary(logit_model)

#predict churn
hr$left_pred<-predict(logit_model,data=hr,type="response")

#changing the probabilities into class (0 or 1)
hr$left_pred<-ifelse(hr$left_pred>0.5,1,0)
hr$left_pred=as.factor(hr$left_pred)
str(hr)

#confusion matrix
table(hr$left,hr$left_pred)
misClassError<-mean(hr$left_pred!=hr$left)
print(paste('Accuracy=',1-misClassError))


#Splitting the data in train and test data
#install.packages('caTools')
library(caTools)
set.seed(123)
split<-sample.split(hr,SplitRatio=0.75)
split

train<-subset(hr,split=="TRUE")
test<-subset(hr,split=="FALSE")
str(train)
str(test)

#Train model using glm function

logit_model_tr<-glm(left~satisfaction_level+last_evaluation+number_project+
                 Work_accident+promotion_last_5years+average_montly_hours+
                   time_spend_company,data = train, family = "binomial")
logit_model_tr

#Predicting test data based on trained model

predicted.result<-predict(logit_model_tr,test,type = "response")
predicted.result
predicted.result<-ifelse(predicted.result>0.5,1,0)
predicted.result

#Evaluating model accuracy using confusion matrix
table(test$left,predicted.result)
misClassError<-mean(predicted.result!=test$left)
print(paste('Accuracy=',1-misClassError))

#model evaluation using a confusion matrix
library(caret)
confusionMatrix(table(test$left,predicted.result))

#ROC-AUC CURVE
library(ROCR)
ROCRpred<-prediction(predicted.result,test$left)
ROCRperf<-performance(ROCRpred,measure="tpr",x.measure="fpr")
plot(ROCRperf)
plot(ROCRperf,colorize=TRUE)
plot(ROCRperf,colorize=TRUE,print.cutoffs.at=seq(0.1,by=0.1))
plot(ROCRperf,colorize=TRUE,print.cutoffs.at=seq(0.1,by=0.1),main = "ROC CURVE")
abline(a=0,b=1)
#ggsave("figs/ROC-CURVEplot.png")

auc<-performance(ROCRpred,measure="auc")
auc<-auc@y.values[[1]]
auc
auc<-round(auc,4)
legend(.5,.4,auc,title="AUC",cex=1)
#ggsave("figs/AUCplot.png")
