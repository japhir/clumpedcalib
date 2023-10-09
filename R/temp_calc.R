#' Calculate the temperature from d18Occ and the d18Osw
#'
#' Defaults to the relationship from Kim & O'neil 1997,
#' as updated by Bemis et al., 1998.
#'
#' @param d18Occ The oxygen isotope composition of the carbonate in VPDB.
#' @param d18Osw The oxygen isotope composition of the sea water in VSMOW
#' @param equation Character vector with the equation to use. Defaults to Kim & O'Neil, 1997.
#' @return The temperature in degrees Celsius.
#' @author Ilja J. Kocken
#' @export
#' @references
#' Kim, S.-T., & O’Neil, J. R. (1997). Equilibrium and nonequilibrium oxygen isotope effects in synthetic carbonates. Geochimica et Cosmochimica Acta, 61(16), 3461–3475. https://doi.org/10.1016/S0016-7037(97)00169-5
#'
#' Bemis, B. E., Spero, H. J., Bijma, J., & Lea, D. W. (1998). Reevaluation of the oxygen isotopic composition of planktonic foraminifera: Experimental results and revised paleotemperature equations. Paleoceanography, 13(2), 150–160. https://doi.org/10.1029/98PA00070
temp_calc <- function(d18Occ, d18Osw, equation = NULL) {
  equation <- equation_supported(equation)
  if (equation == "Shackleton1974") {
    temp <- general_bemis_temp(d18Occ, d18Osw, a = 16.9, b = -4.0, c = NA, d = -0.20)
  } else if (equation == "ErezLuz1983") {
    temp <- general_bemis_temp(d18Occ, d18Osw, a = 17.0, b = -4.52, c = 0.03, d = -0.22)
  } else if (equation == "KimONeil1997") {
    temp <- general_bemis_temp(d18Occ, d18Osw, a = 16.1, b = -4.64, c = 0.09, d = -0.27)
  } else if (equation == "Bemis1998") {
    # there are a lot of variants in table 1
    ## d18Osw <- general_bemis_temp(d18Occ, temperature, a = 17.0, b = -4.52, c = 0, d = -0.20)
  } else if (equation == "Marchitto2014") {
    # Equation 9
    # (δcp - δws + 0.27) = -0.245±0.005t + 0.0011±0.0002t² + 3.58±0.02
    # (x - y + d) = a + b*t + c*t^2, where a = 3.58, b = -0.245 and c = 0.0011
    temp <- -(sqrt(4 * 0.0011 * (-3.58 + d18Occ - d18Osw + 0.27) + (-0.245)^2) - 0.245) / (2 * 0.0011)
  }
  temp
}

#' General Bemis et al. 1998 table 1
#'
#' \eqn{T (°C) = a + b(\delta_{c} - \delta_{w}) + c(\delta_{c}- \delta_{w})^{2}}{T (°C) = a + b(δc - δw) + c(δc - δw)^2}
#'
#' @param d18Occ \eqn{\delta^{18}O}{δ18O} of the calcite in VPDB.
#' @param d18Osw \eqn{\delta^{18}O}{δ18O} of the sea water in VSMOW.
#' @param a Intercept.
#' @param b Slope.
#' @param c Slope of quadratic term.
#' @param d The conversion correction from VSMOW to VPDB.
#' @returns The calculated temperature in °C.
#'
#' @references Bemis, B. E., Spero, H. J., Bijma, J., & Lea, D. W. (1998). Reevaluation of the oxygen isotopic composition of planktonic foraminifera: Experimental results and revised paleotemperature equations. Paleoceanography, 13(2), 150–160. https://doi.org/10.1029/98PA00070
general_bemis_temp <- function(d18Occ, d18Osw, a, b, c, d) {
  if (is.na(c)) {
    temperature <- a + b * (d18Occ - (d18Osw + d))
  } else {
    temperature <- a + b * (d18Occ - (d18Osw + d)) + c * (d18Occ - (d18Osw + d))^2
  }
  temperature
}
