
LR_dir = '../data/train_set/LR/'
HR_dir = '../data/train_set/HR/'
train_LR_dir <- paste(LR_dir, sep="")
train_HR_dir <- paste(HR_dir, sep="")

feature <- function(LR_dir, HR_dir, n_points=1000){
  ### https://dahtah.github.io/imager/imager.html
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
  
  count = 0
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    ### step 1. sample n_points from imgLR
    d1 = dim(imgLR)[1]
    d2 = dim(imgLR)[2]
    
    ### step 1.1. create new imgLR with padding
    #imgLR_pad1 = cbind(rep(0,d1+2),rbind(rep(0,d2),imgLR[,,1],rep(0,d2)),rep(0,d1+2))
    #imgLR_pad2 = cbind(rep(0,d1+2),rbind(rep(0,d2),imgLR[,,2],rep(0,d2)),rep(0,d1+2))
    #imgLR_pad3 = cbind(rep(0,d1+2),rbind(rep(0,d2),imgLR[,,3],rep(0,d2)),rep(0,d1+2))
    #imgLR_pad = array(c(imgLR_pad1,imgLR_pad2,imgLR_pad3), dim = c(d1+2, d2+2, 3))
    
    points_ind_pool = matrix(1:(d1*d2), nrow = d1, ncol = d2, byrow = T)
    points_ind_sample <- sample(points_ind_pool, n_points)
    this_ind = points_ind_sample
    this_col = ifelse(this_ind %% d2 == 0, d2, this_ind %% d2)
    this_row = ceiling(this_ind / d2)
    
    ### step 2. for each sampled point in imgLR,
    
   
      for (chann in 1:3){
        ### step 2.1. save (the neighbor 8 pixels - central pixel) in featMat
        ###           tips: padding zeros for boundary points
        center = imgLR[this_row,this_col,chann]
        imgLR_pad=cbind(0,imgLR[,,chann],0)
        imgLR_pad=rbind(0,imgLR_pad,0)
        featMat[(i-1)*n_points+1:n_points,1,chann]=imgLR_pad[cbind(this_row,this_col)] - center[1:n_points]
        featMat[(i-1)*n_points+1:n_points,2,chann]=imgLR_pad[cbind(this_row,this_col+1)]- center[1:n_points]
        featMat[(i-1)*n_points+1:n_points,3,chann]=imgLR_pad[cbind(this_row,this_col+2)]- center[1:n_points]
        featMat[(i-1)*n_points+1:n_points,4,chann]=imgLR_pad[cbind(this_row+1,this_col+2)]- center[1:n_points]
        featMat[(i-1)*n_points+1:n_points,5,chann]=imgLR_pad[cbind(this_row+2,this_col+2)]- center[1:n_points]
        featMat[(i-1)*n_points+1:n_points,6,chann]=imgLR_pad[cbind(this_row+2,this_col+1)]- center[1:n_points]
        featMat[(i-1)*n_points+1:n_points,7,chann]=imgLR_pad[cbind(this_row+2,this_col)]- center[1:n_points]
        featMat[(i-1)*n_points+1:n_points,8,chann]=imgLR_pad[cbind(this_row+1,this_col)]- center[1:n_points]
        ### step 2.2. save the corresponding 4 sub-pixels of imgHR in labMat
        HR=imgHR[,,chann]
        labMat[(i-1)*n_points+1:n_points,1,chann] = HR[cbind(this_row*2-1,this_col*2-1)]
        labMat[(i-1)*n_points+1:n_points,2,chann] = HR[cbind(this_row*2-1,this_col*2)]
        labMat[(i-1)*n_points+1:n_points,3,chann] = HR[cbind(this_row*2,this_col*2-1)]
        labMat[(i-1)*n_points+1:n_points,4,chann] = HR[cbind(this_row*2,this_col*2)]
      }
    
  }
  
 


  ### step 3. repeat above for three channels
  

  
  return(list(feature = featMat, label = labMat))
}

feature(train_LR_dir, train_HR_dir)


