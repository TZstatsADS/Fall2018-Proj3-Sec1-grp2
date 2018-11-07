#In this part, on getting the featmat, we applied some matrix manipulation techniques instead of simply using the for loop. 
#we first define particular direction, let’s say upper left and then we tried to find a neighbor in that direction for every point on the whole matrix and subtracted the value from the corresponding center point.

# Extract eight neighbors for each pixcel for each RGB
eight_nei <- function(color.i, img){
  row <- dim(img)[1] 
  col <- dim(img)[2] 
  mat_base <- array(img,c(row, col, 3))
  
  mat_1 <- abind(array(rep(0, row-1), c(row-1,1,3)), array(img[-row,-col,], c(row-1, col-1, 3)), along=2)
  mat_1 <- abind(array(rep(0, col), c(1,col,3)), array(mat_1, c(row-1, col, 3)), along=1)
  mat_1_channel <- mat_1[,,color.i] - mat_base[,,color.i]
  
  mat_2 <- abind(array(rep(0, col), c(1,col,3)), array(img[-row,,], c(row-1, col, 3)), along=1)
  mat_2_channel <- mat_2[,,color.i] - mat_base[,,color.i]
  
  mat_3 <- abind(array(rep(0, col), c(1,col-1,3)), array(img[-row,-1,], c(row-1, col-1, 3)), along=1)
  mat_3 <- abind(array(mat_3, c(row, col-1, 3)), array(rep(0, row), c(row,1,3)), along=2)
  mat_3_channel <- mat_3[,,color.i] - mat_base[,,color.i]
  
  mat_4 <- abind(array(rep(0, row), c(row,1,3)), array(img[,-col,], c(row, col-1, 3)), along=2)
  mat_4_channel <- mat_4[,,color.i] - mat_base[,,color.i]
  mat_4_channel <- mat_4[,,color.i] - mat_base[,,color.i]
  
  mat_6 <- abind(array(img[,-1,], c(row, col-1, 3)),array(rep(0, row), c(row,1,3)), along=2)
  mat_6_channel <- mat_6[,,color.i] - mat_base[,,color.i]
  
  mat_7 <- abind(array(rep(0, row-1), c(row-1,1,3)), array(img[-1,-col,], c(row-1, col-1, 3)), along=2)
  mat_7 <- abind(array(mat_7, c(row-1, col, 3)), array(rep(0, col), c(1,col,3)), along=1)
  mat_7_channel <- mat_7[,,color.i] - mat_base[,,color.i]
  
  mat_8 <- abind(array(img[-1,,], c(row-1, col, 3)), array(rep(0, col), c(1,col,3)), along=1)
  mat_8_channel <- mat_8[,,color.i] - mat_base[,,color.i]
  
  mat_9 <- abind(array(img[-1,-1,], c(row-1, col-1, 3)), array(rep(0, row-1), c(row-1,1,3)), along=2)
  mat_9 <- abind(array(mat_9, c(row-1, col, 3)), array(rep(0, col), c(1,col,3)), along=1)
  mat_9_channel <- mat_9[,,color.i] - mat_base[,,color.i]
  
  mat_channel <- abind(mat_1_channel, mat_2_channel,mat_3_channel, 
                       mat_4_channel,mat_6_channel, mat_7_channel, 
                       mat_8_channel,mat_9_channel, along = 0)
  return(aperm(mat_channel,c(2,3,1)))
}

