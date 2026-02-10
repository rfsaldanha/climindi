test_that("year_interval variables", {
  res <- temp_max_data |>
    dplyr::mutate(interval = year_interval(date, n = 30))

  expect_true("interval" %in% names(res))
})
