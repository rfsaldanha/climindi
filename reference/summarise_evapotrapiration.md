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
#> # A tibble: 3,024 × 21
#>    code_muni  year month count normal_mean normal_p10 normal_p90  mean median
#>        <int> <dbl> <dbl> <int>       <dbl>      <dbl>      <dbl> <dbl>  <dbl>
#>  1   3106200  1961     1    31        4.04       2.38       5.59  3.11   3.01
#>  2   3106200  1961     2    28        4.15       2.56       5.31  3.92   3.93
#>  3   3106200  1961     3    31        3.75       2.38       4.73  3.93   4.13
#>  4   3106200  1961     4    30        3.24       2.34       3.91  3.56   3.63
#>  5   3106200  1961     5    31        2.63       1.99       3.12  2.63   2.73
#>  6   3106200  1961     6    30        2.35       1.97       2.67  2.50   2.54
#>  7   3106200  1961     7    31        2.51       2.07       2.93  2.75   2.81
#>  8   3106200  1961     8    31        3.18       2.47       3.83  3.70   3.64
#>  9   3106200  1961     9    30        3.68       2.38       4.60  4.46   4.59
#> 10   3106200  1961    10    31        3.87       2.32       5.16  4.53   4.90
#> # ℹ 3,014 more rows
#> # ℹ 12 more variables: sd <dbl>, se <dbl>, max <dbl>, min <dbl>, p10 <dbl>,
#> #   p25 <dbl>, p75 <dbl>, p90 <dbl>, l_eto_3 <int>, l_eto_5 <int>,
#> #   h_eto_3 <int>, h_eto_5 <int>
```
