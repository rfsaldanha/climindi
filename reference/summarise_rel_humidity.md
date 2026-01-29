# Compute relative humidity indicators from grouped data

The function computes relative humidity indicators from grouped data.
Expects relative humidity in percentage.

## Usage

``` r
summarise_rel_humidity(.x, value_var, normals_df)
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

The dry and wet spells indicators are computed based on climatological
normals, created with the
[`summarise_normal()`](https://rfsaldanha.github.io/climindi/reference/summarise_normal.md)
function and passed with the `normals_df` argument. Keys to join the
normals data must be present (like id, year, and month) and use the same
names. The variables `ds3`, `ds5`, `ws3` and `ws5` must be present in
the dataset. Those variables can be computed with the
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

- `ds3` Count of dry spells occurences, with 3 or more consecutive days
  with relative humidity bellow the climatological normal value minus 10
  percent

- `ds5` Count of dry spells occurences, with 5 or more consecutive days
  with relative humidity bellow the climatological normal value minus 10
  percent

- `ws3` Count of wet spells occurences, with 3 or more consecutive days
  with relative humidity above the climatological normal value plus 10
  percent

- `ws5` Count of wet spells occurences, with 5 or more consecutive days
  with relative humidity above the climatological normal value plus 10
  percent

- `dry_days` Count of dry days, when the relative humidity is bellow the
  normal 10th percentile

- `wet_days` Count of wet days, when the relative humidity is above the
  normal 90th percentile

- `h_21_30` Count of days with relative humidity between 21% and 30%.
  Attention level

- `h_12_20` Count of days with relative humidity between 12% and 20%.
  Alert level

- `h_11` Count of days with relative humidity bellow 12%. Emergence
  level

## Examples

``` r
# Compute monthly normals
normals <- rel_humidity_data |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable and month
  dplyr::group_by(code_muni, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()

# Compute indicators
rel_humidity_data |>
# Create wave variables
dplyr::group_by(code_muni) |>
   add_wave(
     normals_df = normals,
     threshold = -10,
     threshold_cond = "lte",
     size = 3,
     var_name = "ds3"
   ) |>
   add_wave(
     normals_df = normals,
     threshold = -10,
     threshold_cond = "lte",
     size = 5,
     var_name = "ds5"
   ) |>
   add_wave(
     normals_df = normals,
     threshold = 10,
     threshold_cond = "lte",
     size = 3,
     var_name = "ws3"
   ) |>
   add_wave(
     normals_df = normals,
     threshold = 10,
     threshold_cond = "lte",
     size = 5,
     var_name = "ws5"
   ) |>
   dplyr::ungroup() |>
 # Identify year
 dplyr::mutate(year = lubridate::year(date)) |>
 # Identify month
 dplyr::mutate(month = lubridate::month(date)) |>
 # Group by id variable, year and month
 dplyr::group_by(code_muni, year, month) |>
 # Compute relative humidity indicators
 summarise_rel_humidity(value_var = value, normals_df = normals) |>
 # Ungroup
 dplyr::ungroup()
#> Error in purrr::map(.x = res, .f = iden): ℹ In index: 1.
#> Caused by error in `nseq::trle_cond()`:
#> ! unused argument (pos = TRUE)
```
