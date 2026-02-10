## code to prepare `rel_humidity_data` dataset goes here
rel_humidity_files <- c(
  zendown::zen_file(18392587, "rh_mean_mean_2022_1950.parquet"),
  zendown::zen_file(18392587, "rh_mean_mean_2023.parquet"),
  zendown::zen_file(18392587, "rh_mean_mean_2024.parquet"),
  zendown::zen_file(18392587, "rh_mean_mean_2024.parquet")
)

rel_humidity_data <- arrow::open_dataset(rel_humidity_files) |>
  dplyr::filter(code_muni %in% c(3304557, 3136702, 3303401, 3106200)) |>
  dplyr::filter(name == "rh_mean_mean") |>
  dplyr::filter(date >= as.Date("1981-01-01")) |>
  dplyr::filter(date <= as.Date("2025-12-31")) |>
  dplyr::select(-name) |>
  dplyr::arrange(code_muni, date) |>
  dplyr::collect() |>
  dplyr::mutate(value = round(value, 2))

usethis::use_data(rel_humidity_data, overwrite = TRUE, compress = "xz")
