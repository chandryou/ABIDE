library(oro.nifti)
library(keras)
library(dplyr)
dataFolder<-"/Users/chan/data/ABIDE"
workFolder<-"/Users/chan/OneDrive/Study/ASD_DL/Result"
ImageList<-list.files(dataFolder)
#ImageList[90]

#####################################
##identify the dimension of the data
#####################################
# image.str<-data.frame()
# for (fMR in ImageList){
#     single.img<-oro.nifti::readNIfTI(file.path(dataFolder,fMR),reorient=FALSE)
#     d=data.frame(name=fMR, width= dim(single.img)[1], height = dim(single.img)[2], 
#                vertical = dim(single.img)[3], time = dim(single.img)[4])
#     image.str<-rbind(image.str,d)
# }
# write.csv(image.str,file.path(workFolder,"img_dim.csv"))

image.str<-read.csv(file.path(workFolder,"img_dim.csv"))

hist(image.str$time)
min(image.str$time)#min dimension of time =  116


i<-1
fMR<-ImageList[i]
single.img<-oro.nifti::readNIfTI(file.path(dataFolder,fMR),reorient=FALSE)

#slice (maximum time dimesion of 116)
slice.img<-single.img[,,,1:min(image.str$time)]

dimensions<-dplyr::distinct(data.frame(cbind( image.str$width,
                                               image.str$height,
                                               image.str$vertical)))
if( nrow(input_shape) == 1) {
    input_shape<-as.integer(dimensions)
}else  {
    writeLines("Error: input shape is heterogeneous")
}
