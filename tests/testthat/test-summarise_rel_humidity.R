test_that("summarise_rel_humidity works", {
  normals <- rel_humidity_data |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, month) |>
    summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
    dplyr::ungroup()
  
  res <- rel_humidity_data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_rel_humidity(value_var = value, normals_df = normals) |>
    dplyr::ungroup()

  expect_true(all(c("wet_spells_5d", "dry_days") %in% names(res)))
})

test_that("summarise_rel_humidity not works with ungrouped data", {
  expect_error(summarise_rel_humidity(var = rel_humidity_data))
})
