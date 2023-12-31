% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clumped_calib_boot.R
\name{clumped_calib_boot}
\alias{clumped_calib_boot}
\title{Bootstrapped clumped isotope calibration}
\usage{
clumped_calib_boot(data, Nsim = 1e+05)
}
\arguments{
\item{data}{A data.frame with columns D47, X, sd_X, and sd_D47. X stands for
the commonly-used temperature scale, 10^6 / T^2 with T in K.}

\item{Nsim}{Number of simulations to do for bootstrapping.}
}
\value{
A \link[tibble:tibble-package]{tibble} with bootstrapped slope--intercept pairs.
}
\description{
Bootstrapped clumped isotope calibration
}
