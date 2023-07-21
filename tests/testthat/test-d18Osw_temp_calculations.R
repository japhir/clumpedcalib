test_that("They're reversible", {
  # test Kim & O'Neil, 1997
  temp_calc(d18Occ = 2, d18Osw = 0)
  d18Osw_calc(d18Occ = 2, temperature = 5)
  # is it reversible?
  expect_equal(d18Osw_calc(d18Occ = 3, temp_calc(d18Occ = 3, d18Osw = 0)), 0)
  expect_equal(temp_calc(d18Occ = 3, d18Osw = d18Osw_calc(d18Occ = 3, temp = 5)), 5)

  expect_error(d18Osw_calc(5, 3, equation = "hoi"))
  expect_error(temp_calc(5, 3, equation = "hoi"))
  # test Marchitto et al., 2014
  # this is still wrong, no time to fix it!
  ## temp_calc(d18Occ = 2, d18Osw = 0, equation = "Marchitto2014")
  ## d18Osw_calc(d18Occ = 2, temperature = 5, equation = "Marchitto2014")

  ## tibble::tibble(d18Occ = seq(-10, 10),
  ##                d18Osw = 0,
  ##                temp_K = temp_calc(d18Occ, d18Osw),
  ##                temp_M = temp_calc(d18Occ, d18Osw, equation = "Marchitto2014")) |>
  ##   tidyr::pivot_longer(cols = c(temp_K, temp_M)) |>
  ##   ggplot2::ggplot(aes(x = d18Occ, y = value, colour = name)) +
  ##   geom_line()
})
