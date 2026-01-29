# Compute evapotranspirations indicators from grouped data

The function computes evapotranspirations (ETo) indicators from grouped
data. Expects evapotranspiration in millimeters (mm).

## Usage

``` r
summarise_evapotrapiration(.x, value_var, normals_df)
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

The high and low ETo indicators are computed based on climatological
normals, created with the
[`summarise_normal()`](https://rfsaldanha.github.io/climindi/reference/summarise_normal.md)
function and passed with the `normals_df` argument. Keys to join the
normals data must be present (like id, year, and month) and use the same
names. The variables `l_eto_3`, `l_eto_5`, `h_eto_3` and `lheto_5` must
be present in the dataset. Those variables can be computed with the
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

- `l_eto_3` Count of sequences of 3 days or more with
  evapotranspirations bellow the climatological average normal

- `l_eto_5` Count of sequences of 5 days or more with
  evapotranspirations bellow the climatological average normal

- `h_eto_3` Count of sequences of 3 days or more with
  evapotranspirations above the climatological average normal

- `h_eto_5` Count of sequences of 5 days or more with
  evapotranspirations above the climatological average normal

## Examples

``` r
# Compute monthly normals
normals <- evapotranspiration_data |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable and month
  dplyr::group_by(code_muni, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()

# Compute indicators
evapotranspiration_data |>
# Create wave variables
dplyr::group_by(code_muni) |>
 add_wave(
     normals_df = normals,
     threshold = 0,
     threshold_cond = "lte",
     size = 3,
     var_name = "l_eto_3"
   ) |>
   add_wave(
     normals_df = normals,
     threshold = 0,
     threshold_cond = "lte",
     size = 5,
     var_name = "l_eto_5"
   ) |>
   add_wave(
     normals_df = normals,
     threshold = 0,
     threshold_cond = "gte",
     size = 3,
     var_name = "h_eto_3"
   ) |>
   add_wave(
     normals_df = normals,
     threshold = 0,
     threshold_cond = "gte",
     size = 5,
     var_name = "h_eto_5"
   ) |>
   dplyr::ungroup() |>
 # Identify year
 dplyr::mutate(year = lubridate::year(date)) |>
 # Identify month
 dplyr::mutate(month = lubridate::month(date)) |>
 # Group by id variable, year and month
 dplyr::group_by(code_muni, year, month) |>
 # Compute evapotranspiration indicators
 summarise_evapotrapiration(value_var = value, normals_df = normals) |>
 # Ungroup
 dplyr::ungroup()
#> Error in purrr::map(.x = res, .f = iden): ℹ In index: 1.
#> Caused by error in `nseq::trle_cond()`:
#> ! unused argument (pos = TRUE)
```
