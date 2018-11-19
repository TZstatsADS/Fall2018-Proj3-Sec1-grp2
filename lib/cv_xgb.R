
cv_xgb <- function(feat_train, label_train){
  for (i in 1:12){
    ## calculate column and channel
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- feat_train[, , c2]
    labMat <- label_train[, c1, c2]
  }
  err_cv <- list()
  library(xgboost)
  dtrain <- xgb.DMatrix(data=as.matrix(featMat),label=labMat)
  eta_try <- c(0.5, 0.6, 0.7, 0.8)
  depth_try <- c(6, 7, 8)
  test_err <- array(NA,c(12,1))
  test_sd <- array(NA,c(12,1))
  train_err <- array(NA,c(12,1))
  train_sd <- array(NA,c(12,1))
  for (j in 1:4) {
    for (i in 1:3){
      err_cv[[3*j-3+i]] <- xgb.cv(data = dtrain, objective = "reg:linear",
                                  metrics ="rmse",
                                  eta = eta_try[j], max_depth = depth_try[i],
                                  nthread= 2, nfold = 5, nrounds = 10)
      
      test_err[3*j-3+i,] <- err_cv[[3*j-3+i]]$evaluation_log$test_rmse_mean[10]
      test_sd[3*j-3+i,] <- err_cv[[3*j-3+i]]$evaluation_log$test_rmse_std[10]
      train_err[3*j-3+i,] <- err_cv[[3*j-3+i]]$evaluation_log$train_rmse_mean[10]
      train_sd[3*j-3+i,] <- err_cv[[3*j-3+i]]$evaluation_log$train_rmse_std[10]
    }			
  }
  a <- cbind(train_err,train_sd,test_err,test_sd)
  colnames(a) <- c("cv_train_err", "train_sd", "test_err", "test_sd")
  return(a)
}


