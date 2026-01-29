# Compute minimum temperature indicators from grouped data

The function computes minimum temperature indicators from grouped data.
Expects temperature in celsius degrees.

## Usage

``` r
summarise_temp_min(.x, value_var, normals_df)
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

The cold spells indicators are computed based on climatological normals,
created with the
[`summarise_normal()`](https://rfsaldanha.github.io/climindi/reference/summarise_normal.md)
function and passed with the `normals_df` argument. Keys to join the
normals data must be present (like id, year, and month) and use the same
names. The variables `cw3` and `cw5` must be present in the dataset.
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

- `cold_spells_3d` Count of cold spells occurences, with 3 or more
  consecutive days with minimum temperature bellow the climatological
  normal value minus 5 celsius degrees

- `cold_spells_5d` Count of cold spells occurences, with 5 or more
  consecutive days with minimum temperature bellow the climatological
  normal value minus 5 celsius degrees

- `cold_days` Count of cold days, when the minimum temperature is bellow
  the normal 10th percentile

- `t_0` Count of days with temperatures bellow or equal to 0 celsius
  degrees

- `t_5` Count of days with temperatures bellow or equal to 5 celsius
  degrees

- `t_10` Count of days with temperatures bellow or equal to 10 celsius
  degrees

- `t_15` Count of days with temperatures bellow or equal to 15 celsius
  degrees

- `t_20` Count of days with temperatures bellow or equal to 20 celsius
  degrees

## Examples

``` r
# Compute monthly normals
normals <- temp_min_data |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable and month
  dplyr::group_by(code_muni, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()

# Compute indicators
temp_min_data |>
# Create wave variables
dplyr::group_by(code_muni) |>
   add_wave(
     normals_df = normals,
     threshold = -5,
     threshold_cond = "lte",
     size = 3,
     var_name = "cw3"
   ) |>
   add_wave(
     normals_df = normals,
     threshold = -5,
     threshold_cond = "lte",
     size = 5,
     var_name = "cw5"
   ) |>
   dplyr::ungroup() |>
 # Identify year
 dplyr::mutate(year = lubridate::year(date)) |>
 # Identify month
 dplyr::mutate(month = lubridate::month(date)) |>
 # Group by id variable, year and month
 dplyr::group_by(code_muni, year, month) |>
 # Compute minimum temperature indicators
 summarise_temp_min(value_var = value, normals_df = normals) |>
 # Ungroup
 dplyr::ungroup()
#> Error in purrr::map(.x = res, .f = iden): ℹ In index: 1.
#> Caused by error in `nseq::trle_cond()`:
#> ! unused argument (pos = TRUE)
```
