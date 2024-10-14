test_that("summarise_normal works", {
  normals <- temp_max_data |>
    dplyr::mutate(year = lubridate::year(date)) |>
    dplyr::mutate(month = lubridate::month(date)) |>
    dplyr::group_by(code_muni, year, month) |>
    summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
    dplyr::ungroup()
  
  expect_equal(length(normals), 6)
})
