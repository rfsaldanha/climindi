# Compute precipitation indicators from grouped data

The function computes precipitation indicators from grouped data.
Expects precipitation in millimeters (mm).

## Usage

``` r
summarise_precipitation(.x, value_var, normals_df)
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

The rain spells indicators are computed based on climatological normals,
created with the
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

- `rain_spells_3d` Count of rain spells occurences, with 3 or more
  consecutive days with rain above the climatological normal average
  value

- `rain_spells_5d` Count of rain spells occurences, with 5 or more
  consecutive days with rain above the climatological normal average
  value

- `p_1` Count of days with precipitation above 1mm

- `p_5` Count of days with precipitation above 5mm

- `p_10` Count of days with precipitation above 10mm

- `p_50` Count of days with precipitation above 50mm

- `p_100` Count of days with precipitation above 100mm

- `d_3` Count of sequences of 3 days or more without precipitation

- `d_5` Count of sequences of 5 days or more without precipitation

- `d_10` Count of sequences of 10 days or more without precipitation

- `d_15` Count of sequences of 15 days or more without precipitation

- `d_20` Count of sequences of 20 days or more without precipitation

- `d_25` Count of sequences of 25 days or more without precipitation

## Examples

``` r
# Compute monthly normals
normals <- precipitation_data |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable and month
  dplyr::group_by(code_muni, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()

# Compute indicators
precipitation_data |>
 # Identify year
 dplyr::mutate(year = lubridate::year(date)) |>
 # Identify month
 dplyr::mutate(month = lubridate::month(date)) |>
 # Group by id variable, year and month
 dplyr::group_by(code_muni, year, month) |>
 # Compute precipitation indicators
 summarise_precipitation(value_var = value, normals_df = normals) |>
 # Ungroup
 dplyr::ungroup()
#> # A tibble: 3,024 × 30
#>    code_muni  year month count normal_mean normal_p10 normal_p90     mean median
#>        <int> <dbl> <dbl> <int>       <dbl>      <dbl>      <dbl>    <dbl>  <dbl>
#>  1   3106200  1961     1    31      10.1            0     29.8    2.33e+1 13.0  
#>  2   3106200  1961     2    28       6.88           0     21.4    8.75e+0  0.741
#>  3   3106200  1961     3    31       5.26           0     16.8    6.71e+0  0.668
#>  4   3106200  1961     4    30       2.12           0      5.86   1.64e+0  0    
#>  5   3106200  1961     5    31       0.986          0      2.08   4.18e-1  0    
#>  6   3106200  1961     6    30       0.521          0      0.321  1.14e-1  0    
#>  7   3106200  1961     7    31       0.565          0      0.345  1.93e-1  0    
#>  8   3106200  1961     8    31       0.489          0      0.269  4.72e-4  0    
#>  9   3106200  1961     9    30       1.40           0      3.12   0        0    
#> 10   3106200  1961    10    31       4.29           0     15.7    1.19e+0  0    
#> # ℹ 3,014 more rows
#> # ℹ 21 more variables: sd <dbl>, se <dbl>, max <dbl>, min <dbl>, p10 <dbl>,
#> #   p25 <dbl>, p75 <dbl>, p90 <dbl>, rain_spells_3d <int>,
#> #   rain_spells_5d <int>, p_1 <int>, p_5 <int>, p_10 <int>, p_50 <int>,
#> #   p_100 <int>, d_3 <int>, d_5 <int>, d_10 <int>, d_15 <int>, d_20 <int>,
#> #   d_25 <int>
```
