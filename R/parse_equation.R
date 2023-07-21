#' Parse equation name into our internal simplified code.
#'
#' Throws an error if not supported.
parse_equation <- function(equation) {
  supported_equations <- c(
    "KimONeil1997"#,
    ## "Marchitto2014" # TODO
    # "Erez1983" TODO
    # "Shackleton1974" TODO
    # "Bemis1998" TODO
  )

  if (!is.null(equation)) {
   if (!is.character(equation)) {
    cli::cli_abort("{.var {equation}} must be a {.type {character}} vector.")
   }
   if (equation %in% c("Marchitto et al., 2014", "Marchitto2014", "Marchitto")) {
     equation <- "Marchitto2014"
   }
   if (equation %in% c("Kim & O'Neil, 1997", "Kim & O'Neil 1997", "Kim&O'Neil1997", "KimONeil1997")) {
     equation <- "KimONeil1997"
   }
  } else {
    equation <- "KimONeil1997"
  }
  if (!equation %in% supported_equations) {
    cli::cli_abort(c("Equation {.var {equation}} is not implemented",
                     "i" = "Supported equation{?s}: {.and {supported_equations}}",
                     "i" = "Feel free to submit a pull request!"))
  }
  return(equation)
}
