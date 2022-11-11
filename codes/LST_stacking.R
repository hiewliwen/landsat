rm(list=ls())


library(raster)
library(sp)
library(maptools)
library(rgdal)
# library(sf)
# library(spatialEco)


setwd("C:\\Users\\retli\\Desktop\\LandSat\\Data\\LandSat 8\\Collection 1\\Level 1\\2019\\Processed\\LST")

filelist= list.files(pattern = ".tif")

baseraster=list()
countraster =list()

nrowslen=length(filelist)

for(i in 1:nrowslen){
  tempraster=raster(filelist[i])
  tempraster=calc(tempraster,fun=function(x)(x*1))
  tempraster@data@values[is.na(tempraster@data@values)]=0
  tempraster@data@values[tempraster@data@values<0]=0
  tempcount=tempraster
  tempcount@data@values[tempraster@data@values!=0]=1
  baseraster[[i]]=tempraster
  countraster[[i]]=tempcount
}

tempraster@data@values[1:2059650]=0
tempcount@data@values[1:2059650]=0

for(i in 1:nrowslen){
  tempraster=baseraster[[i]]+tempraster
  tempcount=countraster[[i]]+tempcount  
}

templst=tempraster@data@values/tempcount@data@values

finalst=tempraster
finalst@data@values=templst
finalst@data@values[finalst@data@values<0]=0

mycol=terrain.colors(128)
brks=seq(10,50,by=2)

plot(finalst,col=mycol,main="Original",zlim=c(25,46))
#spplot(finalst ,col.regions = rainbow(168, start=0.1),scales = list(draw = TRUE),zlim =c(25,50))
#res=0.00027
#LSTnew = projectRaster(LST,crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84")

setwd("C:\\Users\\retli\\Desktop\\LandSat\\Data\\LandSat 8\\Collection 1\\Level 1\\2019\\Processed\\LST")

writeRaster(finalst,'2019LST.tif',options=c('TFW=YES'))
#writeRaster(NDVI,'2019NDVI.tif',options=c('TFW=YES'))