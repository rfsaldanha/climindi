# Compute maximum temperature indicators from grouped data

The function computes maximum temperature indicators from grouped data.
Expects temperature in celsius degrees.

## Usage

``` r
summarise_temp_max(.x, value_var, normals_df)
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

The heat waves indicators are computed based on climatological normals,
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

- `heat_waves_3d` Count of heat waves occurences, with 3 or more
  consecutive days with maximum temperature above the climatological
  normal value plus 5 celsius degrees

- `heat_waves_5d` Count of heat waves occurences, with 5 or more
  consecutive days with maximum temperature above the climatological
  normal value plus 5 celsius degrees

- `hot_days` Count of warm days, when the maximum temperature is above
  the normal 90th percentile

- `t_25` Count of days with temperatures above or equal to 25 celsius
  degrees

- `t_30` Count of days with temperatures above or equal to 30 celsius
  degrees

- `t_35` Count of days with temperatures above or equal to 35 celsius
  degrees

- `t_40` Count of days with temperatures above or equal to 40 celsius
  degrees

## Examples

``` r
# Compute monthly normals
normals <- temp_max_data |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable and month
  dplyr::group_by(code_muni, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()

# Compute indicators
temp_max_data |>
 # Identify year
 dplyr::mutate(year = lubridate::year(date)) |>
 # Identify month
 dplyr::mutate(month = lubridate::month(date)) |>
 # Group by id variable, year and month
 dplyr::group_by(code_muni, year, month) |>
 # Compute maximum temperature indicators
 summarise_temp_max(value_var = value, normals_df = normals) |>
 # Ungroup
 dplyr::ungroup()
#> Error in dplyr::summarise(dplyr::inner_join(.x, normals_df), count = dplyr::n(),     normal_mean = utils::head(.data[["normal_mean"]], 1), normal_p10 = utils::head(.data[["normal_p10"]],         1), normal_p90 = utils::head(.data[["normal_p90"]], 1),     mean = mean({        {            value_var        }    }, na.rm = TRUE), median = stats::median({        {            value_var        }    }, na.rm = TRUE), sd = stats::sd({        {            value_var        }    }, na.rm = TRUE), se = .data[["sd"]]/sqrt(.data[["count"]]),     max = max({        {            value_var        }    }, na.rm = TRUE), min = min({        {            value_var        }    }, na.rm = TRUE), p10 = stats::quantile({        {            value_var        }    }, probs = 0.1, names = FALSE, na.rm = TRUE), p25 = stats::quantile({        {            value_var        }    }, probs = 0.25, names = FALSE, na.rm = TRUE), p75 = stats::quantile({        {            value_var        }    }, probs = 0.75, names = FALSE, na.rm = TRUE), p90 = stats::quantile({        {            value_var        }    }, probs = 0.9, names = FALSE, na.rm = TRUE), hw3 = sum(.data[["hw3"]],         na.rm = TRUE), hw5 = sum(.data[["hw5"]], na.rm = TRUE),     hot_days = sum({        {            value_var        }    } >= .data[["normal_p90"]]), t_25 = sum({        {            value_var        }    } >= 25), t_30 = sum({        {            value_var        }    } >= 30), t_35 = sum({        {            value_var        }    } >= 35), t_40 = sum({        {            value_var        }    } >= 40), ): ℹ In argument: `hw3 = sum(.data[["hw3"]], na.rm = TRUE)`.
#> ℹ In group 1: `code_muni = 3106200`, `year = 1961`, `month = 1`.
#> Caused by error in `.data[["hw3"]]`:
#> ! Column `hw3` not found in `.data`.
```
