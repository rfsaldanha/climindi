## code to prepare `temp_max` dataset goes here

library(tidyverse)
library(arrow)
library(zendown)

temp_max_data <- zen_file(10036212, "2m_temperature_max.parquet") |>
  open_dataset() |>
  filter(code_muni %in% c(3304557, 3136702, 3303401, 3106200)) |>
  filter(name == "2m_temperature_max_mean") |>
  select(-name) |>
  collect()

usethis::use_data(temp_max_data, overwrite = TRUE, compress = "xz")
