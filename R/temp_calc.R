#' Calculate the temperature from d18Occ and the d18Osw
#'
#' This is the relationship from Kim & O'neil 1997,
#' as updated by Bemis et al., 1998
#'
#' @param d18Occ The d18O of the calcite in VPDB.
#' @param d18Osw The d18O of the sea water in VSMOW
#' @return The temperature in degrees Celsius.
temp_calc <- function(d18Occ, d18Osw) {
  d18Osw <- d18Osw - 0.27
  # the -0.27 is to convert from VSMOW to VPDB
  16.1 - 4.64 * (d18Occ - d18Osw) + 0.09 * (d18Occ - d18Osw)^2
}
