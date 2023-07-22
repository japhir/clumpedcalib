#' Calculate the d18Osw from the d18Occ and temperature
#'
#' According to Kim & O'neil 1997 as modified by Bemis et al., 1998
#'
#' @param temperature  The formation temperature (in °C).
#' @inheritParams temp_calc
#' @return The oxygen isotope composition of the sea water in VSMOW.
#' @author Ilja J. Kocken
#' @export
d18Osw_calc <- function(d18Occ, temperature, equation = NULL) {
  equation <- equation_supported(equation)

  if (equation == "KimONeil1997") {
    # T (°C) = a + b(δc - δw) + c(δc - δw)^2
    # with a = 16.1, b = -4.64, and c = 0.09
    # δw = (sqrt(-4ac + b^2 + 4cT) + b + 2cδc) / 2c
    d18Osw <- (sqrt(-4 * 16.1 * 0.09 + 4.64^2 + 4 * 0.09 * temperature) + -4.64 + 2 * 0.09 * d18Occ) /
      (2 * 0.09) +
      # note the 0.27, which is from conversion from VPDB to VSMOW
      0.27
  } else if (equation == "Marchitto2014") {
    # Marchitto et al., 2014 equation 9
    # (δcp - δws + 0.27) = -0.245±0.005t + 0.0011±0.0002t² + 3.58±0.02
    d18Osw <- 0.245 * temperature - 0.0011 * temperature^2 - 3.58 + d18Occ + 0.27
  }
  d18Osw
}
