## code to prepare `precipitation_data` dataset goes here
precipitation_files <- c(
  zendown::zen_file(10036212, "total_precipitation_sum.parquet"),
  zendown::zen_file(10947952, "total_precipitation_sum.parquet"),
  zendown::zen_file(15748125, "total_precipitation_sum.parquet"),
  zendown::zen_file(18257037, "total_precipitation_sum.parquet")
)

precipitation_data <- arrow::open_dataset(precipitation_files) |>
  dplyr::filter(code_muni %in% c(3304557, 3136702, 3303401, 3106200)) |>
  dplyr::filter(name == "total_precipitation_sum_mean") |>
  dplyr::filter(date >= as.Date("1981-01-01")) |>
  dplyr::filter(date <= as.Date("2025-12-31")) |>
  dplyr::select(-name) |>
  dplyr::arrange(code_muni, date) |>
  dplyr::collect() |>
  dplyr::mutate(value = round(value * 1000, 2))

usethis::use_data(precipitation_data, overwrite = TRUE, compress = "xz")
