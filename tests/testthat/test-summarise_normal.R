test_that("summarise_normal works", {
  normals <- temp_max_data |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, month) |>
    summarise_normal(
      date_var = date,
      value_var = value,
      year_start = 1981,
      year_end = 2010
    ) |>
    dplyr::ungroup()

  expect_equal(length(normals), 5)
})
