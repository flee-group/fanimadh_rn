library(WatershedTools)
library(terra)
library(sf)
devtools::load_all("~/projects_git/packages/WatershedTools")

dem = rast("data/dem.tif")
stream = rast("output/fim.grd")
catch_area = rast("output/catchment.tif")
vv = st_read("output/fim_network.gpkg")

dem = crop(dem, catch_area)
stream = crop(stream, catch_area)
ol = stream$id
names(ol) = "pixel_id"

crs(catch_area) = crs(stream)
f_ws = Watershed(stream$stream, stream$drainage, dem, stream$accum, catch_area, 
	otherLayers = ol)

# distance to outlet for all pixels
out_dist = wsDistance(f_ws, outlets(f_ws)$id) / -1000
f_ws$data$dist = out_dist
saveRDS(f_ws, "output/fanimadh_ws.rds")


