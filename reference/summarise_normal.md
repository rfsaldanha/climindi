# Compute normals from grouped data

The function computes normals (mean, 10th and 90th percentile) of a
variable for each group.

## Usage

``` r
summarise_normal(.x, date_var, value_var, year_start, year_end)
```

## Arguments

- .x:

  grouped data, created with
  [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)

- date_var:

  name of the variable with dates.

- value_var:

  name of the variable with values.

- year_start:

  starting year of the normal

- year_end:

  ending year of the normal

## Value

A tibble.

## Examples

``` r
temp_max_data |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable and month
  dplyr::group_by(code_muni, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()
#> # A tibble: 48 × 5
#>    code_muni month normal_mean normal_p10 normal_p90
#>        <int> <dbl>       <dbl>      <dbl>      <dbl>
#>  1   3106200     1        27.9       24.0       31.2
#>  2   3106200     2        28.5       25.5       30.9
#>  3   3106200     3        28.3       25.4       30.9
#>  4   3106200     4        27.2       24.6       29.6
#>  5   3106200     5        25.8       22.8       28.3
#>  6   3106200     6        24.7       21.9       27.3
#>  7   3106200     7        24.4       20.9       27.2
#>  8   3106200     8        26.1       22.2       29.8
#>  9   3106200     9        27.1       22.6       31.1
#> 10   3106200    10        27.5       23.0       31.5
#> # ℹ 38 more rows
```
