## code to prepare `windspeed_data` dataset goes here
windspeed_files <- c(
  zendown::zen_file(18390794, "wind_speed_mean_mean_1950_2022.parquet"),
  zendown::zen_file(18390794, "wind_speed_mean_mean_2023.parquet"),
  zendown::zen_file(18390794, "wind_speed_mean_mean_2024.parquet"),
  zendown::zen_file(18390794, "wind_speed_mean_mean_2025.parquet")
)

windspeed_data <- arrow::open_dataset(windspeed_files) |>
  dplyr::filter(code_muni %in% c(3304557, 3136702, 3303401, 3106200)) |>
  dplyr::filter(name == "wind_speed_mean_mean") |>
  dplyr::filter(date >= as.Date("1981-01-01")) |>
  dplyr::filter(date <= as.Date("2025-12-31")) |>
  dplyr::select(-name) |>
  dplyr::arrange(code_muni, date) |>
  dplyr::collect() |>
  dplyr::mutate(value = round(value, 2))

usethis::use_data(windspeed_data, overwrite = TRUE, compress = "xz")
