#!/bin/env Rscript

# Author: Yuqing Zhou yz2919@imperial.ac.uk
# Script: Map_GIS.R
# Desc: map locations from data on a world map
# Arguments: 0
# Date: Oct 2019

# install.packages('raster') # Core raster GIS data package
# install.packages('sf') # Core vector GIS data package
# install.packages('rgeos') # Extends vector data functionality
# install.packages('rgdal') # Interface to the Geospatial Data Abstraction Library
# install.packages('lwgeom') # Extends vector data functionality
# install.packages('viridis') # Ccolour scheme

library(raster)
library(sf)
library(viridis)
library(units)

# Vector data
## Making vectors from coordinates

pop_dens <- data.frame(n_km2 = c(260, 67,151, 4500, 133), 
                       country = c('England','Scotland', 'Wales', 'London', 'Northern Ireland'))
print(pop_dens)

# Create coordinates  for each country 
# -  this is a list of sets of coordinates forming the edge of the polygon. 
# - note that they have to _close_ (have the same coordinate at either end)
scotland <- rbind(c(-5, 58.6), c(-3, 58.6), c(-4, 57.6), 
                  c(-1.5, 57.6), c(-2, 55.8), c(-3, 55), 
                  c(-5, 55), c(-6, 56), c(-5, 58.6))
england <- rbind(c(-2,55.8),c(0.5, 52.8), c(1.6, 52.8), 
                  c(0.7, 50.7), c(-5.7,50), c(-2.7, 51.5), 
                  c(-3, 53.4),c(-3, 55), c(-2,55.8))
wales <- rbind(c(-2.5, 51.3), c(-5.3,51.8), c(-4.5, 53.4),
                  c(-2.8, 53.4),  c(-2.5, 51.3))
ireland <- rbind(c(-10,51.5), c(-10, 54.2), c(-7.5, 55.3),
                  c(-5.9, 55.3), c(-5.9, 52.2), c(-10,51.5))

# Convert these coordinates into feature geometries
# - these are simple coordinate sets with no projection information
scotland <- st_polygon(list(scotland))
england <- st_polygon(list(england))
wales <- st_polygon(list(wales))
ireland <- st_polygon(list(ireland))

# Combine geometries into a simple feature column
uk_eire <- st_sfc(wales, england, scotland, ireland, crs=4326)
plot(uk_eire, asp=1)
uk_eire_capitals <- data.frame(long= c(-0.1, -3.2, -3.2, -6.0, -6.25),
                               lat=c(51.5, 51.5, 55.8, 54.6, 53.30),
                               name=c('London', 'Cardiff', 'Edinburgh', 'Belfast', 'Dublin'))
uk_eire_capitals <- st_as_sf(uk_eire_capitals, coords=c('long','lat'), crs=4326)

## Vector geometry operations
st_pauls <- st_point(x=c(-0.098056, 51.513611))
london <- st_buffer(st_pauls, 0.25)
england_no_london <- st_difference(england, london)

# Count the points and show the number of rings within the polygon features
lengths(scotland)
lengths(england_no_london)
wales <- st_difference(wales, england)
# A rough polygon that includes Northern Ireland and surrounding sea.
# - not the alternative way of providing the coordinates
ni_area <- st_polygon(list(cbind(x=c(-8.1, -6, -5, -6, -8.1), y=c(54.4, 56, 55, 54, 54.4))))
northern_ireland <- st_intersection(ireland, ni_area)
eire <- st_difference(ireland, ni_area)

# Combine the final geometries
uk_eire <- st_sfc(wales, england_no_london, scotland, london, northern_ireland, eire, crs=4326)

## Features and geometries
# make the UK into a single feature
uk_country <- st_union(uk_eire[-6])
# compare six Polygon features with one Multipolygon feature
print(uk_eire)
print(uk_country)
# Plot them
par(mfrow=c(1, 2), mar=c(3,3,1,1))
plot(uk_eire, asp=1, col=rainbow(6))
plot(st_geometry(uk_eire_capitals), add=TRUE)
plot(uk_country, asp=1, col='lightblue')

## Vector data and attributes
uk_eire <- st_sf(name=c('Wales', 'England','Scotland', 'London', 
                        'Northern Ireland', 'Eire'),
                 geometry=uk_eire)

plot(uk_eire, asp=1)
uk_eire$capital <- c('London', 'Edinburgh','Cardiff', NA, 'Belfast','Dublin')
uk_eire <- merge(uk_eire, pop_dens, by.x='name', by.y='country', all.x=TRUE)
print(uk_eire)

## Spatial attributes
uk_eire_centroids <- st_centroid(uk_eire)
st_coordinates(uk_eire_centroids)
uk_eire$area <- st_area(uk_eire)
# The length of a polygon is the perimeter length 
#- note that this includes the length of internal holes.
uk_eire$length <- st_length(uk_eire)
print(uk_eire)
# Change units in a neat way
uk_eire$area <- set_units(uk_eire$area, 'km^2')
uk_eire$length <- set_units(uk_eire$length, 'km')
# Or you can simply convert the `units` version to simple numbers
uk_eire$length <- as.numeric(uk_eire$length)
print(uk_eire)
# sf gives us the closest distance between geometries,
st_distance(uk_eire)
st_distance(uk_eire_centroids)
## Plotting sf objects
plot(uk_eire['n_km2'], asp=1)
# Scale the legend
uk_eire$log_n_km2 <- log10(uk_eire$n_km2)
plot(uk_eire['log_n_km2'], asp=1)
# Or 
plot(uk_eire['n_km2'], asp=1, logz=TRUE)

## Reprojecting vector data
# British National Grid (EPSG:27700)
uk_eire_BNG <- st_transform(uk_eire, 27700)
# The bounding box of the data shows the change in units
st_bbox(uk_eire)
st_bbox(uk_eire_BNG)
# UTM50N (EPSG:32650)
uk_eire_UTM50N <- st_transform(uk_eire, 32650)
# Plot the results
par(mfrow=c(1, 3), mar=c(3,3,1,1))
plot(st_geometry(uk_eire), asp=1, axes=TRUE, main='WGS 84')
plot(st_geometry(uk_eire_BNG), axes=TRUE, main='OSGB 1936 / BNG')
plot(st_geometry(uk_eire_UTM50N), axes=TRUE, main='UTM 50N')
# Set up some points separated by 1 degree latitude and longitude from St. Pauls
st_pauls <- st_sfc(st_pauls, crs=4326)
one_deg_west_pt <- st_sfc(st_pauls - c(1, 0), crs=4326) # near Goring
one_deg_north_pt <-  st_sfc(st_pauls + c(0, 1), crs=4326) # near Peterborough
# Calculate the distance between St Pauls and each point
st_distance(st_pauls, one_deg_west_pt)
st_distance(st_pauls, one_deg_north_pt)
st_distance(st_transform(st_pauls, 27700), st_transform(one_deg_west_pt, 27700))
## Improve the London feature
# transform St Pauls to BNG and buffer using 25 km
london_bng <- st_buffer(st_transform(st_pauls, 27700), 25000)
# In one line, transform england to BNG and cut out London
england_not_london_bng <- st_difference(st_transform(st_sfc(england, crs=4326), 27700), london_bng)
# project the other features and combine everything together
others_bng <- st_transform(st_sfc(eire, northern_ireland, scotland, wales, crs=4326), 27700)
corrected <- c(others_bng, london_bng, england_not_london_bng)
# Plot that and marvel at the nice circular feature around London
par(mar=c(3,3,1,1))
plot(corrected, main='25km radius London', axes=TRUE)


# Rasters
## Creating a raster
# Create an empty raster object covering UK and Eire
uk_raster_WGS84 <- raster(xmn=-11,  xmx=2,  ymn=49.5, ymx=59, 
                          res=0.5, crs="+init=EPSG:4326")
hasValues(uk_raster_WGS84)
# Add data to the raster: just the number 1 to number of cells
values(uk_raster_WGS84) <- seq(length(uk_raster_WGS84))
plot(uk_raster_WGS84)
plot(st_geometry(uk_eire), add=TRUE, border='black', lwd=2, col='#FFFFFF44')
## Changing raster resolution
# Define a simple 4 x 4 square raster
m <- matrix(c(1, 1, 3, 3,
              1, 2, 4, 3,
              5, 5, 7, 8,
              6, 6, 7, 7), ncol=4, byrow=TRUE)
square <- raster(m)
# Average values
square_agg_mean <- aggregate(square, fact=2, fun=mean)
values(square_agg_mean)
# Maximum values
square_agg_max <- aggregate(square, fact=2, fun=max)
values(square_agg_max)
# Modal values for categories
square_agg_modal <- aggregate(square, fact=2, fun=modal)
values(square_agg_modal)

## Disaggregating rasters
# Copy parents
square_disagg <- disaggregate(square, fact=2)
# Interpolate
square_disagg_interp <- disaggregate(square, fact=2, method='bilinear')

## Reprojecting a raster
# make two simple `sfc` objects containing points in  the
# lower left and top right of the two grids
uk_pts_WGS84 <- st_sfc(st_point(c(-11, 49.5)), st_point(c(2, 59)), crs=4326)
uk_pts_BNG <- st_sfc(st_point(c(-2e5, 0)), st_point(c(7e5, 1e6)), crs=27700)
#  Use st_make_grid to quickly create a polygon grid with the right cellsize
uk_grid_WGS84 <- st_make_grid(uk_pts_WGS84, cellsize=0.5)
uk_grid_BNG <- st_make_grid(uk_pts_BNG, cellsize=1e5)
# Reproject BNG grid into WGS84
uk_grid_BNG_as_WGS84 <- st_transform(uk_grid_BNG, 4326)
# Plot the features
plot(uk_grid_WGS84, asp=1, border='grey', xlim=c(-13,4))
plot(st_geometry(uk_eire), add=TRUE, border='darkgreen', lwd=2)
plot(uk_grid_BNG_as_WGS84, border='red', add=TRUE)

# Create the target raster
uk_raster_BNG <- raster(xmn=-200000, xmx=700000, ymn=0, ymx=1000000,
                         res=100000, crs='+init=EPSG:27700')
uk_raster_BNG_interp <- projectRaster(uk_raster_WGS84, uk_raster_BNG, method='bilinear')
uk_raster_BNG_ngb <- projectRaster(uk_raster_WGS84, uk_raster_BNG, method='ngb')
# compare the values in the top row
round(values(uk_raster_BNG_interp)[1:9], 2)
values(uk_raster_BNG_ngb)[1:9]
par(mfrow=c(1,3), mar=c(1,1,2,1))
plot(uk_raster_BNG_interp, main='Interpolated', axes=FALSE, legend=FALSE)
plot(uk_raster_BNG_ngb, main='Nearest Neighbour',axes=FALSE, legend=FALSE)


# Converting between vector and raster data types
## Vector to raster
# Create the target raster 
uk_20km <- raster(xmn=-200000, xmx=650000, ymn=0, ymx=1000000, 
                  res=20000, crs='+init=EPSG:27700')
# Rasterizing polygons
uk_eire_poly_20km  <- rasterize(as(uk_eire_BNG, 'Spatial'), uk_20km, field='name')

# Rasterizing lines
uk_eire_BNG_line <- st_cast(uk_eire_BNG, 'LINESTRING')
st_agr(uk_eire_BNG) <- 'constant'

# Rasterizing lines
uk_eire_BNG_line <- st_cast(uk_eire_BNG, 'LINESTRING')
uk_eire_line_20km <- rasterize(as(uk_eire_BNG_line, 'Spatial'), uk_20km, field='name')

# Rasterizing points 
uk_eire_BNG_point <- st_cast(st_cast(uk_eire_BNG, 'MULTIPOINT'), 'POINT')
uk_eire_BNG_point$name <- as.numeric(uk_eire_BNG_point$name)
uk_eire_point_20km <- rasterize(as(uk_eire_BNG_point, 'Spatial'), uk_20km, field='name')
# Plotting those different outcomes
par(mfrow=c(1,3), mar=c(1,1,1,1))
plot(uk_eire_poly_20km, col=viridis(6, alpha=0.5), legend=FALSE, axes=FALSE)
plot(st_geometry(uk_eire_BNG), add=TRUE, border='grey')

plot(uk_eire_line_20km, col=viridis(6, alpha=0.5), legend=FALSE, axes=FALSE)
plot(st_geometry(uk_eire_BNG), add=TRUE, border='grey')

plot(uk_eire_point_20km, col=viridis(6, alpha=0.5), legend=FALSE, axes=FALSE)
plot(st_geometry(uk_eire_BNG), add=TRUE, border='grey')

## Raster to vector
# rasterToPolygons returns a polygon for each cell and returns a Spatial object
poly_from_rast <- rasterToPolygons(uk_eire_poly_20km)
poly_from_rast <- as(poly_from_rast, 'sf')

# but can be set to dissolve the boundaries between cells with identical values
poly_from_rast_dissolve <- rasterToPolygons(uk_eire_poly_20km, dissolve=TRUE)
poly_from_rast_dissolve <- as(poly_from_rast_dissolve, 'sf')

# rasterToPoints returns a matrix of coordinates and values.
points_from_rast <- rasterToPoints(uk_eire_poly_20km)
points_from_rast <- st_as_sf(data.frame(points_from_rast), coords=c('x','y'))

par(mfrow=c(1,3), mar=c(1,1,1,1))
plot(poly_from_rast['layer'], key.pos = NULL, reset = FALSE)
plot(poly_from_rast_dissolve, key.pos = NULL, reset = FALSE)
plot(points_from_rast, key.pos = NULL, reset = FALSE)


# Using data in files
## Saving vector data
#####TRY DIR NAME
st_write(uk_eire, '../results/uk_eire_WGS84.shp')
st_write(uk_eire_BNG, '../results/uk_eire_BNG.shp')
st_write(uk_eire, '../results/uk_eire_WGS84.geojson')
st_write(uk_eire, '../results/uk_eire_WGS84.gpkg')
st_write(uk_eire, '../results/uk_eire_WGS84.json', driver='GeoJSON')

## Saving raster data
writeRaster(uk_raster_BNG_interp, '../data/uk_raster_BNG_interp.tif') # Save a GeoTiff
writeRaster(uk_raster_BNG_ngb, '../data/uk_raster_BNG_ngb.asc', format='ascii')

## Loading Vector data
ne_110 <- st_read('../data/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp')
life_exp <- read.csv(file = "../data/WHOSIS_000001.csv")
## Create some global maps
par(mfrow=c(2,1), mar=c(1,1,1,1))
# 1
plot(ne_110['GDP_MD_EST'],  asp=1, main='Global GDP', logz=TRUE, key.pos=4)
# 2
ne_110 <- merge(ne_110, life_exp, by.x='ISO_A3_EH', by.y='COUNTRY', all.x=TRUE)
bks <- seq(50, 85, by=0.25)
plot(ne_110['Numeric'], asp=1, main='Global 2016 Life Expectancy (Both sexes)',
      breaks=bks, pal=viridis, key.pos=4)

so_data <- read.csv('../data/Southern_Ocean.csv', header=TRUE)
head(so_data)
so_data <- st_as_sf(so_data, coords=c('long', 'lat'), crs=4326) # Convert the data frame to an sf object
head(so_data)

##  Loading Raster data
etopo_25 <- raster('../data/etopo_25.tif')
print(etopo_25)
plot(etopo_25)
## Controlling raster plots
bks <- seq(-10000, 6000, by=250)
land_cols  <- terrain.colors(24)
sea_pal <- colorRampPalette(c('darkslateblue', 'steelblue', 'paleturquoise'))
sea_cols <- sea_pal(40)
plot(etopo_25, axes=FALSE, breaks=bks, col=c(sea_cols, land_cols), 
     axis.args=list(at=seq(-10000, 6000, by=2000), lab=seq(-10,6,by=2)))

## Raster Stacks
tmax <- getData('worldclim', download=TRUE, path='../data', var='tmax', res=10)
print(tmax)
dir('../data/wc10')
# scale the data
tmax <- tmax / 10
# Extract  January and July data and the annual maximum by location.
tmax_jan <- tmax[[1]]
tmax_jul <- tmax[[7]]
tmax_max <- max(tmax)
# Plot those maps
par(mfrow=c(3,1), mar=c(2,2,1,1))
bks <- seq(-500, 500, length=101)
pal <- colorRampPalette(c('lightblue','grey', 'firebrick'))
cols <- pal(100)
ax.args <- list(at= seq(-500, 500, by=100))
plot(tmax_jan, col=cols, breaks=bks, axis.args=ax.args, main='January maximum temperature')
plot(tmax_jul, col=cols, breaks=bks, axis.args=ax.args, main='July maximum temperature')
plot(tmax_max, col=cols, breaks=bks, , axis.args=ax.args, main='Annual maximum temperature')


# Overlaying raster and vector data
## Cropping data
so_extent <- extent(-60, -20, -65, -45)
# The crop function for raster data...
so_topo <- crop(etopo_25, so_extent)
ne_10 <- st_read('../data/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp')
st_agr(ne_10) <- 'constant'
so_ne_10 <- st_crop(ne_10, so_extent)

## Plotting Southern Ocean chlorophyll
sea_pal <- colorRampPalette(c('grey30', 'grey50', 'grey70'))
plot(so_topo, col=sea_pal(100), asp=1, legend=FALSE)
contour(so_topo, levels=c(-2000, -4000, -6000), add=TRUE, col='grey80')
plot(st_geometry(so_ne_10), add=TRUE, col='grey90', border='grey40')
plot(so_data['chlorophyll'], add=TRUE, logz=TRUE, pch=20, cex=2, pal=viridis, border='white', reset=FALSE)
.image_scale(log10(so_data$chlorophyll), col=viridis(18), key.length=0.8, key.pos=4, logz=TRUE)

# Spatial joins and raster data extraction
## Spatial joining
africa <- subset(ne_110, CONTINENT=='Africa', select=c('ADMIN', 'POP_EST'))
# transform to the Robinson projection
africa <- st_transform(africa, crs=54030)
# create a random sample of points
mosquito_points <- st_sample(africa, 1000)
plot(st_geometry(africa), col='khaki')
plot(mosquito_points, col='firebrick', add=TRUE)

mosquito_points <- st_sf(mosquito_points)
mosquito_points <- st_join(mosquito_points, africa['ADMIN'])
plot(st_geometry(africa), col='khaki')
plot(mosquito_points['ADMIN'], add=TRUE)

mosquito_points_agg <- aggregate(mosquito_points, by=list(country=mosquito_points$ADMIN), FUN=length)
names(mosquito_points_agg)[2] <-'n_outbreaks'
head(mosquito_points_agg)

africa <- st_join(africa, mosquito_points_agg)
africa$area <- as.numeric(st_area(africa))
head(africa)

par(mfrow=c(1,2), mar=c(3,3,1,1), mgp=c(2,1, 0))
plot(n_outbreaks ~ POP_EST, data=africa, log='xy', 
     ylab='Number of outbreaks', xlab='Population size')
plot(n_outbreaks ~ area, data=africa, log='xy',
     ylab='Number of outbreaks', xlab='Area (m2)')

## Alien invasion
# Load the data and convert to a sf object
alien_xy <- read.csv('../data/aliens.csv')
alien_xy <- st_as_sf(alien_xy, coords=c('long','lat'), crs=4326)
# Add country information and find the total number of aliens per country
alien_xy <- st_join(alien_xy, ne_110['ADMIN'])
aliens_by_country <- aggregate(n_aliens ~ ADMIN, data=alien_xy, FUN=sum)
# Add the alien counts into the country data 
ne_110 <- merge(ne_110, aliens_by_country, all.x=TRUE)
ne_110$aliens_per_capita <- with(ne_110,  n_aliens / POP_EST)
# create the scale colours
bks <- seq(-8, 2, length=101)
pal <- colorRampPalette(c('darkblue','lightblue', 'salmon','darkred'))
plot(ne_110['aliens_per_capita'], logz=TRUE, breaks=bks, pal=pal, key.pos=4)

## Extracting data from Rasters
uk_eire_etopo <- raster('../data/etopo_uk.tif')
## Masking elevation data
uk_eire_detail <- subset(ne_10, ADMIN %in% c('United Kingdom', "Ireland"))
uk_eire_detail_raster <- rasterize(as(uk_eire_detail, 'Spatial'), uk_eire_etopo)
uk_eire_elev <- mask(uk_eire_etopo, uk_eire_detail_raster)
par(mfrow=c(1,2), mar=c(3,3,1,1), mgp=c(2,1,0))
plot(uk_eire_etopo, axis.args=list(las=3))
plot(uk_eire_elev, axis.args=list(las=3))
plot(st_geometry(uk_eire_detail), add=TRUE, border='grey')

## Raster cell statistics and locations
cellStats(uk_eire_elev, max)
cellStats(uk_eire_elev, quantile)
which.max(uk_eire_elev)# Which is the highest cell
Which(uk_eire_elev > 1100, cells=TRUE)# Which cells are above 1100m
## Highlight highest point and areas below sea level
max_cell <- which.max(uk_eire_elev)
max_xy <- xyFromCell(uk_eire_elev, max_cell)
max_sfc<- st_sfc(st_point(max_xy), crs=4326)
bsl_cell <- Which(uk_eire_elev < 0, cells=TRUE)
bsl_xy <- xyFromCell(uk_eire_elev, bsl_cell)
bsl_sfc <- st_sfc(st_multipoint(bsl_xy), crs=4326)

plot(uk_eire_elev, axis.args=list(las=3))
plot(max_sfc, add=TRUE, pch=24, bg='red')
plot(bsl_sfc, add=TRUE, pch=25, bg='lightblue', cex=0.6)

## The extract function
uk_eire_capitals$elev <- extract(uk_eire_elev, uk_eire_capitals)
print(uk_eire_capitals)
uk_eire$mean_height <- extract(uk_eire_elev, uk_eire, fun=mean, na.rm=TRUE)
uk_eire

st_layers('../data/National_Trails_Pennine_Way.gpx')
# load the data, showing off the ability to use queries to load subsets of the data
pennine_way <- st_read('../data/National_Trails_Pennine_Way.gpx', layer='routes', 
                      query="select * from routes where name='Pennine Way'")

## Reproject the Penine Way
pennine_way_BNG <- st_transform(pennine_way, crs=27700) # reproject the vector data
# create the target raster and project the elevation data into it.
bng_1km <- raster(xmn=-200000, xmx=700000, ymn=0, ymx=1000000, 
                  res=1000, crs='+init=EPSG:27700')
uk_eire_elev_BNG <- projectRaster(uk_eire_elev, bng_1km)


pennine_way_BNG_simple <- st_simplify(pennine_way_BNG,  dTolerance=100)# Simplify the data
par(mfrow=c(1,2), mar=c(1,1,1,1))

plot(uk_eire_elev_BNG, xlim=c(3e5, 5e5), ylim=c(3.8e5, 6.3e5),
     axes=FALSE, legend=FALSE)
plot(st_geometry(pennine_way_BNG), add=TRUE, col='black')
plot(pennine_way_BNG_simple, add=TRUE, col='darkred')
## Warning in plot.sf(pennine_way_BNG_simple, add = TRUE, col = "darkred"):
## ignoring all but the first attribute
zoom <- extent(3.77e5, 3.89e5, 4.7e5, 4.85e5)# Add a zoom box and use that to create a new plot
plot(zoom, add=TRUE)
# Zoomed in plot
plot(uk_eire_elev_BNG, ext=zoom, axes=FALSE, legend=FALSE)
plot(st_geometry(pennine_way_BNG), add=TRUE, col='black')
plot(pennine_way_BNG_simple, add=TRUE, col='darkred')

pennine_way_trans <- extract(uk_eire_elev_BNG, pennine_way_BNG_simple, 
                             along=TRUE, cellnumbers=TRUE)

str(pennine_way_trans)
pennine_way_trans <- pennine_way_trans[[1]]
pennine_way_trans <- data.frame(pennine_way_trans)
pennine_way_xy <- xyFromCell(uk_eire_elev_BNG, pennine_way_trans$cell)
pennine_way_trans <- cbind(pennine_way_trans, pennine_way_xy)
pennine_way_trans$dx <- c(0, diff(pennine_way_trans$x))
pennine_way_trans$dy <- c(0, diff(pennine_way_trans$y))
pennine_way_trans$distance_from_last <- with(pennine_way_trans, sqrt(dx^2 + dy^2))
pennine_way_trans$distance <- cumsum(pennine_way_trans$distance_from_last)

plot( etopo_uk ~ distance, data=pennine_way_trans, type='l', 
     ylab='Elevation (m)', xlab='Distance (m)')


#  Mini projects
## Precipitation transect for New Guinea
transect_long <- c(132.3, 135.2, 146.4, 149.3)
transect_lat <- c(-1, -3.9, -7.7, -9.8)
ng_prec <- getData('worldclim', var='prec', res=0.5, lon=140, lat=-10)
# Reduce to the extent of New Guinea - crop early to avoid unnecessary processing!
ng_extent <- extent(130, 150, -10, 0)
ng_prec <- crop(ng_prec, ng_extent)
# Calculate annual precipitation
ng_annual_prec <- sum(ng_prec)
ng_extent_poly <- st_as_sfc(st_bbox(ng_extent, crs=4326))
st_transform(ng_extent_poly, crs=32754)
ng_extent_utm <- extent(-732000, 1506000, 8874000, 10000000)
# Create the raster and reproject the data
ng_template_utm <- raster(ng_extent_utm, res=1000, crs="+init=EPSG:32754")
ng_annual_prec_utm <- projectRaster(ng_annual_prec, ng_template_utm)
# Create and reproject the transect and then segmentize it to 1000m
transect <-  st_linestring(cbind(x=transect_long, y=transect_lat))
transect <- st_sfc(transect, crs=4326)
transect_utm <- st_transform(transect, crs=32754)
transect_utm <- st_segmentize(transect_utm, dfMaxLength=1000)
transect_data <- extract(ng_annual_prec_utm, as(transect_utm, 'Spatial'), 
                             along=TRUE, cellnumbers=TRUE)

transect_data <- transect_data[[1]]# Get the first item from the transect data 
transect_data <- data.frame(transect_data)
transect_data_xy <- xyFromCell(ng_annual_prec_utm, transect_data$cell)# Get the cell coordinates 
transect_data <- cbind(transect_data, transect_data_xy)

transect_data$dx <- c(0, diff(transect_data$x))
transect_data$dy <- c(0, diff(transect_data$y))
transect_data$distance_from_last <- with(transect_data, sqrt(dx^2 + dy^2))
transect_data$distance <- cumsum(transect_data$distance_from_last)

# Get the natural earth high resolution coastline.
ne_10_ng  <- st_crop(ne_10, ng_extent_poly)
## although coordinates are longitude/latitude, st_intersection assumes that they are planar
ne_10_ng_utm <-  st_transform(ne_10_ng, crs=32754)

par(mfrow=c(2,1), mar=c(3,3,1,1), mgp=c(2,1,0))
plot(ng_annual_prec_utm)
plot(ne_10_ng_utm, add=TRUE, col=NA, border='grey50')

plot(transect_utm, add=TRUE)

par(mar=c(3,3,1,1))
plot( layer ~ distance, data=transect_data, type='l', 
     ylab='Annual precipitation (mm)', xlab='Distance (m)')

## Fishing pressure in Fiji
library(gdistance)
library(openxlsx)

# Download the GADM data for Fiji, convert to sf and then extract Kadavu
fiji <- getData('GADM', country='FJI', level=2, path='../data')
fiji <- st_as_sf(fiji)
kadavu <- subset(fiji, NAME_2 == 'Kadavu')

# Load the villages and sites and convert to sf
villages <- readWorkbook('../data/FishingPressure.xlsx', 'Villages')
villages <- st_as_sf(villages, coords=c('long','lat'), crs=4326)
sites <- readWorkbook('../data/FishingPressure.xlsx', 'Field sites', startRow=3)
sites <- st_as_sf(sites, coords=c('Long','Lat'), crs=4326)

# Reproject the data UTM60S
kadavu <- st_transform(kadavu, 32760)
villages <- st_transform(villages, 32760)
sites <- st_transform(sites, 32760)

# Map to check everything look right.
plot(st_geometry(sites), axes=TRUE, col='blue')
plot(st_geometry(villages), add=TRUE, col='red')
plot(st_geometry(kadavu), add=TRUE)

## Create the cost surface
# Create a template raster covering the whole study area, at a given resolution
res <- 100
r <- raster(xmn=590000, xmx=670000, ymn=7870000, ymx=7940000, crs=32760, res=res)

# Rasterize the island as a POLYGON to get cells that cannot be traversed
kadavu_poly <- rasterize(as(kadavu, 'Spatial'), r, 
                         field=1, background=0)
# Rasterize the island as a MULTILINESTRING to get the coastal 
# cells that _can_ be traversed
kadavu_lines <- rasterize(as(st_cast(kadavu, 'MULTILINESTRING'), 'Spatial'), r, 
                         field=1, background=0)

# Combine those to give cells that are in the sea (kadavu_poly=0) or in the coast (kadavu_lines=1)
sea_r <- (! kadavu_poly) | kadavu_lines

# Set the costs
sea_r[sea_r == 0] <- NA
sea_r[! is.na(sea_r)] <- 1
plot(sea_r)

## Finding launch points
# Find the nearest points on the coast to each village
village_coast <- st_nearest_points(villages, st_cast(kadavu, 'MULTILINESTRING'))
# Extract the end point on the coast and convert from MULTIPOINT to POINT
launch_points <- st_line_sample(village_coast, sample=1)
launch_points <- st_cast(launch_points, 'POINT')

# Zoom in to a bay on Kadavu
plot(st_geometry(kadavu), xlim=c(616000, 618000), ylim=c(7889000, 7891000), col='khaki')
 # Plot the villages, lines to the nearest coast and the launch points.
plot(st_geometry(villages), add=TRUE, col='firebrick')
plot(village_coast, add=TRUE, col='grey')
plot(launch_points, add=TRUE, col='darkgreen')
villages$launch_points <- launch_points
st_geometry(villages) <- 'launch_points'

## Find distances
r <- raster(matrix(0, ncol=5, nrow=5))
r[13] <- 2
# rook, queen and knight cells from the centre cell (13)
# - the output is a matrix with the second column showing the neighbours
rook <- adjacent(r, 13, direction=4)[,2]
queen <- adjacent(r, 13, direction=8)[,2]
knight <- adjacent(r, 13, direction=16)[,2]
# plot those
par(mfrow=c(1,3), mar=c(1,1,1,1))
r[rook] <- 1
plot(r)
r[queen] <- 1
plot(r)
r[knight] <- 1
plot(r)

tr <- transition(sea_r, transitionFunction=mean, directions=8)
tr <- geoCorrection(tr)
costs <- costDistance(tr, as(villages, 'Spatial'), as(sites, 'Spatial'))

## Assign villages to sites
# Find the index and name of the lowest distance in each row
villages$nearest_site_index <- apply(costs, 1, which.min)
villages$nearest_site_name  <- sites$Name[villages$nearest_site_index]

# Find the total number of buildings  per site and merge that data
# into the sites object
site_load <- aggregate(building_count ~ nearest_site_name, data=villages, FUN=sum)
sites <- merge(sites, site_load, by.x='Name', by.y='nearest_site_name', all.x=TRUE)

# Now build up a complex plot
plot(st_geometry(kadavu))
# add the villages, colouring by nearest site and showing the village 
# size using the symbol size (cex)
plot(villages['nearest_site_name'], add=TRUE,  cex=log10(villages$building_count))
# Add the sites and label with site name and building count
plot(st_geometry(sites), add=TRUE, col='red')
labels <- with(sites, sprintf('%s: %s', Name, building_count))
text(st_coordinates(sites), label=labels, cex=0.7, pos=c(3,3,3,3,3,3,1))

# Add the path for each village to its nearest site
for(idx in seq(nrow(villages))){
    this_village <- as(villages[idx, ], 'Spatial')
    this_village_site <- as(sites[this_village$nearest_site_index, ], 'Spatial')
    journey <- shortestPath(tr, this_village, this_village_site, output='SpatialLines')
    plot(st_as_sfc(journey), add=TRUE, col='grey')
}