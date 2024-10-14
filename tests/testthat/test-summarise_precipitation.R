test_that("summarise_precipitation works", {
  normals <- precipitation_data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
    dplyr::ungroup()
  
  res <- precipitation_data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_precipitation(value_var = value, normals_df = normals) |>
    dplyr::ungroup()

  expect_true(all(c("rain_spells_3d", "p_5") %in% names(res)))
})

test_that("summarise_precipitation not works with ungrouped data", {
  expect_error(summarise_precipitation(var = precipitation_data))
})
