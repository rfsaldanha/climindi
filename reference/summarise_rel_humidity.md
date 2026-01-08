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

- `dry_spells_3d` Count of dry spells occurences, with 3 or more
  consecutive days with relative humidity bellow the climatological
  normal value minus 10 percent

- `dry_spells_5d` Count of dry spells occurences, with 5 or more
  consecutive days with relative humidity bellow the climatological
  normal value minus 10 percent

- `wet_spells_3d` Count of wet spells occurences, with 3 or more
  consecutive days with relative humidity above the climatological
  normal value plus 10 percent

- `wet_spells_5d` Count of wet spells occurences, with 5 or more
  consecutive days with relative humidity above the climatological
  normal value plus 10 percent

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
#> # A tibble: 3,024 × 26
#>    code_muni  year month count normal_mean normal_p10 normal_p90  mean median
#>        <int> <dbl> <dbl> <int>       <dbl>      <dbl>      <dbl> <dbl>  <dbl>
#>  1   3106200  1961     1    31        78.4       65.9       90.4  88.0   88.8
#>  2   3106200  1961     2    28        77.4       68.3       88.3  80.6   80.1
#>  3   3106200  1961     3    31        77.2       68.6       87.2  78.9   79.0
#>  4   3106200  1961     4    30        77.0       69.8       84.5  76.1   74.9
#>  5   3106200  1961     5    31        76.1       68.5       83.6  76.8   76.8
#>  6   3106200  1961     6    30        74.8       68.1       81.3  75.6   76.0
#>  7   3106200  1961     7    31        72.3       64.6       79.9  69.7   69.9
#>  8   3106200  1961     8    31        67.2       57.5       77.5  61.0   60.5
#>  9   3106200  1961     9    30        67.2       53.8       81.5  57.6   56.8
#> 10   3106200  1961    10    31        72.2       58.2       85.9  65.3   63.3
#> # ℹ 3,014 more rows
#> # ℹ 17 more variables: sd <dbl>, se <dbl>, max <dbl>, min <dbl>, p10 <dbl>,
#> #   p25 <dbl>, p75 <dbl>, p90 <dbl>, dry_spells_3d <int>, dry_spells_5d <int>,
#> #   wet_spells_3d <int>, wet_spells_5d <int>, dry_days <int>, wet_days <int>,
#> #   h_21_30 <int>, h_12_20 <int>, h_11 <int>
```
