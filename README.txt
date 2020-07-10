data - this is the raw data for the analysis of this HR churn project.

HR-Churn.R - a). this is the analysis of the hr module from data directory where I perform an EDA on the
                 distribution of the salary by their departments.
                 
             b). I perform a chi-square test to determine if salary and department are dependant variables.
             
             c). I perform an in-sample error using a logistic regression to predict with accuracy the level of                   churn in the organization and the variables that are significant for the outcome.
             
             d). With a confusion Matrix, I am able to see the sensitivity and specificity of my model with data                  seen.
             
             e). Now I perform an out of sample error with data that the algorithm is not familiar with and I                    achieve that by splitting the data into train and test.
             
             f). I run my algorithm on the train set data and make my prediction on top on the unseen test data                  to determine the accuracy and robustness of my model.
             
             g). I evaluate my model using a confusion Matrix, I check my parameters of the model.
             
             h). I make a visual of the model using a ROC curve, Receiver Operating Characteristic, and an AUC,                   Area Under Curve, to visualise the performance on a plot.

figs - These are the visual representations of my model.