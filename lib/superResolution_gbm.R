########################
### Super-resolution ###
########################

### Author: Chengliang Tang
### Project 3

superResolution_gbm <- function(LR_dir, HR_dir, modelList){
  
  ### Construct high-resolution images from low-resolution images with trained predictor
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + a list for predictors
  
  ### load libraries
  library("EBImage")
  n_files <- length(list.files(LR_dir))
  
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img", "_", sprintf("%04d",i), ".jpg"))
    #imgLR <- readImage("img_0004.jpg")
    
    pathHR <- paste0(HR_dir,  "img", "_", sprintf("%04d", i), ".jpg")
    featMat <- array(NA, c(dim(imgLR)[1] * dim(imgLR)[2], 8, 3))
    
    ### step 1. for each pixel and each channel in imgLR:
    ###           save (the neighbor 8 pixels - central pixel) in featMat
    
    featMat[,,1] <- array(as.numeric(eight_nei(color.i=1,imgLR)),dim = c(dim(imgLR)[1]*dim(imgLR)[2],8))
    featMat[,,2] <- array(as.numeric(eight_nei(color.i=2,imgLR)),dim = c(dim(imgLR)[1]*dim(imgLR)[2],8))
    featMat[,,3] <- array(as.numeric(eight_nei(color.i=3,imgLR)),dim = c(dim(imgLR)[1]*dim(imgLR)[2],8))
    
    
    ###           tips: padding zeros for boundary points
    
    ### step 2. apply the modelList over featMat
    #####predMat <- test(modelList, featMat)
    pred <- test(modelList = modelList, dat_test = featMat, params = NULL,
                 test_gbm = T, test_xgb = F,test_lr = F,test_rf = F)
    
    predMat <- array(pred, dim = c(dim(imgLR)[1]*dim(imgLR)[2],4,3))
    
    ### Add center point back to prediction
    predMat[,,1] <- predMat[c(1:nrow(predMat)),,1] + as.numeric(imgLR[,,1])
    predMat[,,2] <- predMat[c(1:nrow(predMat)),,2] + as.numeric(imgLR[,,2])
    predMat[,,3] <- predMat[c(1:nrow(predMat)),,3] + as.numeric(imgLR[,,3])
    
    
    #predM
    ### step 3. recover high-resolution from predMat and save in HR_dir
    imgMat <- array(NA, c(dim(imgLR)[1]*2,dim(imgLR)[2]*2, 3))
    imgMat[seq(1,dim(imgLR)[1]*2,2),seq(1,dim(imgLR)[2]*2,2),] <- predMat[,1,]
    imgMat[seq(2,dim(imgLR)[1]*2,2),seq(1,dim(imgLR)[2]*2,2),] <- predMat[,2,]
    imgMat[seq(1,dim(imgLR)[1]*2,2),seq(2,dim(imgLR)[2]*2,2),] <- predMat[,3,]
    imgMat[seq(2,dim(imgLR)[1]*2,2),seq(2,dim(imgLR)[2]*2,2),] <- predMat[,4,]
    
    img_test <- Image(imgMat,colormode = Color)
    writeImage(img_test,pathHR)
  }
}
#writeImage(img_test,"test.jpg")
#display(img_test)


