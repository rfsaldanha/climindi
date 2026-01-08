# Compute solar radiation indicators from grouped data

The function computes solar radiation indicators from grouped data.
Expects solar radiation in MJm-2.

## Usage

``` r
summarise_solar_radiation(.x, value_var, normals_df)
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

The dark and light days indicators are computed based on climatological
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

- `dark_3` Count of sequences of 3 days or more with solar radiation
  bellow the climatological normal

- `dark_5` Count of sequences of 5 days or more with solar radiation
  bellow the climatological normal

- `light_3` Count of sequences of 3 days or more with solar radiation
  above the climatological normal

- `light_5` Count of sequences of 5 days or more with solar radiation
  above the climatological normal

## Examples

``` r
# Compute monthly normals
normals <- solar_radiation_data |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable and month
  dplyr::group_by(code_muni, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()

# Compute indicators
solar_radiation_data |>
 # Identify year
 dplyr::mutate(year = lubridate::year(date)) |>
 # Identify month
 dplyr::mutate(month = lubridate::month(date)) |>
 # Group by id variable, year and month
 dplyr::group_by(code_muni, year, month) |>
 # Compute solar radiation indicators
 summarise_solar_radiation(value_var = value, normals_df = normals) |>
 # Ungroup
 dplyr::ungroup()
#> # A tibble: 3,024 × 21
#>    code_muni  year month count normal_mean normal_p10 normal_p90  mean median
#>        <int> <dbl> <dbl> <int>       <dbl>      <dbl>      <dbl> <dbl>  <dbl>
#>  1   3106200  1961     1    31        19.6       11.2       27.6  15.3   14.7
#>  2   3106200  1961     2    28        20.2       12.1       26.3  19.3   19.4
#>  3   3106200  1961     3    31        18.7       11.1       23.9  19.7   20.8
#>  4   3106200  1961     4    30        17.2       11.5       20.8  18.9   19.8
#>  5   3106200  1961     5    31        15.2       10.7       18.1  15.4   16.4
#>  6   3106200  1961     6    30        14.4       11.4       16.4  14.9   15.3
#>  7   3106200  1961     7    31        15.1       11.9       17.4  16.2   16.4
#>  8   3106200  1961     8    31        17.1       12.6       20.3  19.1   19.5
#>  9   3106200  1961     9    30        17.8       10.6       22.4  20.2   20.7
#> 10   3106200  1961    10    31        18.3       10.5       24.8  19.4   21.4
#> # ℹ 3,014 more rows
#> # ℹ 12 more variables: sd <dbl>, se <dbl>, max <dbl>, min <dbl>, p10 <dbl>,
#> #   p25 <dbl>, p75 <dbl>, p90 <dbl>, dark_3 <int>, dark_5 <int>, light_3 <int>,
#> #   light_5 <int>
```
