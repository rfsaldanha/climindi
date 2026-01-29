# Compute maximum temperature indicators from grouped data

The function computes maximum temperature indicators from grouped data.
Expects temperature in celsius degrees.

## Usage

``` r
summarise_temp_max(.x, value_var, normals_df)
```

## Arguments

- .x:

  grouped data, created with
  [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)

- value_var:

  name of the variable with temperature values.

- normals_df:

  normals data, created with
  [`summarise_normal()`](https://rfsaldanha.github.io/climindi/reference/summarise_normal.md)

## Value

A tibble.

## Details

The heat waves indicators are computed based on climatological normals,
created with the
[`summarise_normal()`](https://rfsaldanha.github.io/climindi/reference/summarise_normal.md)
function and passed with the `normals_df` argument. Keys to join the
normals data must be present (like id, year, and month) and use the same
names. The variables `hw3` and `hw5` must be present in the dataset.
Those variables can be computed with the
[`add_wave()`](https://rfsaldanha.github.io/climindi/reference/add_wave.md)
function. Plase follow this function example for the correct arguments.

The following indicators are computed for each group.

- `count` Count of data points

- `normal_mean` Climatological normal mean, from `normals_df` argument

- `normal_p10` Climatological 10th percentile, from `normals_df`
  argument

- `normal_p90` Climatological 90th percentile, from `normals_df`
  argument

- `mean` Average

- `median` Median

- `sd` Standard deviation

- `se` Standard error

- `max` Maximum value

- `min` Minimum value

- `p10` 10th percentile

- `p25` 25th percentile

- `p75` 75th percentile

- `p90` 90th percentile

- `heat_waves_3d` Count of heat waves occurences, with 3 or more
  consecutive days with maximum temperature above the climatological
  normal value plus 5 celsius degrees

- `heat_waves_5d` Count of heat waves occurences, with 5 or more
  consecutive days with maximum temperature above the climatological
  normal value plus 5 celsius degrees

- `hot_days` Count of warm days, when the maximum temperature is above
  the normal 90th percentile

- `t_25` Count of days with temperatures above or equal to 25 celsius
  degrees

- `t_30` Count of days with temperatures above or equal to 30 celsius
  degrees

- `t_35` Count of days with temperatures above or equal to 35 celsius
  degrees

- `t_40` Count of days with temperatures above or equal to 40 celsius
  degrees

## Examples

``` r
# Compute monthly normals
normals <- temp_max_data |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable and month
  dplyr::group_by(code_muni, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()

# Compute indicators
temp_max_data |>
# Create wave variables
dplyr::group_by(code_muni) |>
   add_wave(
     normals_df = normals,
     threshold = 5,
     threshold_cond = "gte",
     size = 3,
     var_name = "hw3"
   ) |>
   add_wave(
     normals_df = normals,
     threshold = 5,
     threshold_cond = "gte",
     size = 5,
     var_name = "hw5"
   ) |>
   dplyr::ungroup() |>
 # Identify year
 dplyr::mutate(year = lubridate::year(date)) |>
 # Identify month
 dplyr::mutate(month = lubridate::month(date)) |>
 # Group by id variable, year and month
 dplyr::group_by(code_muni, year, month) |>
 # Compute maximum temperature indicators
 summarise_temp_max(value_var = value, normals_df = normals) |>
 # Ungroup
 dplyr::ungroup()
#> Error in purrr::map(.x = res, .f = iden): ℹ In index: 1.
#> Caused by error in `nseq::trle_cond()`:
#> ! unused argument (pos = TRUE)
```
