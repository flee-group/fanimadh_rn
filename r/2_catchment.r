library(terra)
library(watershed)

fim = rast("output/fim.grd")
Tp = pixel_topology(fim)

pts = as.data.frame(fim$stream, xy=TRUE)
pts$ca = NA
nr = nrow(pts)
reaches = unique(pts$stream)
for(r in reaches) {
	i = which(pts$stream == r)
	pts$ca[i] = catchment(fim, type="points", y = as.matrix(pts[i, 1:2]), area = TRUE, Tp = Tp)
	dn = sum(!is.na(pts$ca))
	cat(paste0(Sys.time(), "  ", dn, "/", nr, " (", round(100 * dn/nr, 0), "%)", "\r"))
}
ca = rast(pts[, c('x', 'y', 'ca')], type = 'xyz')
writeRaster(ca, "output/catchment.tif", overwrite = TRUE, gdal=c("COMPRESS=DEFLATE"))


