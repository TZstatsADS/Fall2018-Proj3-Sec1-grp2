#############################################################
### Construct features and responses for training images###
#############################################################

### Authors: Group2
### Project 3

feature <- function(LR_dir, HR_dir, n_points=1000){
  
  ### Construct process features for training images (LR/HR pairs)
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + number of points sampled from each LR image
  ### Output: an .RData file contains processed features and responses for the images
  
  ### load libraries
  library("EBImage")
  n_files <- length(list.files(LR_dir))
  
  ### store feature and responses
  featMat <- array(NA, c(n_files * n_points, 8, 3))
  labMat <- array(NA, c(n_files * n_points, 4, 3))
  feat_ini <- array(NA,dim = c(1,8,3))
  lab_ini <- array(NA,dim = c(1,4,3))
  
  #feat_ini <- array(NA)
  #lab_ini <- array(NA)
  
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    ### step 1. sample n_points from imgLR
    
    feature_mat <- array(NA, dim = c(dim(imgLR)[1]*dim(imgLR)[2],8,3))
    lab_mat <- array(NA, dim = c(dim(imgLR)[1]*dim(imgLR)[2],4,3))
    
    feature_mat[,,1] <- array(as.numeric(eight_nei(color.i=1,imgLR)),dim = c(dim(imgLR)[1]*dim(imgLR)[2],8))
    feature_mat[,,2] <- array(as.numeric(eight_nei(color.i=2,imgLR)),dim = c(dim(imgLR)[1]*dim(imgLR)[2],8))
    feature_mat[,,3] <- array(as.numeric(eight_nei(color.i=3,imgLR)),dim = c(dim(imgLR)[1]*dim(imgLR)[2],8))
    
    lab_mat[,1,] <- imgHR[seq(1,dim(imgHR)[1],2),seq(1,dim(imgHR)[2],2),]
    lab_mat[,2,] <- imgHR[seq(2,dim(imgHR)[1],2),seq(1,dim(imgHR)[2],2),]
    lab_mat[,3,] <- imgHR[seq(1,dim(imgHR)[1],2),seq(2,dim(imgHR)[2],2),]
    lab_mat[,4,] <- imgHR[seq(2,dim(imgHR)[1],2),seq(2,dim(imgHR)[2],2),]
    
    lab_mat[,,1] <- lab_mat[c(1:nrow(lab_mat)),,1] - as.numeric(imgLR[,,1])
    lab_mat[,,2] <- lab_mat[c(1:nrow(lab_mat)),,2] - as.numeric(imgLR[,,2])
    lab_mat[,,3] <- lab_mat[c(1:nrow(lab_mat)),,3] - as.numeric(imgLR[,,3])
    
    row_sample <- sample(1:(dim(imgLR)[1]*dim(imgLR)[2]),n_points,replace = F)
    # feature_mat <- feature_mat[row_sample,,]
    # lab_mat <- lab_mat[row_sample,,]
    feat_ini <- abind(feat_ini,feature_mat[row_sample,,],along = 1)
    lab_ini <- abind(lab_ini,lab_mat[row_sample,,],along = 1)
    
    #feat_ini[(length(feat_ini)+1):(n_points*8*3*i+1)] <- as.numeric(feature_mat)
    #lab_ini[(length(lab_ini)+1):(n_points*4*3*i+1)] <- as.numeric(lab_mat)
    
    #lab_mat <- array(as.numeric(imgHR),dim = c(dim(imgLR)[1]*dim(imgLR)[2],4,3))
    
    ### step 2. for each sampled point in imgLR,
    
    ### step 2.1. save (the neighbor 8 pixels - central pixel) in featMat
    
    
    
    ###           tips: padding zeros for boundary points
    
    ### step 2.2. save the corresponding 4 sub-pixels of imgHR in labMat
    
    
    
    ### step 3. repeat above for three channels
    
  }
  featMat <- feat_ini[-1,,]
  labMat <- lab_ini[-1,,]
  
  #featMat <- array(feat_ini[-1],dim = c(n_files*n_points,8,3))
  #labMat <- array(lab_ini[-1],dim = c(n_files*n_points,4,3))
  
  #featMat <- feature_mat
  return(list(feature = featMat, label = labMat))
}

