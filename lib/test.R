######################################################
### Fit the regression model with testing data ###
######################################################

### Author: Group 2
### Project 3

test <- function(modelList, dat_test, params = NULL,
                 test_gbm = F, test_xgb = F,test_lr = F,test_rf = F){
  
  ### Fit the classfication model with testing data
  
  ### Input: 
  ###  - the fitted classification model list using training data
  ###  - processed features from testing images 
  ### Output: training model specification
  
  ### load libraries
  library("gbm")
  library("xgboost")
  
  predArr <- array(NA, c(dim(dat_test)[1], 4, 3))
  
  for (i in 1:12){
    fit_train <- modelList[[i]]
    ### calculate column and channel
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- dat_test[, , c2]
    ### make predictions
    if(test_gbm){
      predArr[, c1, c2] <- predict(fit_train$fit, newdata=featMat, 
                                   n.trees=fit_train$iter, type="response")
    } 
    if(test_xgb) {
      predArr[, c1, c2] <- predict(fit_train$fit, newdata = featMat)
    }
    
    if(test_lr){
      predArr[, c1, c2] <- predict(fit_train, newdata = dat_test)
    }
    
    if(test_rf){
      predArr[, c1, c2] <- predict(fit_train, newdata = dat_test)
    }
  }
  return(as.numeric(predArr))
}
