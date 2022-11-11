# THIS IS MEANT FOR COLLECTION 2 USE ONLY!

rm(list=ls())
library(sp)
library(raster)
library(rgdal)
library(RColorBrewer)
library(rstudioapi)
library(rlist)
library(maptools)


# TODO: Organise codes into function blocks. 
# TODO: Handle errors with tryCatch.


# Declare location of SG Territory Shapefile Location. Retrieved from data.gov.sg
SG_MAP_DIR = "D:\\LandSat\\MP14_PLNG_AREA_WEB_PL"


# Declare location of processed LST and NDVI
SAVE_LOC = "C:\\Users\\retli\\Desktop\\LandSat\\Data\\LandSat 8\\Collection 2\\Level 1\\2021\\Processed"


# Create the download directories
dir.create(file.path(SAVE_LOC, "LST"), showWarnings = FALSE)
dir.create(file.path(SAVE_LOC, "NDVI"), showWarnings = FALSE)


# Selecting Data Folder ----
# Opens a dialog box to interactively select the folder that contains the data. 
# TODO: Select parent folder with collection of dataset. Then process all of them.
#base_dir <- dirname(getActiveDocumentContext()$path)
base_dir <- "C:\\Users\\retli\\Desktop\\LandSat\\Data\\LandSat 8\\Collection 2\\Level 1\\2021"
folder_dir <- selectDirectory(
  caption =  "Select Directory with Landsat 8 Data",
  label =  "Select",
  path =  base_dir
  )
print(folder_dir)


# Search and Parse MTL File ----
# Create a search pattern for ".txt" and search folder for metadata text files. 
# Assign the calibration coefficients for each band into respective variables. 
mtl_file = list.files(path=folder_dir, pattern=".MTL.txt")
mtl = read.table(file = file.path(folder_dir, mtl_file), header = T,
                 sep = '=', col.names = c("Variable", "Value"),
                 stringsAsFactors = F, fill = T, strip.white = T)

LANDSAT_PRODUCT_ID <- mtl$Value[which(mtl$Variable=="LANDSAT_PRODUCT_ID")]
DATE_ACQUIRED <- mtl$Value[which(mtl$Variable=="DATE_ACQUIRED")]
S_E <- as.numeric(mtl$Value[which(mtl$Variable=="SUN_ELEVATION")])


# Search and Parse for Constants for Calculations ----
# Iterative Search and assign is commented out because it is not as intuitive to read. #####
# Flat is better than nested. YMMV. Otherwise, the iterative search code is working. 
# # Iteratively create RADIANCE_MULT_BAND and RADIANCE_ADD_BAND 1-11
# for (i in 1:11) {
#   
#   # Parse RADIANCE_MULT_BAND_# Coefficients
#   coeff <- paste0("RADIANCE_MULT_BAND_", i)
#   assign(coeff, as.numeric(mtl$Value[which(mtl$Variable==coeff)]))
#   
#   # Parse RADIANCE_ADD_BAND_# Coefficients
#   coeff <- paste0("RADIANCE_ADD_BAND_", i)
#   assign(coeff, as.numeric(mtl$Value[which(mtl$Variable==coeff)]))
# }

# # Iteratively create REFLECTANCE_MULT_BAND and REFLECTANCE_ADD_BAND 1-9
# for (i in 1:9) {
#   # Parse RADIANCE_MULT_BAND_# Coefficients
#   coeff <- paste0("REFLECTANCE_MULT_BAND_", i)
#   assign(coeff, as.numeric(mtl$Value[which(mtl$Variable==coeff)]))
# 
#   # Parse RADIANCE_MULT_BAND_# Coefficients
#   coeff <- paste0("REFLECTANCE_ADD_BAND_", i)
#   assign(coeff, as.numeric(mtl$Value[which(mtl$Variable==coeff)]))
# }

# # Iteratively create K1/K2 CONSTANT BAND 10/11
# for (i in 1:2) {
#   # Parse K#_CONSTANT_BAND_10 Coefficients
#   coeff <- paste0("K", i, "_CONSTANT_BAND_10")
#   
#   # Parse K#_CONSTANT_BAND_11 Coefficients
#   coeff <- paste0("K", i, "_CONSTANT_BAND_11")
# }
# rm(coeff, i)
#####

RADIANCE_MULT_BAND_1 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_1")])
RADIANCE_MULT_BAND_2 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_2")])
RADIANCE_MULT_BAND_3 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_3")])
RADIANCE_MULT_BAND_4 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_4")])
RADIANCE_MULT_BAND_5 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_5")])
RADIANCE_MULT_BAND_6 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_6")])
RADIANCE_MULT_BAND_7 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_7")])
RADIANCE_MULT_BAND_8 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_8")])
RADIANCE_MULT_BAND_9 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_9")])
RADIANCE_MULT_BAND_10 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_10")])
RADIANCE_MULT_BAND_11 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_MULT_BAND_11")])

RADIANCE_ADD_BAND_1 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_1")])
RADIANCE_ADD_BAND_2 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_2")])
RADIANCE_ADD_BAND_3 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_3")])
RADIANCE_ADD_BAND_4 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_4")])
RADIANCE_ADD_BAND_5 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_5")])
RADIANCE_ADD_BAND_6 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_6")])
RADIANCE_ADD_BAND_7 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_7")])
RADIANCE_ADD_BAND_8 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_8")])
RADIANCE_ADD_BAND_9 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_9")])
RADIANCE_ADD_BAND_10 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_10")])
RADIANCE_ADD_BAND_11 <- as.numeric(mtl$Value[which(mtl$Variable=="RADIANCE_ADD_BAND_11")])

# Note that REFLECTANCE only goes from Band 1 - 9.
REFLECTANCE_MULT_BAND_1 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_MULT_BAND_1")])
REFLECTANCE_MULT_BAND_2 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_MULT_BAND_2")])
REFLECTANCE_MULT_BAND_3 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_MULT_BAND_3")])
REFLECTANCE_MULT_BAND_4 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_MULT_BAND_4")])
REFLECTANCE_MULT_BAND_5 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_MULT_BAND_5")])
REFLECTANCE_MULT_BAND_6 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_MULT_BAND_6")])
REFLECTANCE_MULT_BAND_7 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_MULT_BAND_7")])
REFLECTANCE_MULT_BAND_8 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_MULT_BAND_8")])
REFLECTANCE_MULT_BAND_9 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_MULT_BAND_9")])

REFLECTANCE_ADD_BAND_1 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_ADD_BAND_1")])
REFLECTANCE_ADD_BAND_2 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_ADD_BAND_2")])
REFLECTANCE_ADD_BAND_3 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_ADD_BAND_3")])
REFLECTANCE_ADD_BAND_4 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_ADD_BAND_4")])
REFLECTANCE_ADD_BAND_5 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_ADD_BAND_5")])
REFLECTANCE_ADD_BAND_6 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_ADD_BAND_6")])
REFLECTANCE_ADD_BAND_7 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_ADD_BAND_7")])
REFLECTANCE_ADD_BAND_8 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_ADD_BAND_8")])
REFLECTANCE_ADD_BAND_9 <- as.numeric(mtl$Value[which(mtl$Variable=="REFLECTANCE_ADD_BAND_9")])

K1_CONSTANT_BAND_10 <- as.numeric(mtl$Value[which(mtl$Variable=="K1_CONSTANT_BAND_10")])
K2_CONSTANT_BAND_10 <- as.numeric(mtl$Value[which(mtl$Variable=="K2_CONSTANT_BAND_10")])
K1_CONSTANT_BAND_11 <- as.numeric(mtl$Value[which(mtl$Variable=="K1_CONSTANT_BAND_11")])
K2_CONSTANT_BAND_11 <- as.numeric(mtl$Value[which(mtl$Variable=="K2_CONSTANT_BAND_11")])



# Search and Assign TIFF Images ----
# OLD METHOD #####
# # Create a search pattern for ".TIF" and search folder for TIF files. 
# # Assign the TIF files for each band into respective variables. 
# # band_# = Band #, band_qa = Band QA
# tiff_filelist <- list.files(path=folder_dir, pattern=".TIF")
# band_1 <- raster(file.path(folder_dir, tiff_filelist[grep("B1.TIF",tiff_filelist)]))
# band_2 <- raster(file.path(folder_dir, tiff_filelist[grep("B2.TIF",tiff_filelist)]))
# band_3 <- raster(file.path(folder_dir, tiff_filelist[grep("B3.TIF",tiff_filelist)]))
# band_4 <- raster(file.path(folder_dir, tiff_filelist[grep("B4.TIF",tiff_filelist)]))
# band_5 <- raster(file.path(folder_dir, tiff_filelist[grep("B5.TIF",tiff_filelist)]))
# band_6 <- raster(file.path(folder_dir, tiff_filelist[grep("B6.TIF",tiff_filelist)]))
# band_7 <- raster(file.path(folder_dir, tiff_filelist[grep("B7.TIF",tiff_filelist)]))
# band_8 <- raster(file.path(folder_dir, tiff_filelist[grep("B8.TIF",tiff_filelist)]))
# band_9 <- raster(file.path(folder_dir, tiff_filelist[grep("B9.TIF",tiff_filelist)]))
# band_10 <- raster(file.path(folder_dir, tiff_filelist[grep("B10.TIF",tiff_filelist)]))
# band_11 <- raster(file.path(folder_dir, tiff_filelist[grep("B11.TIF",tiff_filelist)]))
# band_qa <- raster(file.path(folder_dir, tiff_filelist[grep("BQA.TIF",tiff_filelist)]))
#####


# # Iteratively search and load raster file for band 1-11
# for (i in 1:11) {
#   band_number <- paste0("band_", i)
#   file_name <- mtl$Value[which(mtl$Variable==paste0("FILE_NAME_BAND_", i))]
#   assign(band_number, raster(file.path(folder_dir, file_name)))
# }
# 
# #Search and load raster file for band QA
# file_name <- mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_QUALITY")]
# band_qa <- raster(file.path(folder_dir, file_name))
# rm(i, file_name, band_number)


band_1 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_1")][1]))
band_2 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_2")][1]))
band_3 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_3")][1]))
band_4 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_4")][1]))
band_5 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_5")][1]))
band_6 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_6")][1]))
band_7 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_7")][1]))
band_8 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_8")][1]))
band_9 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_9")][1]))
band_10 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_10")][1]))
band_11 <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_BAND_11")][1]))
band_qa <- raster(file.path(folder_dir, mtl$Value[which(mtl$Variable=="FILE_NAME_QUALITY_L1_PIXEL")][1]))


# Load SG Territorial Map and Transform Projection to Match USGS dataset----
sg_map <- readOGR(dsn=SG_MAP_DIR, layer="MP14_PLNG_AREA_WEB_PL")
s <- stack(band_2, band_3, band_4, band_5, band_6)
sg_map <- spTransform(sg_map, CRS(proj4string(band_2)))
#crs(s, asText=TRUE)

# # Iteratively Crop and Mask Band Images to SG Map ----
# for (i in 1:11) {
#   assign(paste0("cropped_", i), crop(get(paste0("band_", i)), sg_map))  
#   assign(paste0("masked_", i), mask(get(paste0("cropped_", i)), sg_map))  
# }
# 
# cropped_qa <- crop(band_qa, sg_map)
# masked_qa <- mask(cropped_qa, sg_map)
# masked_qa[masked_qa==2720 | masked_qa==2722] = 1
# masked_qa[masked_qa>1] = 0

cropped_1 <- crop(band_1, sg_map)
cropped_2 <- crop(band_2, sg_map)
cropped_3 <- crop(band_3, sg_map)
cropped_4 <- crop(band_4, sg_map)
cropped_5 <- crop(band_5, sg_map)
cropped_6 <- crop(band_6, sg_map)
cropped_7 <- crop(band_7, sg_map)
cropped_8 <- crop(band_8, sg_map)
cropped_9 <- crop(band_9, sg_map)
cropped_10 <- crop(band_10, sg_map)
cropped_11 <- crop(band_11, sg_map)
cropped_qa <- crop(band_qa, sg_map)

masked_1 <- mask(cropped_1, sg_map)
masked_2 <- mask(cropped_2, sg_map)
masked_3 <- mask(cropped_3, sg_map)
masked_4 <- mask(cropped_4, sg_map)
masked_5 <- mask(cropped_5, sg_map)
masked_6 <- mask(cropped_6, sg_map)
masked_7 <- mask(cropped_7, sg_map)
masked_8 <- mask(cropped_8, sg_map)
masked_9 <- mask(cropped_9, sg_map)
masked_10 <- mask(cropped_10, sg_map)
masked_11 <- mask(cropped_11, sg_map)
masked_qa <- mask(cropped_qa, sg_map)

# Getting Cloud Mask ----
masked_qa[masked_qa == 2720 | masked_qa ==2722]=1
masked_qa[masked_qa> 1]=0

# https://safe.menlosecurity.com/https://www.usgs.gov/core-science-systems/nli/landsat/using-usgs-landsat-level-1-data-product


# Conversion to TOA Reflectance ----
re1 <- calc(masked_1,fun=function(x)(REFLECTANCE_MULT_BAND_1*x+REFLECTANCE_ADD_BAND_1)/sin(S_E*pi/180))
re2 <- calc(masked_2,fun=function(x)(REFLECTANCE_MULT_BAND_2*x+REFLECTANCE_ADD_BAND_2)/sin(S_E*pi/180))
re3 <- calc(masked_3,fun=function(x)(REFLECTANCE_MULT_BAND_3*x+REFLECTANCE_ADD_BAND_3)/sin(S_E*pi/180))
re4 <- calc(masked_4,fun=function(x)(REFLECTANCE_MULT_BAND_4*x+REFLECTANCE_ADD_BAND_4)/sin(S_E*pi/180))
re5 <- calc(masked_5,fun=function(x)(REFLECTANCE_MULT_BAND_5*x+REFLECTANCE_ADD_BAND_5)/sin(S_E*pi/180))
re6 <- calc(masked_6,fun=function(x)(REFLECTANCE_MULT_BAND_6*x+REFLECTANCE_ADD_BAND_6)/sin(S_E*pi/180))
re7 <- calc(masked_7,fun=function(x)(REFLECTANCE_MULT_BAND_7*x+REFLECTANCE_ADD_BAND_7)/sin(S_E*pi/180))
re8 <- calc(masked_8,fun=function(x)(REFLECTANCE_MULT_BAND_8*x+REFLECTANCE_ADD_BAND_8)/sin(S_E*pi/180))
re9 <- calc(masked_9,fun=function(x)(REFLECTANCE_MULT_BAND_9*x+REFLECTANCE_ADD_BAND_9)/sin(S_E*pi/180))

# Conversion to TOA Radiance ----
ra1 <- calc(masked_1,fun=function(x)(RADIANCE_MULT_BAND_1*x+RADIANCE_ADD_BAND_1))
ra2 <- calc(masked_2,fun=function(x)(RADIANCE_MULT_BAND_2*x+RADIANCE_ADD_BAND_2))
ra3 <- calc(masked_3,fun=function(x)(RADIANCE_MULT_BAND_3*x+RADIANCE_ADD_BAND_3))
ra4 <- calc(masked_4,fun=function(x)(RADIANCE_MULT_BAND_4*x+RADIANCE_ADD_BAND_4))
ra5 <- calc(masked_5,fun=function(x)(RADIANCE_MULT_BAND_5*x+RADIANCE_ADD_BAND_5))
ra6 <- calc(masked_6,fun=function(x)(RADIANCE_MULT_BAND_6*x+RADIANCE_ADD_BAND_6))
ra7 <- calc(masked_7,fun=function(x)(RADIANCE_MULT_BAND_7*x+RADIANCE_ADD_BAND_7))
ra8 <- calc(masked_8,fun=function(x)(RADIANCE_MULT_BAND_8*x+RADIANCE_ADD_BAND_8))
ra9 <- calc(masked_9,fun=function(x)(RADIANCE_MULT_BAND_9*x+RADIANCE_ADD_BAND_9))
ra10 <- calc(masked_10,fun=function(x)(RADIANCE_MULT_BAND_10*x+RADIANCE_ADD_BAND_10))
ra11 <- calc(masked_11,fun=function(x)(RADIANCE_MULT_BAND_11*x+RADIANCE_ADD_BAND_11))

# Conversion to Top of Atmosphere Brightness Temperature ----
ABT10 <- calc(ra10,fun = function(x)(K2_CONSTANT_BAND_10/(log(K1_CONSTANT_BAND_10/x+1))))
ABT11 <- calc(ra11,fun = function(x)(K2_CONSTANT_BAND_11/(log(K1_CONSTANT_BAND_11/x+1))))


# Calculate Normalized Difference Vegetable Index (NDVI) with TOA Reflectance ----
# newc = stack( re2,re3,re4,re5,re6)
# bb <- function(img, k, i) {
#   bk <- img[[k]]
#   bi <- img[[i]]
#   bb <- (bk - bi) / (bk + bi)
#   return(bb)
# }
# ndvi <- bb(newc, 4, 3)

ndvi <- (re5 - re4) / (re5 + re4)
ndvi_plot <- overlay(ndvi, masked_qa, fun=function(x,y) x * y) # masking cloud cover

# # Calculate Atmospherically Resistant Vegetation Index (ARVI) with TOA Reflectance ----
# # Not required
# # https://safe.menlosecurity.com/https://eos.com/blog/6-spectral-indexes-on-top-of-ndvi-to-make-your-vegetation-analysis-complete/
# arvi <- (re5 - (2 * re2) + re4) / (re5 + (2 * re2) + re4)
# arvi_plot <- overlay(arvi, masked_qa, fun=function(x,y) x * y) # masking cloud cover


# Declare Constants From Research Paper ----
# Constants from: S. Li and G. Jiang, "Land Surface Temperature Retrieval
#                 From Landsat-8 Data With the Generalized Split-Window Algorithm," 
#                 in IEEE Access, vol. 6, pp. 18149-18162, 2018, 
#                 doi: 10.1109/ACCESS.2018.2818741.
# Page 18152, last paragraph
ev10 <- 0.982
ev11 <- 0.984
es10 <- 0.971
es11 <- 0.976

# Refer to Table 5
a101 <- 0.98
a102 <- -0.14
a103 <- 0.17
a104 <- -0.036
a105 <- -0.083
a106 <- 0.158
a107 <- -0.149
a111 <- 0.979
a112 <- 0.026
a113 <- -0.071
a114 <- 0.048
a115 <- -0.056
a116 <- 0.128
a117 <- -0.105


# Calculate Fractional Vegetation Cover ----
# Assumptions: NDVI(bare_soil) = 0.5, NVDI(vegetation) = 0.3
pv  =calc(ndvi, fun=function(x)(((x-0.5)/0.3)*((x-0.5)/0.3)))

# e10 = masked_1
# ndvi[is.na(ndvi[])] <- 0
# e11 = masked_2

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

# Estimation of Land Surface Emissivities using NDVI based Emissivity Method (NBEM) ----
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

# Refer to Table 3 [4.5 7.8]
# TODO: Use real-time TPW measurement instead of common one
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


# Calculating the Land Surface Temperature with Equation 1 ----
# TODO: Why the need to -k. Hypothesis is Table 3 is in degC and equation requires Kelvin
for (i in 1:1150){
  for(j in 1:1791){
    LST_[i,j] = cC - k +((cA_1+ cA_2*(1-E_[i,j])/E_[i,j] + cA_3*EE_[i,j]/(E_[i,j]*E_[i,j]) )*(ABT10_[i,j] + ABT11_[i,j])/2) + ((cB_1+ cB_2*(1-E_[i,j])/E_[i,j] +cB_3*EE_[i,j]/(E_[i,j]*E_[i,j]) )*(ABT10_[i,j] - ABT11_[i,j])/2)
  }}

LST = raster(LST_)
LST = setExtent(LST,masked_qa)
e10 = setExtent(e10,masked_qa)
e11 = setExtent(e11,masked_qa)

LST_plot = overlay(LST, masked_qa, fun=function(x,y)x*y)
crs(LST_plot) <- "+proj=utm +zone=48 +datum=WGS84 +units=m +no_defs"

# spplot(LST_plot ,col.regions = rainbow(256, start=.1),scales = list(draw = TRUE),zlim =c(20,45))
spplot(LST_plot ,col.regions = rainbow(256, start=.1),scales = list(draw = TRUE),zlim =c(20,45))

# setwd("C:/Users/hdb33075b/Desktop/2020 LST/Remotesensing/data/processed")

writeRaster(LST_plot, file.path(SAVE_LOC, "LST", paste0(DATE_ACQUIRED, "_LST.tif")), options=c('TFW=YES'), overwrite=TRUE)
writeRaster(ndvi_plot, file.path(SAVE_LOC, "NDVI", paste0(DATE_ACQUIRED, "_NDVI.tif")), options=c('TFW=YES'), overwrite=TRUE)


#writeRaster(LST_plot, "202003010_LST.tif", options=c('TFW=YES'))
#writeRaster(ndvi_plot, "20200310_NDVI.tif", options=c('TFW=YES'))


#writeRaster(LST_plot, "20200529_LST.tif", options=c('TFW=YES'))
#writeRaster(ndvi_plot, "20200529_NDVI.tif", options=c('TFW=YES'))

#writeRaster(ndvi_plot, filename = file.path("D:/r files/landsat/sg/thu_may_2018", "NDVI_thu_may_2018.tif"),  format="GTiff", overwrite=TRUE)
#writeRaster(arvi_plot, filename = file.path("D:/r files/landsat/sg/thu_may_2018", "ARVI_thu_may_2018.tif"),  format="GTiff", overwrite=TRUE)
#writeRaster(e11, filename = file.path("D:/r files/landsat/sg/thu_may_2018", "e11.tif"),  format="GTiff", overwrite=TRUE)
#writeRaster(e10, filename = file.path("D:/r files/landsat/sg/thu_may_2018", "e10.tif"),  format="GTiff", overwrite=TRUE)
