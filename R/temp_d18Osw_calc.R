#' Calculate temperature and d18Osw
#'
#' From bootstrapped samples and a bootstrapped set of slope--intercept pairs.
#'
#' @param boot A tibble with bootstrapped slope-intercept pairs, output of [bootstrap_means()].
#' @param calib A dataframe with draws from the bootstrapped (or Bayesian)
#'   temperature regression. Should have columns `slope` and `intercept`,
#'   which are related via `clumpedr::revcal()`.
#' @inheritParams d18Osw_calc
#' @return Same as boot but with additional columns `temp` and `d18Osw`.
#' @export
temp_d18Osw_calc <- function(boot, calib, equation = NULL, Nsim = NULL) {
  if (is.null(Nsim)) {
    # we simulate the same number of bootstraps for easy combination
    Nsim <- nrow(boot)
    calib <- calib[sample(nrow(calib), replace = TRUE, size = Nsim), ]
  }

  boot |>
    # append the slope/intercept pairs of the temperature calibration
    # this is why we made sure that they are Nsim long as well.
    dplyr::mutate(slope = calib$slope,
                  intercept = calib$intercept) |>
    # calculate temperature using the parameters
    # this relies on my clumpedr package
    # https://github.com/isoverse/clumpedr/
    # you can also just copy its revcal function from here:
    # https://github.com/isoverse/clumpedr/blob/master/R/calibration.R#L72
    dplyr::mutate(
      temp = clumpedr::revcal(D47, slope = slope, intercept = intercept,
                              # we have to use ignorecnf because the confidence calculations
                              # in clumpedr are WRONG!
                              ignorecnf = TRUE)) |>
    # get rid of calibration intercept and slope
    dplyr::select(-slope, -intercept) |>
    # calculate d18Osw using the function above
    # we do not take into account potential uncertainty in these parameters,
    # but this is likely nothing.
    dplyr::mutate(d18Osw = d18Osw_calc(d18Occ = d18O, temp = temp, equation = equation))
}
