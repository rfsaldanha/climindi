## code to prepare `temp_min` dataset goes here
temp_min_files <- c(
  zendown::zen_file(10036212, "2m_temperature_min.parquet"),
  zendown::zen_file(10947952, "2m_temperature_min.parquet"),
  zendown::zen_file(15748125, "2m_temperature_min.parquet"),
  zendown::zen_file(18257037, "2m_temperature_min.parquet")
)

temp_min_data <- arrow::open_dataset(temp_min_files) |>
  dplyr::filter(code_muni %in% c(3304557, 3136702, 3303401, 3106200)) |>
  dplyr::filter(name == "2m_temperature_min_mean") |>
  dplyr::filter(date >= as.Date("1981-01-01")) |>
  dplyr::filter(date <= as.Date("2025-12-31")) |>
  dplyr::select(-name) |>
  dplyr::arrange(code_muni, date) |>
  dplyr::collect() |>
  dplyr::mutate(value = round(value - 273.15, 2))

usethis::use_data(temp_min_data, overwrite = TRUE, compress = "xz")
