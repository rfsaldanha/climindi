test_that("summarise_rel_humidity works", {
  normals <- rel_humidity_data |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, month) |>
    summarise_normal(
      date_var = date,
      value_var = value,
      year_start = 1981,
      year_end = 2010
    ) |>
    dplyr::ungroup()

  res <- rel_humidity_data |>
    dplyr::filter(date >= as.Date("2011-01-01")) |>
    dplyr::group_by(code_muni) |>
    add_wave(
      normals_df = normals,
      threshold = -10,
      threshold_cond = "lte",
      size = 3,
      var_name = "ds3"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = -10,
      threshold_cond = "lte",
      size = 5,
      var_name = "ds5"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = 10,
      threshold_cond = "lte",
      size = 3,
      var_name = "ws3"
    ) |>
    add_wave(
      normals_df = normals,
      threshold = 10,
      threshold_cond = "lte",
      size = 5,
      var_name = "ws5"
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_rel_humidity(value_var = value, normals_df = normals) |>
    dplyr::ungroup()

  expect_true(all(c("ws5", "dry_days") %in% names(res)))
})

test_that("summarise_rel_humidity not works with ungrouped data", {
  expect_error(summarise_rel_humidity(var = rel_humidity_data))
})
