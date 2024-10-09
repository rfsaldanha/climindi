## code to prepare `temp_max` dataset goes here

library(dplyr)
library(arrow)
library(zendown)

temp_max_data <- zendown::zen_file(13906834, "Tmax_3.2.3.parquet") |>
  open_dataset() |>
  filter(code_muni %in% c(3304557, 3136702, 3303401, 3106200)) |>
  filter(name == "Tmax_3.2.3_mean") |>
  filter(date >= as.Date("1961-01-01")) |>
  filter(date <= as.Date("2023-01-01")) |>
  select(-name) |>
  collect()

usethis::use_data(temp_max_data, overwrite = TRUE, compress = "xz")
