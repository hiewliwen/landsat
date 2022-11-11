rm(list=ls())

library(raster)
library(RColorBrewer)
library(maptools)
library(sp)
library(rgdal)
#library(RStoolbox)
#library(rasterVis)


#setwd("~/Remotesensing/data/raw/2020_07_16")
setwd(r"(C:\Users\retli\Desktop\LandSat\Data\LandSat 8\Collection 1\Level 1\2019\LC08_L1TP_125059_20190103_20190130_01_T1)")


filelist=list.files(pattern=".TIF")


b1 = raster(filelist[grep("B1.TIF",filelist)])
b2 = raster(filelist[grep("B2.TIF",filelist)])
b3 = raster(filelist[grep("B3.TIF",filelist)])
b4 = raster(filelist[grep("B4.TIF",filelist)])
b5 = raster(filelist[grep("B5.TIF",filelist)])
b6 = raster(filelist[grep("B6.TIF",filelist)])
b7 = raster(filelist[grep("B7.TIF",filelist)])
b8 = raster(filelist[grep("B8.TIF",filelist)])
b9 = raster(filelist[grep("B9.TIF",filelist)])
b10 = raster(filelist[grep("B10.TIF",filelist)])
b11 = raster(filelist[grep("B11.TIF",filelist)])
QA = raster(filelist[grep("BQA.TIF",filelist)])


s = stack(b2,b3,b4,b5,b6,b7,b9)
setwd(r"(C:\Users\retli\Desktop\LandSat\MP14_PLNG_AREA_WEB_PL)")
sg <- readOGR(dsn=".","MP14_PLNG_AREA_WEB_PL")
sg <- spTransform(sg, CRS(proj4string(s)))


c1 = crop(b1,sg)
c2 = crop(b2,sg)
c3 = crop(b3,sg)
c4 = crop(b4,sg)
c5 = crop(b5,sg)
c6 = crop(b6,sg)
c7 = crop(b7,sg)
c8 = crop(b8,sg)
c9 = crop(b9,sg)
c10 = crop(b10,sg)
c11 = crop(b11,sg)
c12 = crop(QA, sg)


m1 = mask(c1, sg)
m2 = mask(c2, sg)
m3 = mask(c3, sg)
m4 = mask(c4, sg)
m5 = mask(c5, sg)
m6 = mask(c6, sg)
m7 = mask(c7, sg)
m8 = mask(c8, sg)
m9 = mask(c9, sg)
m10 = mask(c10, sg)
m11 = mask(c11, sg)
m12 = mask(c12,sg)


m12[m12 == 2720 | m12 ==2722]=1
m12[m12> 1]=0


S_E = 54.25190067

RADIANCE_MULT_BAND_1 = 1.2986E-02
RADIANCE_MULT_BAND_2 = 1.3298E-02
RADIANCE_MULT_BAND_3 = 1.2254E-02
RADIANCE_MULT_BAND_4 = 1.0333E-02
RADIANCE_MULT_BAND_5 = 6.3233E-03
RADIANCE_MULT_BAND_6 = 1.5725E-03
RADIANCE_MULT_BAND_7 = 5.3003E-04
RADIANCE_MULT_BAND_8 = 1.1694E-02
RADIANCE_MULT_BAND_9 = 2.4713E-03
RADIANCE_MULT_BAND_10 = 3.3420E-04
RADIANCE_MULT_BAND_11 = 3.3420E-04
RADIANCE_ADD_BAND_1 = -64.92915
RADIANCE_ADD_BAND_2 = -66.48824
RADIANCE_ADD_BAND_3 = -61.26835
RADIANCE_ADD_BAND_4 = -51.66492
RADIANCE_ADD_BAND_5 = -31.61636
RADIANCE_ADD_BAND_6 = -7.86270
RADIANCE_ADD_BAND_7 = -2.65015
RADIANCE_ADD_BAND_8 = -58.47047
RADIANCE_ADD_BAND_9 = -12.35639
RADIANCE_ADD_BAND_10 = 0.10000
RADIANCE_ADD_BAND_11 = 0.10000
REFLECTANCE_MULT_BAND_1 = 2.0000E-05
REFLECTANCE_MULT_BAND_2 = 2.0000E-05
REFLECTANCE_MULT_BAND_3 = 2.0000E-05
REFLECTANCE_MULT_BAND_4 = 2.0000E-05
REFLECTANCE_MULT_BAND_5 = 2.0000E-05
REFLECTANCE_MULT_BAND_6 = 2.0000E-05
REFLECTANCE_MULT_BAND_7 = 2.0000E-05
REFLECTANCE_MULT_BAND_8 = 2.0000E-05
REFLECTANCE_MULT_BAND_9 = 2.0000E-05
REFLECTANCE_ADD_BAND_1 = -0.100000
REFLECTANCE_ADD_BAND_2 = -0.100000
REFLECTANCE_ADD_BAND_3 = -0.100000
REFLECTANCE_ADD_BAND_4 = -0.100000
REFLECTANCE_ADD_BAND_5 = -0.100000
REFLECTANCE_ADD_BAND_6 = -0.100000
REFLECTANCE_ADD_BAND_7 = -0.100000
REFLECTANCE_ADD_BAND_8 = -0.100000
REFLECTANCE_ADD_BAND_9 = -0.100000
K1_CONSTANT_BAND_10 = 774.8853
K2_CONSTANT_BAND_10 = 1321.0789
K1_CONSTANT_BAND_11 = 480.8883
K2_CONSTANT_BAND_11 = 1201.1442


re1 = calc(m1,fun=function(x)(REFLECTANCE_MULT_BAND_1*x+REFLECTANCE_ADD_BAND_1)/sin(S_E*pi/180))
re2 = calc(m2,fun=function(x)(REFLECTANCE_MULT_BAND_2*x+REFLECTANCE_ADD_BAND_2)/sin(S_E*pi/180))
re3 = calc(m3,fun=function(x)(REFLECTANCE_MULT_BAND_3*x+REFLECTANCE_ADD_BAND_3)/sin(S_E*pi/180))
re4 = calc(m4,fun=function(x)(REFLECTANCE_MULT_BAND_4*x+REFLECTANCE_ADD_BAND_4)/sin(S_E*pi/180))
re5 = calc(m5,fun=function(x)(REFLECTANCE_MULT_BAND_5*x+REFLECTANCE_ADD_BAND_5)/sin(S_E*pi/180))
re6 = calc(m6,fun=function(x)(REFLECTANCE_MULT_BAND_6*x+REFLECTANCE_ADD_BAND_6)/sin(S_E*pi/180))
re7 = calc(m7,fun=function(x)(REFLECTANCE_MULT_BAND_7*x+REFLECTANCE_ADD_BAND_7)/sin(S_E*pi/180))
re8 = calc(m8,fun=function(x)(REFLECTANCE_MULT_BAND_8*x+REFLECTANCE_ADD_BAND_8)/sin(S_E*pi/180))
re9 = calc(m9,fun=function(x)(REFLECTANCE_MULT_BAND_9*x+REFLECTANCE_ADD_BAND_9)/sin(S_E*pi/180))

ra1 = calc(m1,fun=function(x)(RADIANCE_MULT_BAND_1*x+RADIANCE_ADD_BAND_1))
ra2 = calc(m2,fun=function(x)(RADIANCE_MULT_BAND_2*x+RADIANCE_ADD_BAND_2))
ra3 = calc(m3,fun=function(x)(RADIANCE_MULT_BAND_3*x+RADIANCE_ADD_BAND_3))
ra4 = calc(m4,fun=function(x)(RADIANCE_MULT_BAND_4*x+RADIANCE_ADD_BAND_4))
ra5 = calc(m5,fun=function(x)(RADIANCE_MULT_BAND_5*x+RADIANCE_ADD_BAND_5))
ra6 = calc(m6,fun=function(x)(RADIANCE_MULT_BAND_6*x+RADIANCE_ADD_BAND_6))
ra7 = calc(m7,fun=function(x)(RADIANCE_MULT_BAND_7*x+RADIANCE_ADD_BAND_7))
ra8 = calc(m8,fun=function(x)(RADIANCE_MULT_BAND_8*x+RADIANCE_ADD_BAND_8))
ra9 = calc(m9,fun=function(x)(RADIANCE_MULT_BAND_9*x+RADIANCE_ADD_BAND_9))
ra10 = calc(m10,fun=function(x)(RADIANCE_MULT_BAND_10*x+RADIANCE_ADD_BAND_10))
ra11 = calc(m11,fun=function(x)(RADIANCE_MULT_BAND_11*x+RADIANCE_ADD_BAND_11))

ABT10 = calc(ra10,fun = function(x)(K2_CONSTANT_BAND_10/(log(K1_CONSTANT_BAND_10/x+1))))
ABT11 = calc(ra11,fun = function(x)(K2_CONSTANT_BAND_11/(log(K1_CONSTANT_BAND_11/x+1))))

newc = stack( re2,re3,re4,re5,re6)

bb <- function(img, k, i) {
  bk <- img[[k]]
  bi <- img[[i]]
  bb <- (bk - bi) / (bk + bi)
  return(bb)
}
ndvi <- bb(newc, 4, 3)
ndvi_plot = overlay(ndvi, m12, fun=function(x,y)x*y)

ARVI = (re5-(2*re2)+re4)/(re5+(2*re2)+re4)
arvi_plot = overlay(ARVI, m12, fun=function(x,y)x*y)

ev10 = 0.982
ev11 = 0.984
es10 = 0.971
es11 = 0.976
a101 = 0.98
a102 = -0.14
a103 = 0.17
a104 = -0.036
a105 =-0.083
a106 = 0.158
a107 =-0.149
a111 = 0.979
a112 = 0.026
a113 = -0.071
a114 = 0.048
a115 =-0.056
a116 = 0.128
a117 =-0.105

pv  =calc(ndvi, fun=function(x)(((x-0.5)/0.3)*((x-0.5)/0.3)))

e10 = m1
ndvi[is.na(ndvi[])] <- 0
e11 = m2

ndvi_ = as.matrix(ndvi)
re1_ = as.matrix(re1)
re2_ = as.matrix(re2)
re3_ = as.matrix(re3)
re4_ = as.matrix(re4)
re5_ = as.matrix(re5)
re6_ = as.matrix(re6)
re7_ = as.matrix(re7)
pv_ = as.matrix(pv)
e10_ =as.matrix(ndvi)
e11_ =as.matrix(ndvi)

ndvi_[is.na(ndvi_[])] <- 0

for (i in 1:1150){
  for (j in 1:1791) {
    if(ndvi_[i,j] < 0.2 && ndvi_[i,j]!= 0){
      e10_[i,j] = a101+ a102*re2_[i,j] +a103*re3_[i,j] + a104*re4_[i,j] +a105*re5_[i,j] +a106*re6_[i,j] +a107*re7_[i,j] 
    }
    if( ndvi_[i,j]>=0.2 && ndvi_[i,j]<=0.5) {
      
      e10_[i,j]  = ev10*pv_[i,j] +es10*(1-pv_[i,j])+ 0.005}
    
    if(  ndvi_[i,j]>0.5) {
      
      e10_[i,j] = ev10 + 0.005}}}

e10_[e10_ == 0] = NA
e10=raster(e10_)

for (i in 1:1150){
  for (j in 1:1791) {
    if(ndvi_[i,j] < 0.2 && ndvi_[i,j]!= 0){
      e11_[i,j] = a111+ a112*re2_[i,j] +a113*re3_[i,j] + a114*re4_[i,j] +a115*re5_[i,j] +a116*re6_[i,j] +a117*re7_[i,j] 
    }
    if( ndvi_[i,j]>=0.2 && ndvi_[i,j]<=0.5) {
      
      e11_[i,j]  = ev11*pv_[i,j] +es11*(1-pv_[i,j])+ 0.005}
    
    if( ndvi_[i,j]>0.5) {
      
      e11_[i,j] = ev11 + 0.005}}
  
}
e11_[e11_ == 0] = NA
e11= raster(e11_)

cA_1 = 0.83976
cA_2 = 0.06830
cA_3 = 0.00286
cB_1 = 6.052
cB_2 = 4.273
cB_3 = -16.171
cC  = 44.396

E_ = as.matrix(e10)
EE_ = as.matrix(e10)
LST_ = as.matrix(e10)
ABT10_ = as.matrix(ABT10)
ABT11_ = as.matrix(ABT11)
e10_ = as.matrix(e10)
e11_ = as.matrix(e11)

E_ = (e10_+e11_)/2
EE_ = e10_-e11_
LST = e10

k = 273.15

for (i in 1:1150){
  for(j in 1:1791){
    LST_[i,j] = cC - k +((cA_1+ cA_2*(1-E_[i,j])/E_[i,j] + cA_3*EE_[i,j]/(E_[i,j]*E_[i,j]) )*(ABT10_[i,j] + ABT11_[i,j])/2) + ((cB_1+ cB_2*(1-E_[i,j])/E_[i,j] +cB_3*EE_[i,j]/(E_[i,j]*E_[i,j]) )*(ABT10_[i,j] - ABT11_[i,j])/2)
  }}

LST = raster(LST_)
LST = setExtent(LST,m12)
e10 = setExtent(e10,m12)
e11 = setExtent(e11,m12)

LST_plot = overlay(LST, m12, fun=function(x,y)x*y)



spplot(LST_plot ,col.regions = rainbow(256, start=.1),scales = list(draw = TRUE),zlim =c(20,45))

setwd(r"(C:\Users\retli\Desktop\LandSat\Data\Processed)")
writeRaster(LST_plot, "20201223_LST.tif", options=c('TFW=YES'))
writeRaster(ndvi_plot, "20201223_NDVI.tif", options=c('TFW=YES'))


#writeRaster(ndvi_plot, filename = file.path("D:/r files/landsat/sg/thu_may_2018", "NDVI_thu_may_2018.tif"),  format="GTiff", overwrite=TRUE)
#writeRaster(arvi_plot, filename = file.path("D:/r files/landsat/sg/thu_may_2018", "ARVI_thu_may_2018.tif"),  format="GTiff", overwrite=TRUE)
#writeRaster(e11, filename = file.path("D:/r files/landsat/sg/thu_may_2018", "e11.tif"),  format="GTiff", overwrite=TRUE)
#writeRaster(e10, filename = file.path("D:/r files/landsat/sg/thu_may_2018", "e10.tif"),  format="GTiff", overwrite=TRUE)