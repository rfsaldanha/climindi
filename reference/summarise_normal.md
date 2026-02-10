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
  summarise_normal(date_var = date, value_var = value, year_start = 1981, year_end = 2010) |>
  dplyr::ungroup()
#> # A tibble: 48 × 5
#>    code_muni month normal_mean normal_p10 normal_p90
#>        <int> <dbl>       <dbl>      <dbl>      <dbl>
#>  1   3106200     1        26.1       22.7       28.6
#>  2   3106200     2        26.9       24.4       29.1
#>  3   3106200     3        26.1       23.4       28.4
#>  4   3106200     4        25.2       22.5       27.8
#>  5   3106200     5        23.7       20.9       26.3
#>  6   3106200     6        22.7       20.0       25.0
#>  7   3106200     7        22.7       19.7       25.2
#>  8   3106200     8        24.3       20.9       27.6
#>  9   3106200     9        25.6       21.2       29.6
#> 10   3106200    10        26.3       22.0       30.3
#> # ℹ 38 more rows
```
