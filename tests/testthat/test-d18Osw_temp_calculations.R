test_that("All equations work", {
  expect_error(d18Osw_calc(5, 3, equation = "hoi"))
  expect_error(temp_calc(5, 3, equation = "hoi"))
  temp_calc(d18Occ = 2, d18Osw = 0, equation = "Shackleton1974")
  temp_calc(d18Occ = 2, d18Osw = 0, equation = "ErezLuz1983")
  temp_calc(d18Occ = 2, d18Osw = 0, equation = "KimONeil1997")
  temp_calc(d18Occ = 2, d18Osw = 0, equation = "Marchitto2014")
  d18Osw_calc(d18Occ = 2, temperature = 5, equation = "Shackleton1974")
  d18Osw_calc(d18Occ = 2, temperature = 5, equation = "ErezLuz1983")
  d18Osw_calc(d18Occ = 2, temperature = 5, equation = "KimONeil1997")
  d18Osw_calc(d18Occ = 2, temperature = 5, equation = "Marchitto2014")
})

test_that("They're reversible", {
  # test Shackleton, 1974
  expect_equal(d18Osw_calc(d18Occ = 3,
                           temp = temp_calc(d18Occ = 3,
                                            d18Osw = 0,
                                            equation = "Shackleton1974"),
                           equation = "Shackleton1974"),
               expected = 0)
  expect_equal(temp_calc(d18Occ = 3,
                         d18Osw = d18Osw_calc(d18Occ = 3, temp = 5,
                                              equation = "Shackleton1974"),
                         equation = "Shackleton1974"),
               expected = 5)

  # test Erez & Luz, 1983
  expect_equal(d18Osw_calc(d18Occ = 3,
                           temp = temp_calc(d18Occ = 3,
                                            d18Osw = 0,
                                            equation = "ErezLuz1983"),
                           equation = "ErezLuz1983"),
               expected = 0)
  expect_equal(temp_calc(d18Occ = 3,
                         d18Osw = d18Osw_calc(d18Occ = 3, temp = 5,
                                              equation = "ErezLuz1983"),
                         equation = "ErezLuz1983"),
               expected = 5)

  # test Kim & O'Neil, 1997
  expect_equal(d18Osw_calc(d18Occ = 3,
                           temp = temp_calc(d18Occ = 3,
                                            d18Osw = 0)),
               expected = 0)
  expect_equal(temp_calc(d18Occ = 3,
                         d18Osw = d18Osw_calc(d18Occ = 3, temp = 5)),
               expected = 5)

  # test Marchitto et al., 2014
  expect_equal(d18Osw_calc(d18Occ = 3,
                           temp = temp_calc(d18Occ = 3,
                                            d18Osw = 0,
                                            equation = "Marchitto2014"),
                           equation = "Marchitto2014"),
               expected = 0)
  expect_equal(temp_calc(d18Occ = 3,
                         d18Osw = d18Osw_calc(d18Occ = 3, temp = 5,
                                              equation = "Marchitto2014"),
                         equation = "Marchitto2014"),
               expected = 5)

  ## # set up a plot for comparison between equations
  ## comparison <- expand.grid(d18Occ = seq(-10, 10),
  ##                           d18Osw = seq(-10, 10)) |>
  ##   tibble::as_tibble() |>
  ##   dplyr::mutate(
  ##     temp_K = temp_calc(d18Occ, d18Osw),
  ##     temp_M = temp_calc(d18Occ, d18Osw, equation = "Marchitto2014"),
  ##     diff = temp_K - temp_M
  ##   )

  ## comparison |>
  ##   ggplot2::ggplot(aes(x = d18Occ, y = d18Osw, fill = diff)) +
  ##   geom_tile() +
  ##   scale_fill_distiller(palette = "PuOr")

  ## comparison |>
  ##   tidyr::pivot_longer(cols = c(temp_K, temp_M, diff)) |>
  ##   ggplot2::ggplot(aes(x = d18Occ, y = value, colour = d18Osw)) +
  ##   geom_line(aes(group = paste(d18Osw, name))) +
  ##   facet_grid(cols = vars(name), scales = "free_y") +
  ##   scale_colour_distiller(palette = "RdBu")

})
