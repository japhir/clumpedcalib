#' Summarize the bootstrapped values into a mean, sd, and the 68% and 95% CIs
#'
#' @param boot Output of `apply_calib_and_d18O_boot()`
#' @param group The group to summarize by.
#' @export
our_summary <- function(boot, group) {
  boot |>
    dplyr::group_by({{group}}) |>
    ggdist::median_qi(.exclude = "replicate",
                      .width = c(.68, .95))
}
