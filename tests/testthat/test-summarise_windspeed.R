test_that("summarise_windspeed works", {
  normals <- windspeed_data |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, month) |>
    summarise_normal(
      date_var = date,
      value_var = value,
      year_start = 1961,
      year_end = 1990
    ) |>
    dplyr::ungroup()

  res <- windspeed_data |>
    dplyr::group_by(code_muni) |>
    add_wave(
      normals_df = normals,
      threshold = 0,
      threshold_cond = "lte",
      size = 3,
      var_name = "l_u2_3"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = 0,
      threshold_cond = "lte",
      size = 5,
      var_name = "l_u2_5"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = 0,
      threshold_cond = "gte",
      size = 3,
      var_name = "h_u2_3"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = 0,
      threshold_cond = "gte",
      size = 5,
      var_name = "h_u2_5"
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_windspeed(value_var = value, normals_df = normals) |>
    dplyr::ungroup()

  expect_true(all(c("l_u2_3", "h_u2_3") %in% names(res)))
})

test_that("summarise_windspeed not works with ungrouped data", {
  expect_error(summarise_windspeed(var = windspeed_data))
})
