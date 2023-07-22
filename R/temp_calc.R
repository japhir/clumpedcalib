#' Calculate the temperature from d18Occ and the d18Osw
#'
#' This is the relationship from Kim & O'neil 1997,
#' as updated by Bemis et al., 1998
#'
#' @param d18Occ The oxygen isotope composition of the carbonate in VPDB.
#' @param d18Osw The oxygen isotope composition of the sea water in VSMOW
#' @param equation Character vector with the equation to use. Defaults to Kim & O'Neil, 1997.
#' @return The temperature in degrees Celsius.
#' @author Ilja J. Kocken
#' @export
temp_calc <- function(d18Occ, d18Osw, equation = NULL) {
  equation <- equation_supported(equation)
  if (equation == "KimONeil1997") {
    # T (°C) = a + b(δc - δw) + c(δc - δw)^2
    # with a = 16.1, b = -4.64, and c = 0.09
    d18Osw <- d18Osw - 0.27 # convert from VSMOW to VPDB
    temp <- 16.1 - 4.64 * (d18Occ - d18Osw) + 0.09 * (d18Occ - d18Osw)^2
  } else if (equation == "Marchitto2014") {
    # Equation 9
    # (δcp - δws + 0.27) = -0.245±0.005t + 0.0011±0.0002t² + 3.58±0.02
    # (δc - δw + 0.27) = -a + b^2 + c
    # (a - sqrt(a² + 4b(-c + δcp - δws + 0.27)) - a) / 2b
    temp <- (0.245 - sqrt(0.045461 + 0.0044 *(d18Occ - d18Osw))) / 0.0022
  }
  temp
}
