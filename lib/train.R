#########################################################
### Train a classification model with training features ###
#########################################################

### Author: Group 2
### Project 3

train <- function(feat_train, label_train, params=NULL, run_gbm = F, 
                  run_xgb = F,run_lr=F, run_rf = F){
  
  ### Train a Gradient Boosting Model (GBM) using processed features from training images
  
  ### Input: 
  ###  -  features from LR images 
  ###  -  responses from HR images
  ### Output: a list for trained models
  
  ### creat model list
  modelList <- list()
  
  ### Train with gradient boosting model
  if(is.null(params)){
    depth <- 3
  } else {
    depth <- params$depth
  }
  
  ### the dimension of response arrat is * x 4 x 3, which requires 12 classifiers
  ### this part can be parallelized
  for (i in 1:12){
    ## calculate column and channel
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- feat_train[, , c2]
    labMat <- label_train[, c1, c2]
    
    ### gbm model
    #gbm <- NULL
    if (run_gbm){
      if(!require("gbm")){
        install.packages("gbm")
      }
      library("gbm")
      fit_gbm <-gbm.fit(x=featMat, y=labMat,
                        n.trees=200,
                        distribution="gaussian",
                        interaction.depth=depth, 
                        bag.fraction = 0.5,
                        verbose=FALSE)
      best_iter <- gbm.perf(fit_gbm,method = "OOB",plot.it = FALSE)
      modelList[[i]] <- list(fit=fit_gbm, iter=best_iter)
    }
    
    ## xgboost model
    xgboost <- NULL
    if(run_xgb){
      if( !require("xgboost" )){
        install.packages("xgboost")
      }
      library("xgboost")
      
      dtrain <- xgb.DMatrix(data=as.matrix(featMat),label=labMat)
      xgboost_fit <- xgboost(data = dtrain, objective = "reg:linear",
                             metrics ="rmse",
                             eta = 0.6, max_depth = 8,
                             nthread= 2, nfold = 5, nrounds = 10)
      modelList[[i]] <- list(fit= xgboost_fit) 
    }
    
    ## SVM
    svm_list <- NULL
    if(run_lr){
      library("e1071")
      dat_train_complete <- cbind(featMat,labMat)
      fitControl = trainControl(method = 'cv', number = 2) 
      svmGrid = expand.grid(C = c(0.5,1,2)) 
      #start_time_svm = Sys.time() # Model Start Time 
      svm_list.fit <- svm(featMat, labMat, type = "eps-regression" ,kernel= "radial", gamma = 0.2 ) 
      #end_time_svm = Sys.time() # Model End time 
      #svm_time = end_time_svm - start_time_svm #Total Running Time 
      #return(list(fit = svm.fit, time = svm_time)) 
      modelList[[i]] <- list(fit= svm_list.fit)
    }
      
    ## random forest
    rf <- NULL
    if(run_rf){
      if( !require("randomForest" )){
        install.packages("randomForest")
      }
      
      library(randomForest)
      library(caret)
      library(e1071)
      
      rf.fit <- randomForest(as.factor(labMat) ~ .,
                             data = featMat, mtry = params[1],
                             importance=TRUE, 
                             ntree = params[2])
      modelList[[i]] <- list(fit= rf.fit)
    }
  }
  return(modelList)
}
