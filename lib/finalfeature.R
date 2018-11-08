LR_dir = '../data/train_set/LR/'
HR_dir = '../data/train_set/HR/'
train_LR_dir <- paste(LR_dir, sep="")
train_HR_dir <- paste(HR_dir, sep="")
n_points=1000

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
  featMat <- array(NA, c(n_files* n_points, 8, 3))
  labMat <- array(NA, c(n_files * n_points, 4, 3))
  
  count = 0
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    ### step 1. sample n_points from imgLR
    d1 = dim(imgLR)[1]
    d2 = dim(imgLR)[2]
    pts_ind <- sample(1:(d1*d2), n_points,replace = FALSE)
    select_row=(pts_ind-1)%% d1 +1
    select_col=(pts_ind-1)%/% d1 +1
    
    ### step 1.1. create new imgLR with padding
    ### step 2. for each sampled point in imgLR,
    ### step 2.1. save (the neighbor 8 pixels - central pixel) in featMat
    ###           tips: padding zeros for boundary points
    
    for (chann in 1:3){
      imgLR_pad11 = unname(c(cbind(rep(0,d1),rbind(rep(0,d2-1),imgLR[1:(d1-1),1:(d2-1),chann])) ))
      imgLR_pad12 = unname(c(rbind(rep(0,d2),imgLR[1:(d1-1),1:(d2),chann])))
      imgLR_pad13 = unname(c(cbind(rbind(rep(0,d2-1),imgLR[1:(d1-1),2:(d2),chann]), rep(0,d1))))
      imgLR_pad21 = unname(c(cbind(rep(0,d1),imgLR[1:(d1),1:(d2-1),chann])))
      imgLR_pad23 = unname(c(cbind(imgLR[1:(d1),2:(d2),chann],rep(0,d1))))
      imgLR_pad31 = unname(c(cbind(rep(0,d1),rbind(imgLR[2:(d1),1:(d2-1),chann], rep(0,d2-1)))))
      imgLR_pad32 = unname(c(rbind(imgLR[2:(d1),1:(d2),chann],rep(0,d2))))
      imgLR_pad33 = unname(c(cbind(rbind(imgLR[2:(d1),2:(d2),chann],rep(0,d2-1)), rep(0,d1))))
      imgLR_pad = cbind(imgLR_pad11[pts_ind],imgLR_pad12[pts_ind],imgLR_pad13[pts_ind],
                        imgLR_pad21[pts_ind],imgLR_pad23[pts_ind],imgLR_pad31[pts_ind],
                        imgLR_pad32[pts_ind],imgLR_pad33[pts_ind])
    
      featMat[((i-1)*n_points+1):(i*n_points),,chann] = imgLR_pad
      # print("####\n")
    
    
  ### step 2.2. save the corresponding 4 sub-pixels of imgHR in labMat
      channelHR=imgHR[,,chann]
      
      labMat[(i-1)*n_points+1:n_points,1,chann]=channelHR[cbind(select_row*2-1,select_col*2-1)]
      labMat[(i-1)*n_points+1:n_points,2,chann]=channelHR[cbind(select_row*2,select_col*2-1)]
      labMat[(i-1)*n_points+1:n_points,3,chann]=channelHR[cbind(select_row*2-1,select_col*2)]
      labMat[(i-1)*n_points+1:n_points,4,chann]=channelHR[cbind(select_row*2,select_col*2)]
     
  ### step 3. repeat above for three channels
  }  
}
      return(list(feature = featMat, label = labMat))

}


#feature(train_LR_dir, train_HR_dir)




