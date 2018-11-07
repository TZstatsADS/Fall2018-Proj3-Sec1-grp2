
#HR_dir <- "/Users/shilinli/Documents/GitHub/Fall2018-Proj3-Sec1-grp2/data/train_set/HR/"
#HR_dir_test <- "/Users/shilinli/Documents/GitHub/Fall2018-Proj3-Sec1-grp2/data/train_set/SR-I/"

HR_dir <- "../data/test_set/HR_1/"
HR_dir_test <- "../data/test_set/HR_xgb/"

n_files <- length(list.files(HR_dir))
MSE <- c(NA)


for (i in 1:n_files) {
  img_HR <- readImage(paste0(HR_dir,  "img", "_", sprintf("%04d",i), ".jpg"))
  img_test <- readImage(paste0(HR_dir_test,  "img", "_", sprintf("%04d",i), ".jpg"))
  
  HR <- as.numeric(img_HR)
  pred <- as.numeric(img_test)
  MSE[i] <- sum((pred - HR)^2) / (3*dim(img_HR)[1]*dim(img_HR)[2])
}


mean(MSE)
sd(MSE)
#plot(MSE)
plot(MSE, xlab = "Img Index", ylab = "xgb MSE", main = "Test Error By Xgboost")

#img_HR <- readImage("/Users/shilinli/Documents/GitHub/Fall2018-Proj3-Sec1-grp2/data/test_set/HR/img_0014.jpg")
#img_test <- readImage("/Users/shilinli/Documents/GitHub/Fall2018-Proj3-Sec1-grp2/data/test_set/HR_xgb/img_0014.jpg")
#HR <- as.numeric(img_HR)
#pred <- as.numeric(img_test)
#sum((pred - HR)^2) / (3*dim(img_HR)[1]*dim(img_HR)[2])


    