#' Calculate temperature and d18Osw
#'
#' From bootstrapped samples and a bootstrapped set of slope--intercept pairs.
#'
#' @param calib A dataframe with draws from the bootstrapped (or Bayesian)
#'   temperature regression. Should have columns `slope` and `intercept`,
#'   which are related via `clumpedr::revcal()`.
calc_temp_d18Osw <- function(boot, calib, Nsim = NULL) {
  if (is.null(Nsim)) {
    # we simulate the same number of bootstraps for easy combination
    Nsim <- nrow(boot)
    calib <- calib[sample(nrow(calib), replace = TRUE, size = Nsim), ]
  }

  boot |>
    # append the slope/intercept pairs of the temperature calibration
    # this is why we made sure that they are Nsim long as well.
    mutate(slope = calib$slope,
           intercept = calib$intercept) |>
    # calculate temperature using the parameters
    # this relies on my clumpedr package
    # https://github.com/isoverse/clumpedr/
    # you can also just copy its revcal function from here:
    # https://github.com/isoverse/clumpedr/blob/master/R/calibration.R#L72
    mutate(temp = clumpedr::revcal(D47, slope = slope, intercept = intercept,
                                   # we have to use ignorecnf because the confidence calculations
                                   # in clumpedr are WRONG!
                                   ignorecnf = TRUE)) |>
    # get rid of calibration intercept and slope
    select(-slope, -intercept) |>
    # calculate d18Osw using the function above
    # we do not take into account potential uncertainty in these parameters,
    # but this is likely nothing.
    mutate(d18Osw = d18Osw_calc(d18O, temp))
}
