library(sf)
library(watershed)
library(terra)
library(data.table)

# devtools::load_all("../../../packages/watershed")

dem = rast("data/dem.tif")
stream = rast("output/fim.grd")

Tp = pixel_topology(stream)
fim_rn = vectorise_stream(stream, Tp)
fim_rn$slope = river_slope(fim_rn, dem)

Tr = reach_topology(stream, Tp)
fim_rn$order = strahler(Tr)

# png("~/Desktop/kamp.png", width = 1000, height = 1000)
# plot(st_geometry(fim_rn), lwd = fim_rn$order*0.5, col = 'blue')
# dev.off()

st_write(fim_rn, "output/fim_network.gpkg", append = FALSE)
