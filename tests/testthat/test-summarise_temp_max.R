test_that("summarise_temp_max works", {
  normals <- temp_max_data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
    dplyr::ungroup()
  
  res <- temp_max_data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_temp_max(value_var = value, normals_df = normals) |>
    dplyr::ungroup()

  expect_true(all(c("heat_waves_5d", "hot_days") %in% names(res)))
})

test_that("summarise_temp not works with ungrouped data", {
  expect_error(summarise_temp_max(var = temp_max_data))
})
