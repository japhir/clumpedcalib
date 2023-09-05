#' Calculate temperature and d18Osw
#'
#' From bootstrapped samples and a bootstrapped set of slope--intercept pairs.
#'
#' @param boot A tibble with bootstrapped slope-intercept pairs, output of [bootstrap_means()].
#' @param calib A dataframe with draws from the bootstrapped (or Bayesian)
#'   temperature regression. Should have columns `slope` and `intercept`.
#' @inheritParams d18Osw_calc
#' @return Same as boot but with additional columns `temp` and `d18Osw`.
#' @export
temp_d18Osw_calc <- function(boot, calib, equation = NULL, Nsim = NULL) {
  if (is.null(Nsim)) {
    # we simulate the same number of bootstraps for easy combination
    Nsim <- nrow(boot)
    calib <- calib[sample(nrow(calib), replace = TRUE, size = Nsim), ]
  }

  # re-implement clumpedr::revcal here
  cal <- function(D47 = D47, slp = slope, int = intercept) {
    sqrt((slp * 1e6) / (D47 - int)) - 273.15
  }

  boot |>
    # append the slope/intercept pairs of the temperature calibration
    # this is why we made sure that they are Nsim long as well.
    dplyr::mutate(slope = calib$slope,
                  intercept = calib$intercept) |>
    # calculate temperature using the parameters
    dplyr::mutate(temp = cal(D47, slp = slope, int = intercept)) |>
    # get rid of calibration intercept and slope
    dplyr::select(-slope, -intercept) |>
    # calculate d18Osw using the function above
    # we do not take into account potential uncertainty in these parameters,
    # but this is likely nothing.
    dplyr::mutate(d18Osw = d18Osw_calc(d18Occ = d18O, temp = temp, equation = equation))
}
