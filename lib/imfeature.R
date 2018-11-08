feature <- function(LR_dir, HR_dir, n_points=900){
  ### https://dahtah.github.io/imager/imager.html
  ### Construct process features for training images (LR/HR pairs)
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + number of points sampled from each LR image
  ### Output: an .RData file contains processed features and responses for the images
  
  
  
  ### load libraries
  library("EBImage")
  n_files <- length(list.files(LR_dir))
  #n_files <- 10
  ### store feature and responses
  featMat <- array(NA, c(n_files* n_points, 8, 3))
  labMat <- array(NA, c(n_files * n_points, 4, 3))

  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    ### step 1. sample n_points from imgLR
    d1 = dim(imgLR)[1]
    d2 = dim(imgLR)[2]
    ##pts_ind <- sample(1:(d1*d2), n_points,replace = FALSE)
    ##select_row=(pts_ind-1)%% d1 +1
    ##select_col=(pts_ind-1)%/% d1 +1
    select_row=sample(2:(d1-1), 30)
    select_col=sample(2:(d2-1), 30)
    
    ### step 1.1. create new imgLR with padding
    ### step 2. for each sampled point in imgLR,
    ### step 2.1. save (the neighbor 8 pixels - central pixel) in featMat
    ###           tips: padding zeros for boundary points
    featMat[((i-1)*n_points+1):(i*n_points),1,1:3]=array(as.vector(imageData(imgLR[select_row,select_col,1:3])-imageData(imgLR[select_row-1,select_col-1,1:3])),c(900,1,3))
    featMat[((i-1)*n_points+1):(i*n_points),2,1:3]=array(as.vector(imageData(imgLR[select_row,select_col,1:3])-imageData(imgLR[select_row-1,select_col,1:3])),c(900,1,3))
    featMat[((i-1)*n_points+1):(i*n_points),3,1:3]=array(as.vector(imageData(imgLR[select_row,select_col,1:3])-imageData(imgLR[select_row-1,select_col+1,1:3])),c(900,1,3))
    featMat[((i-1)*n_points+1):(i*n_points),4,1:3]=array(as.vector(imageData(imgLR[select_row,select_col,1:3])-imageData(imgLR[select_row,select_col-1,1:3])),c(900,1,3))
    featMat[((i-1)*n_points+1):(i*n_points),5,1:3]=array(as.vector(imageData(imgLR[select_row,select_col,1:3])-imageData(imgLR[select_row,select_col+1,1:3])),c(900,1,3))
    featMat[((i-1)*n_points+1):(i*n_points),6,1:3]=array(as.vector(imageData(imgLR[select_row,select_col,1:3])-imageData(imgLR[select_row+1,select_col-1,1:3])),c(900,1,3))
    featMat[((i-1)*n_points+1):(i*n_points),7,1:3]=array(as.vector(imageData(imgLR[select_row,select_col,1:3])-imageData(imgLR[select_row+1,select_col,1:3])),c(900,1,3))
    featMat[((i-1)*n_points+1):(i*n_points),8,1:3]=array(as.vector(imageData(imgLR[select_row,select_col,1:3])-imageData(imgLR[select_row+1,select_col+1,1:3])),c(900,1,3))

    labMat[((i-1)*n_points+1):(i*n_points),1,1:3]=array(as.vector(imageData(imgHR[select_row*2,select_col*2,1:3])),c(900,1,3))
    labMat[((i-1)*n_points+1):(i*n_points),2,1:3]=array(as.vector(imageData(imgHR[select_row*2,select_col*2+1,1:3])),c(900,1,3))
    labMat[((i-1)*n_points+1):(i*n_points),3,1:3]=array(as.vector(imageData(imgHR[select_row*2+1,select_col*2,1:3])),c(900,1,3))
    labMat[((i-1)*n_points+1):(i*n_points),4,1:3]=array(as.vector(imageData(imgHR[select_row*2+1,select_col*2+1,1:3])),c(900,1,3))
  }
  ### step 2.2. save the corresponding 4 sub-pixels of imgHR in labMat
  ### step 3. repeat above for three channels
    
      return(list(feature = featMat, label = labMat))
}


#feature(train_LR_dir, train_HR_dir)




