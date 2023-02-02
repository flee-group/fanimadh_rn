# library(watershed)
library(terra)
library(tidyterra)
library(ggplot2)
library(scico)
library(sf)

## initial DEM cropping
# dem = rast("~/Desktop/Northern_Albania_DEM/EUD_CP-DEMS_5500025000-AA.tif")
# ext = c(5.12e6, 5.18e6, 2.12e6, 2.18e6)
# dem = crop(dem, ext)
# dem = project(dem, "epsg:3035")
# dem = writeRaster(dem, "data/dem.tif")

# currently using development version of watershed, get here
# remotes::install_github("flee-group/watershed", ref='feat/grass8')

dem = rast("data/dem.tif")
outlet = c(5135110, 2121050) 
fim_rn = delineate(dem, outlet = outlet, threshold = 8e6)

# create streams for visualisaion
fim_st = vectorise_stream(fim_rn)

ggplot() + geom_spatraster(data = dem) + scale_fill_scico(palette = 'turku') + 
	geom_sf(data = fim_st, color = '#88aaff')
writeRaster(fim_rn, file="output/fim.grd", overwrite = TRUE, gdal=c("COMPRESS=DEFLATE"))

