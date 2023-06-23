##' Calculate bootstrapped means for each group in a dataframe
##'
##' @param data A dataframe or tibble that should have columns `outlier`,
##'   `broadid` ("other" for samples), `D47_final`, `d18O_PDB_vit`,
##'   `d13C_PDB_vit`, and the grouping column.
##' @param group The column name in `data` with a character or factor column
##'   that contains the binning information that you want to calculate
##'   bootstrapped averages for.
##' @param age The column name in `data` with the sample ages.
##' @param d13C The column name in `data` with the carbon isotope values.
##' @param d18O The column name in `data` with the oxygen isotope values.
##' @param D47 The column name in `data` with the clumped isotope values.
##' @param Nsim The number of bootstraps you want to run. Defaults to the
##'   number of rows in `calib`.
bootstrap_means <- function(data,
                            group,
                            age,
                            d13C,
                            d18O,
                            D47,
                            Nsim = 1e5) {
  data |>
    # make sure that there are no NAs in group or in your d13C etc!
    group_by({{group}}) |>
    # subset only relevant columns for now unfortunately this gets rid of
    # potentially useful columns. You can left_join them back with
    # distinct(data, id_col1, id_col2)
    select({{group}}, {{age}}, {{d13C}}, {{d18O}}, {{D47}}) |>
    # R magic, search for nesting/unnesting if you want to understand what
    # happens here.
    tidyr::nest() |>
    # create Nsim bootstrapped copies of the data
    mutate(boot = purrr::map(data,
                      ~ infer::rep_slice_sample(.x,
                                                # we resample using all data
                                                prop = 1,
                                                replace = TRUE,
                                                reps = Nsim))) |>
    # get rid of the raw data, leave only the bootstrapped values
    select(-data) |>
    # calculate summaries for the bootstrapped data, Nsim times
    mutate(summ = purrr::map(boot, ~ .x |>
                              summarize(
                                # here they get these new simpler names
                                age = mean({{age}}, na.rm = TRUE),
                                d13C = mean({{d13C}}, na.rm = TRUE),
                                d18O = mean({{d18O}}, na.rm = TRUE),
                                D47 = mean({{D47}}, na.rm = TRUE)))) |>
    # get rid of the bootstrapped values
    select(-boot) |>
    # unfold the bootstraps, we're back to a simple tibble now
    tidyr::unnest(summ)
}