# Benchmarks
# Commented out due to the download size of M4comp2018 and the M4 dataset.
# library(M4comp2018)
# library(tsdataleaks)
# library(profvis)
# data(M4)
# M4D <- Filter(function(l) l$period == "Daily", M4)
# rm(M4)
# M4D_x <- lapply(M4D, function(temp){temp$x})[100:110]
# profvis({
#   m4d_f1 <- find_dataleaks(M4D_x, h=14, cutoff = 1,boost=TRUE)
# })
# profvis({
#   m4d_f1 <- find_dataleaks(M4D_x, h=14, cutoff = 1,boost=FALSE)
# })
