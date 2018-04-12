library(oro.nifti)
dataFolder<-"/Users/chan/data/ABIDE"
workFolder<-"/Users/chan/OneDrive/Study/ASD_DL/Result"
ImageList<-list.files(dataFolder)
#ImageList[90]

image.str<-data.frame()

for (fMR in ImageList){
    single.img<-oro.nifti::readNIfTI(file.path(dataFolder,fMR),reorient=FALSE)
    d=data.frame(name=fMR, width= dim(single.img)[1], height = dim(single.img)[2], 
               vertical = dim(single.img)[3], time = dim(single.img)[4])
    image.str<-rbind(image.str,d)
}
write.csv(image.str,file.path(workFolder,"img_dim.csv"))

d=dim(single.img) #61 73 61 152

image(1:d[1],1:d[2],single.img[,,11,1],col=gray(0:64/64),
      xlab="",ylab="")
