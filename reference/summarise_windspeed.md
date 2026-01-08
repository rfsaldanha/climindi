# Compute windspeed indicators from grouped data

The function computes windspeed (u2) indicators from grouped data.
Expects windspeed in meters per second (m/s).

## Usage

``` r
summarise_windspeed(.x, value_var, normals_df)
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

The high and low u2 indicators are computed based on climatological
normals, created with the
[`summarise_normal()`](https://rfsaldanha.github.io/climindi/reference/summarise_normal.md)
function and passed with the `normals_df` argument. Keys to join the
normals data must be present (like id, year, and month) and use the same
names.

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

- `l_eto_3` Count of sequences of 3 days or more with windspeed bellow
  the climatological normal

- `l_eto_5` Count of sequences of 5 days or more with windspeed bellow
  the climatological normal

- `h_eto_3` Count of sequences of 3 days or more with windspeed above
  the climatological normal

- `h_eto_5` Count of sequences of 5 days or more with windspeed above
  the climatological normal

## Examples

``` r
# Compute monthly normals
normals <- windspeed_data |>
  # Identify year
  dplyr::mutate(year = lubridate::year(date)) |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable, year and month
  dplyr::group_by(code_muni, year, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()

# Compute indicators
windspeed_data |>
 # Identify month
 dplyr::mutate(month = lubridate::month(date)) |>
 # Group by id variable and month
 dplyr::group_by(code_muni, month) |>
 # Compute windspeed indicators
 summarise_windspeed(value_var = value, normals_df = normals) |>
 # Ungroup
 dplyr::ungroup()
#> # A tibble: 48 × 20
#>    code_muni month count normal_mean normal_p10 normal_p90  mean median    sd
#>        <int> <dbl> <int>       <dbl>      <dbl>      <dbl> <dbl>  <dbl> <dbl>
#>  1   3106200     1 58590       1.14       0.645       1.57  1.20  1.11  0.465
#>  2   3106200     2 53370       0.934      0.531       1.35  1.20  1.12  0.455
#>  3   3106200     3 58590       1.33       0.727       2.15  1.14  1.03  0.475
#>  4   3106200     4 56700       1.17       0.811       1.52  1.15  1.04  0.486
#>  5   3106200     5 58590       1.01       0.530       1.35  1.11  0.997 0.483
#>  6   3106200     6 56700       1.37       0.587       2.02  1.13  1.02  0.498
#>  7   3106200     7 58590       1.27       0.792       1.66  1.22  1.12  0.530
#>  8   3106200     8 58590       1.41       0.796       1.94  1.41  1.31  0.586
#>  9   3106200     9 56700       1.35       0.727       2.20  1.54  1.44  0.595
#> 10   3106200    10 58590       1.98       1.26        2.72  1.45  1.33  0.596
#> # ℹ 38 more rows
#> # ℹ 11 more variables: se <dbl>, max <dbl>, min <dbl>, p10 <dbl>, p25 <dbl>,
#> #   p75 <dbl>, p90 <dbl>, l_u2_3 <int>, l_u2_5 <int>, h_u2_3 <int>,
#> #   h_u2_5 <int>
```
