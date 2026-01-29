test_that("summarise_solar_radiation works", {
  normals <- solar_radiation_data |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, month) |>
    summarise_normal(
      date_var = date,
      value_var = value,
      year_start = 1961,
      year_end = 1990
    ) |>
    dplyr::ungroup()

  res <- solar_radiation_data |>
    dplyr::group_by(code_muni) |>
    add_wave(
      normals_df = normals,
      threshold = 0,
      threshold_cond = "lte",
      size = 3,
      var_name = "d3"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = 0,
      threshold_cond = "lte",
      size = 5,
      var_name = "d5"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = 0,
      threshold_cond = "gte",
      size = 3,
      var_name = "l3"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = 0,
      threshold_cond = "gte",
      size = 5,
      var_name = "l5"
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_solar_radiation(value_var = value, normals_df = normals) |>
    dplyr::ungroup()

  expect_true(all(c("d3", "l5") %in% names(res)))
})

test_that("summarise_solar_radiation not works with ungrouped data", {
  expect_error(summarise_solar_radiation(var = solar_radiation_data))
})
