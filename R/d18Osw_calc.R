#' Calculate the d18Osw from the d18Occ and temperature
#'
#' according to Kim & O'neil 1997 as modified by Bemis et al., 1998
#'
#' @param d18Occ The oxygen isotope composition of the calcite in VPDB.
#' @param temperature  The formation temperature (in °C).
#' @return The oxygen isotope composition of the sea water in VSMOW.
#' @author Ilja J. Kocken
d18Osw_calc <- function(d18Occ, temperature) {
  (sqrt(-4 * 16.1 * 0.09 + 4.64^2 + 4 * 0.09 * temperature) - 4.64 + 2 * 0.09 * d18Occ) /
    (2 * 0.09) + 0.27
  # note the 0.27, which is from conversion from VPDB to VSMOW

  # we could also use Marchitto et al., 2014 equation 9
  ## 0.245 * temperature - 0.0011 * temperature^2 - 3.58 + d18Occ + 0.27
}
