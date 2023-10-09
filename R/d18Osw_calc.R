#' Calculate the d18Osw from the d18Occ and temperature
#'
#' Defaults to Kim & O'neil 1997 as modified by Bemis et al., 1998.
#'
#' @param temperature  The formation temperature (in °C).
#' @inheritParams temp_calc
#' @return The oxygen isotope composition of the sea water in VSMOW.
#' @author Ilja J. Kocken
#' @references
#' Kim, S.-T., & O’Neil, J. R. (1997). Equilibrium and nonequilibrium oxygen isotope effects in synthetic carbonates. Geochimica et Cosmochimica Acta, 61(16), 3461–3475. https://doi.org/10.1016/S0016-7037(97)00169-5
#'
#' Bemis, B. E., Spero, H. J., Bijma, J., & Lea, D. W. (1998). Reevaluation of the oxygen isotopic composition of planktonic foraminifera: Experimental results and revised paleotemperature equations. Paleoceanography, 13(2), 150–160. https://doi.org/10.1029/98PA00070
#' @export
d18Osw_calc <- function(d18Occ, temperature, equation = NULL) {
  equation <- equation_supported(equation)

  if (equation == "Shackleton1974") {
    d18Osw <- general_bemis_d18Osw(d18Occ, temperature, a = 16.9, b = -4.0, c = NA, d = -0.20)
  } else if (equation == "ErezLuz1983") {
    d18Osw <- general_bemis_d18Osw(d18Occ, temperature, a = 17.0, b = -4.52, c = 0.03, d = -0.22)
  } else if (equation == "KimONeil1997") {
    d18Osw <- general_bemis_d18Osw(d18Occ, temperature, a = 16.1, b = -4.64, c = 0.09, d = -0.27)
  } else if (equation == "Bemis1998") {
    # there are a lot of variants in table 1, which one should I choose?
    # TODO
    ## d18Osw <- general_bemis_d18Osw(d18Occ, temperature, a = 16.1, b = -4.64, c = 0.09, d = -0.27)
  } else if (equation == "Marchitto2014") {
    # Marchitto et al., 2014 equation 9
    # (δcp - δws + 0.27) = -0.245±0.005t + 0.0011±0.0002t² + 3.58±0.02
    d18Osw <- 0.245 * temperature - 0.0011 * temperature^2 - 3.58 + d18Occ + 0.27
  }
  d18Osw
}

#' General Bemis et al., 1998 Table 1, inverted
#'
#' \eqn{\delta_{w} = \frac{\sqrt{-4ac + b^{2} + 4cT} + b + 2cT}{2c} - d}{δw = (sqrt(-4ac + b^2 + 4cT) + b +2cδc) / 2c - d}
#'
#' @param temperature Input temperature.
#' @inheritParams general_bemis_temp
#' @returns The calculated \eqn{\delta^{18}O}{δ18O} value in VSMOW.
#' @references Bemis, B. E., Spero, H. J., Bijma, J., & Lea, D. W. (1998). Reevaluation of the oxygen isotopic composition of planktonic foraminifera: Experimental results and revised paleotemperature equations. Paleoceanography, 13(2), 150–160. https://doi.org/10.1029/98PA00070
general_bemis_d18Osw <- function(d18Occ, temperature, a, b, c, d) {
  if (is.na(c)) {
    d18Osw <- (a + b * (d18Occ - d) - temperature) / b
  } else {
    d18Osw <- (sqrt(-4 * a * c + b^2 + 4 * c * temperature) + b + 2 * c * d18Occ) / (2 * c) - d
  }
  d18Osw
}
