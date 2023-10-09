#' Check if the provided equation is supported
#'
#' Also parses equation name into our internal simplified code.
#' See details for which equations are currently supported.
#'
#' - TODO: add all supported equations and references somewhere.
#'
#' - Kim & O'Neil 1997 as recalculated by Bemis et al., 1998:
#'
#'   \eqn{T = a + b(\delta_{c} - \delta_{w}) + c(\delta_{c} - \delta_{w})^2}{T = a + b(delta_c - delta_w) + c(delta_c - delta_w)^2},
#'
#'   where T is in °C, \eqn{\delta_{c}}{delta_c} is in VPDB and \eqn{\delta_{w}}{delta_w} is in VMOW.
#'
#' - Marchitto et al., 2014:
#'
#'   \eqn{(\delta_{cp} - \delta_{ws} + 0.27) = -0.245\pm0.005t + 0.0011\pm0.0002t^{2} + 3.58±0.02}{(delta_cp - delta_ws + 0.27) = -0.245+-0.005t + 0.0011+-0.0002t^2 + 3.58+-0.02}.
#'
#' @param equation Character vector with equation reference.
#' @returns Character vector of cleaned up equation reference. Gives an error if it's currently not supported.
equation_supported <- function(equation) {
  supported_equations <- c(
    "Shackleton1974",
    "ErezLuz1983",
    "KimONeil1997", # NOTE: as recalculated in Bemis 1998!
    ## "Bemis1998",
    "Marchitto2014"
  )

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

  if (!equation %in% supported_equations) {
    cli::cli_abort(c("Equation {.var {equation}} is not implemented",
                     "i" = "Supported equation{?s}: {.and {supported_equations}}",
                     "i" = "Feel free to submit a pull request!"))
  }
  return(equation)
}
