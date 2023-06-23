#' Calculate bootstrapped mean values for age, d18O, d13C, and D47 and calculate temperature and d18Osw
#'
apply_calib_and_d18O_boot <- function(data,
                                      calib,
                                      group,
                                      output = "summary",
                                      Nsim = NULL) {
  # make sure you select one of the valid output types
  if (!output %in% c("summary", "raw", "all")) {
    stop("Output needs to be either 'summary', 'raw', or 'all'.")
  }

  # we simulate the same number of bootstraps for easy combination
  if (is.null(Nsim)) {
    Nsim <- nrow(calib)
  } else {
    # take a subset of the calibration with the same size
    calib <- calib[sample(nrow(calib), replace = TRUE, size = Nsim), ]
  }

  sim <- data |>
    filter_outliers(group = {{group}}) |>
    bootstrap_means(group = {{group}},
                    age = age,
                    d13C = d13C_PDB_vit,
                    d18O = d18O_PDB_vit,
                    D47 = D47_final,
                    Nsim = Nsim) |>
    calc_temp_d18Osw(calib = calib, Nsim = Nsim)

  if (output == "raw") {
    return(sim)
  }

  # otherwise return the summary, there is no ALL yet
  sum <- sim |>
    our_summary(group = {{group}})

  ## # we're now missing some essential metadata, which we do summarize in this
  ## # older function we wrote
  ## data |>
  ##   summarize_bins() |>
  ##   select(bins:labs) |>
  ##   left_join(our_summary)
}
