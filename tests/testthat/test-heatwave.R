test_that("add_heatwaves works", {
  normals <- temp_max_data |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, month) |>
    summarise_normal(
      date_var = date,
      value_var = value,
      year_start = 1961,
      year_end = 1990
    ) |>
    dplyr::ungroup()

  hw <- temp_max_data |>
    dplyr::group_by(code_muni) |>
    add_heatwave(normals_df = normals)

  expect_true(any(names(hw) %in% "hw3"))
})
