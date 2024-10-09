test_that("summarise_temp works", {
  res <- temp_max_data |>
    dplyr::mutate(decade = year_interval(date, 10)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, decade, month) |>
    summarise_temp(var = value) |>
    dplyr::ungroup()

  expect_true(all(c("days_a1", "days_a2") %in% names(res)))
})

test_that("summarise_temp not works with ungrouped data", {
  expect_error(summarise_temp(var = temp_max_data))
})
