#' Filter clumped isotope outliers
#'
#' @param data A dataframe with columns `outlier`, `broadid`
#' @param group Column name of the groups.
#' @returns A dataframe with outliers, standards, and NAs filtered out.
#' @export
filter_outliers <- function(data, group) {
  data |>
    tidylog::filter(!outlier,
                    !is.na(outlier)) |> # leave only samples
    tidylog::filter(broadid == "other") |> # make sure they have bins and D47_final and d18O_PDB_vit values
    tidylog::filter(!is.na({{group}}) &
                    !is.na(D47_final) &
                    !is.na(d18O_PDB_vit) &
                    !is.na(d13C_PDB_vit))
}
