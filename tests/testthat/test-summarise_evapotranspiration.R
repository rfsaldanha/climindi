test_that("summarise_evapotrapiration works", {
  normals <- evapotranspiration_data |>
   dplyr::mutate(month = lubridate::month(date)) |>
   dplyr::group_by(code_muni, month) |>
   summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
   dplyr::ungroup()
   
   res <- evapotranspiration_data |>
     dplyr::mutate(year = lubridate::year(date)) |>
     dplyr::mutate(month = lubridate::month(date)) |>
     dplyr::group_by(code_muni, year, month) |>
      summarise_evapotrapiration(value_var = value, normals_df = normals) |>
     dplyr::ungroup()
 
   expect_true(all(c("l_eto_3", "h_eto_3") %in% names(res)))
 })
 
 test_that("summarise_evapotrapiration not works with ungrouped data", {
   expect_error(summarise_evapotrapiration(var = solar_radiation_data))
 })