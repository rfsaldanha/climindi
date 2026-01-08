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
#> # A tibble: 3,024 × 25
#>    code_muni  year month count normal_mean normal_p10 normal_p90  mean median
#>        <int> <dbl> <dbl> <int>       <dbl>      <dbl>      <dbl> <dbl>  <dbl>
#>  1   3106200  1961     1    31        18.1      16.5        19.6  18.1   18.4
#>  2   3106200  1961     2    28        18.4      17.1        19.8  18.5   18.6
#>  3   3106200  1961     3    31        18.0      16.3        19.5  17.9   18.4
#>  4   3106200  1961     4    30        16.3      13.6        18.6  16.6   16.8
#>  5   3106200  1961     5    31        14.0      10.8        16.7  14.2   14.2
#>  6   3106200  1961     6    30        12.3       9.18       15.0  12.9   13.1
#>  7   3106200  1961     7    31        11.9       8.95       14.4  12.0   12.2
#>  8   3106200  1961     8    31        13.2      10.8        15.8  13.0   12.5
#>  9   3106200  1961     9    30        15.3      12.7        17.6  16.5   16.4
#> 10   3106200  1961    10    31        16.9      14.5        18.9  17.2   17.1
#> # ℹ 3,014 more rows
#> # ℹ 16 more variables: sd <dbl>, se <dbl>, max <dbl>, min <dbl>, p10 <dbl>,
#> #   p25 <dbl>, p75 <dbl>, p90 <dbl>, cold_spells_3d <int>,
#> #   cold_spells_5d <int>, cold_days <int>, t_0 <int>, t_5 <int>, t_10 <int>,
#> #   t_15 <int>, t_20 <int>
```
