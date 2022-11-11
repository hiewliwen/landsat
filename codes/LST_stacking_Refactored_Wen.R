rm(list=ls())


library(raster)
library(sp)
library(maptools)
library(rgdal)
library(rstudioapi)

# library(sf)
# library(spatialEco)


# SAVE_LOC = "E:\\Landsat\\Collection 1\\Level 1\\2021\\LST"
# LST_NAME = "2021 LST.tif"

SAVE_LOC = "E:\\Landsat\\Collection 1\\Level 1\\2021\\NDVI"
LST_NAME = "2021 NDVI.tif"


# Selecting Data Folder ----
# Opens a dialog box to interactively select the folder that contains the data. 
# TODO: Select parent folder with collection of dataset. Then process all of them.
# base_dir <- dirname(getActiveDocumentContext()$path)
base_dir <- SAVE_LOC
folder_dir <- selectDirectory(
  caption =  "Select Directory with Landsat 8 Data",
  label =  "Select",
  path =  base_dir
)

filelist = list.files(path=folder_dir, pattern = ".tif")

baseraster=list()
countraster =list()

nrowslen=length(filelist)

for(i in 1:nrowslen){
  tempraster=raster(file.path(folder_dir, filelist[i]))
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
# spplot(finalst ,col.regions = rainbow(168, start=0.1),scales = list(draw = TRUE),zlim =c(25,50))
#res=0.00027
#LSTnew = projectRaster(LST,crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84")

writeRaster(finalst, file.path(SAVE_LOC, LST_NAME), options=c('TFW=YES'), overwrite=TRUE)
# writeRaster(finalst,'2020LST.tif',options=c('TFW=YES'))
#writeRaster(NDVI,'2020NDVI.tif',options=c('TFW=YES'))