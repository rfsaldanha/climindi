test_that("summarise_temp_min works", {
  normals <- temp_min_data |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, month) |>
    summarise_normal(
      date_var = date,
      value_var = value,
      year_start = 1961,
      year_end = 1990
    ) |>
    dplyr::ungroup()

  res <- temp_min_data |>
    dplyr::group_by(code_muni) |>
    add_wave(
      normals_df = normals,
      threshold = -5,
      threshold_cond = "lte",
      size = 3,
      var_name = "cw3"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = -5,
      threshold_cond = "lte",
      size = 5,
      var_name = "cw5"
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_temp_min(value_var = value, normals_df = normals) |>
    dplyr::ungroup()

  expect_true(all(c("cw3", "cw5") %in% names(res)))
})

test_that("summarsummarise_temp_minise_temp not works with ungrouped data", {
  expect_error(summarise_temp_min(var = temp_min_data))
})
