#' Check if the provided equation is supported
#'
#' Also parses equation name into our internal simplified code. See
#' [supported_equations()] and References for which equations are currently
#' supported.
#'
#' @param equation Character vector with equation reference. Must be one of [supported_equations()].
#' @returns Character vector of cleaned up equation reference. Gives an error if it's currently not supported.
#' @inherit supported_equations references
equation_supported <- function(equation) {
  # default
  if (is.null(equation)) {
    equation <- "KimONeil1997"
  } else {
    if (!is.character(equation)) {
      cli::cli_abort("{.var {equation}} must be a {.type {character}} vector.")
    }

    # allow aliases of how you type the equation reference
    if (equation %in% c("Shackleton1974",
                        "Shackleton 1974",
                        "Shackleton, 1974")) {
      equation <- "Shackleton1974"
    }
    if (equation %in% c("Erez & Luz, 1983",
                        "Erez & Luz 1983",
                        "Erez&Luz1983",
                        "ErezLuz1983")) {
      equation <- "ErezLuz1983"
    }
    if (equation %in% c("Kim & O'Neil, 1997",
                        "Kim & O'Neil 1997",
                        "Kim&O'Neil1997",
                        "Kim&ONeil",
                        "KimONeil1997")) {
      equation <- "KimONeil1997"
    }
    if (equation %in% c("Bemis 1998",
                        "Bemis 1998",
                        "Bemis et al., 1998")) {
      equation <- "Bemis1998"
    }
    if (equation %in% c("Marchitto et al., 2014",
                        "Marchitto2014",
                        "Marchitto")) {
      equation <- "Marchitto2014"
    }
  }

  if (!equation %in% supported_equations()) {
    cli::cli_abort(c("Equation {.var {equation}} is not implemented/reckognized.",
                     "i" = "Supported equation{?s}: {.and {supported_equations()}}.",
                     "x" = "Maybe you have misspelled it?",
                     "i" = "Feel free to submit a pull request to add the equation!"))
  }
  return(equation)
}

#' Supported d18Osw, d18Occ, temperature relationship equations.
#'
#' Defaults to Kim & O'neil 1997 as modified by Bemis et al., 1998.
# #'
# #' - Kim & O'Neil 1997 as recalculated by Bemis et al., 1998:
# #'
# #'   \eqn{T = a + b(\delta_{c} - \delta_{w}) + c(\delta_{c} - \delta_{w})^2}{T = a + b(delta_c - delta_w) + c(delta_c - delta_w)^2},
# #'
# #'   where T is in °C, \eqn{\delta_{c}}{delta_c} is in VPDB and \eqn{\delta_{w}}{delta_w} is in VMOW.
# #'
# #' - Marchitto et al., 2014:
# #'
# #'   \eqn{(\delta_{cp} - \delta_{ws} + 0.27) = -0.245\pm0.005t + 0.0011\pm0.0002t^{2} + 3.58±0.02}{(delta_cp - delta_ws + 0.27) = -0.245+-0.005t + 0.0011+-0.0002t^2 + 3.58+-0.02}.
# #'
#' @examples
#' supported_equations()
#' @references
#' Shackleton, N. J. (1974). Attainment of isotopic equilibrium between ocean water and the benthic foraminifera genus _Uvigerina_: Isotopic changes in the ocean during the last glacial. _Colloques Internationaux Du CNRS_, _219_, 203–209.
#'
#' Erez, J., & Luz, B. (1983). Experimental paleotemperature equation for planktonic foraminifera. _Geochimica et Cosmochimica Acta_, _47(6)_, 1025–1031. https://doi.org/10.1016/0016-7037(83)90232-6
#'
#' Kim, S.-T., & O’Neil, J. R. (1997). Equilibrium and nonequilibrium oxygen isotope effects in synthetic carbonates. _Geochimica et Cosmochimica Acta_, _61(16)_, 3461–3475. https://doi.org/10.1016/S0016-7037(97)00169-5
#'
#' Bemis, B. E., Spero, H. J., Bijma, J., & Lea, D. W. (1998). Reevaluation of the oxygen isotopic composition of planktonic foraminifera: Experimental results and revised paleotemperature equations. _Paleoceanography_, _13(2)_, 150–160. https://doi.org/10.1029/98PA00070
#'
#' Marchitto, T. M., Curry, W. B., Lynch-Stieglitz, J., Bryan, S. P., Cobb, K. M., & Lund, D. C. (2014). Improved oxygen isotope temperature calibrations for cosmopolitan benthic foraminifera. _Geochimica et Cosmochimica Acta_, _130_, 1–11. https://doi.org/10.1016/j.gca.2013.12.034
supported_equations <- function() {
  c(
    "Shackleton1974",
    "ErezLuz1983",
    "KimONeil1997", # NOTE: as recalculated in Bemis 1998!
    ## "Bemis1998",
    "Marchitto2014"
  )
}
