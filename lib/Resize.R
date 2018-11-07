setwd("~/Documents/GitHub/Fall2018-Proj3-Sec1-sec1proj3_grp2") 

HR_dir <- "/Users/shilinli/Documents/GitHub/Fall2018-Proj3-Sec1-sec1proj3_grp2/data/test_set/HR/"
LR_dir <- "/Users/shilinli/Documents/GitHub/Fall2018-Proj3-Sec1-sec1proj3_grp2/data/test_set/LR/"

n_files <- length(list.files(HR_dir))

for (i in 1:n_files){
  imgHR <- readImage(paste0(HR_dir, "img", "_", sprintf("%04d",i), ".jpg"))
  pathLR <- paste0(LR_dir,  "img", "_", sprintf("%04d", i), ".jpg")
  imgLR <- resize(imgHR,dim(imgHR)[1]/2)
  writeImage(imgLR,pathLR)
}
