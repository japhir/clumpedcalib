#' Calculate the temperature from d18Occ and the d18Osw
#'
#' This is the relationship from Kim & O'neil 1997,
#' as updated by Bemis et al., 1998
#'
#' @param d18Occ The d18O of the calcite in VPDB.
#' @param d18Osw The d18O of the sea water in VSMOW
#' @return The temperature in degrees Celsius.
#' @export
temp_calc <- function(d18Occ, d18Osw, equation = NULL) {
  equation <- parse_equation(equation)
  if (!equation %in% supported_equations()) {
    cli::cli_abort(c("Equation {equation} is not implemented",
                     "i" = "Feel free to submit a pull request!"))
  }

  if (equation == "KimONeil1997") {
    d18Osw <- d18Osw - 0.27 # convert from VSMOW to VPDB
    temp <- 16.1 - 4.64 * (d18Occ - d18Osw) + 0.09 * (d18Occ - d18Osw)^2
  } else if (equation == "Marchitto2014") {
    # Equation 9
    # (δcp - δws + 0.27) = -0.245±0.005t + 0.0011±0.0002t² + 3.58±0.02
    # should be something like (sqrt(a² + 4b(-c + δcp - δws + 0.27)) - a) / 2b
    # but I haven't checked it!
    # THIS IS NOT CORRECT
    temp <- (0.245 - sqrt(.245^2 + 4 * 0.0011 * (-3.58 + d18Occ - d18Osw + 0.27)) + 0.245) / 2 * 0.0011
  }
  temp
}
