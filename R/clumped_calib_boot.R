#' Bootstrapped clumped isotope calibration
#'
#' @param data A data.frame with columns D47, X, sd_X, and sd_D47. X stands for
#'   the commonly-used temperature scale, 10^6 / T^2 with T in K.
clumped_calib_boot <- function(data, Nsim = 1e5) {
  bs <- function(data, indices) {
    d <- data[indices,] # allows boot to select sample
    fit <- bfsl::bfsl(d$X, d$D47, d$sd_X, d$sd_D47)
    return(coef(fit)) # note that this returns a vector of intercept, slope, intercept error, slope error
  }

  # this returns 4 t values
  results <- boot::boot(data = data, statistic = bs, R = Nsim)

  # tidy up
  tibble::tibble(intercept = results$t[, 1], slope = results$t[, 2])
}
