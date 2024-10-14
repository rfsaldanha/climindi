test_that("summarise_temp_min works", {
  normals <- temp_min_data |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, month) |>
    summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
    dplyr::ungroup()
  
  res <- temp_min_data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_temp_min(value_var = value, normals_df = normals) |>
    dplyr::ungroup()

  expect_true(all(c("cold_spells_5d", "cold_days") %in% names(res)))
})

test_that("summarsummarise_temp_minise_temp not works with ungrouped data", {
  expect_error(summarise_temp_min(var = temp_min_data))
})
