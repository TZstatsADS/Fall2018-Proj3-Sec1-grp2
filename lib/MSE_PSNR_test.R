

## This file is used to test the MSE of predicted super-resolution image and the ground truth image

HR_dir <- "../data/test_set/HR_1/"
HR_dir_test <- "../data/test_set/HR_depth11/"

n_files <- length(list.files(HR_dir))
MSE <- c(NA)
PSNR <- c(NA)

# Loop over all the images and store MSE in a vector
for (i in 1:n_files) {
  img_HR <- readImage(paste0(HR_dir,  "img", "_", sprintf("%04d",i), ".jpg"))
  img_test <- readImage(paste0(HR_dir_test,  "img", "_", sprintf("%04d",i), ".jpg"))
  
  HR <- as.numeric(img_HR)
  pred <- as.numeric(img_test)
  MSE[i] <- sum((pred - HR)^2) / (3*dim(img_HR)[1]*dim(img_HR)[2])
  PSNR[i] <- 20*log10(1) - 10*log10(MSE[i])
}


mean(MSE)
sd(MSE)
plot(MSE)

mean(PSNR)
sd(PSNR)
plot(PSNR, xlab = "Img Index", ylab = "gbm PSNR", main = "PSNR By GBM")
#plot(MSE, xlab = "Img Index", ylab = "xgb MSE", main = "Test Error By Xgboost")




    