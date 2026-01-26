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
#> Error in dplyr::summarise(dplyr::inner_join(.x, normals_df), count = dplyr::n(),     normal_mean = utils::head(.data[["normal_mean"]], 1), normal_p10 = utils::head(.data[["normal_p10"]],         1), normal_p90 = utils::head(.data[["normal_p90"]], 1),     mean = mean({        {            value_var        }    }, na.rm = TRUE), median = stats::median({        {            value_var        }    }, na.rm = TRUE), sd = stats::sd({        {            value_var        }    }, na.rm = TRUE), se = .data[["sd"]]/sqrt(.data[["count"]]),     max = max({        {            value_var        }    }, na.rm = TRUE), min = min({        {            value_var        }    }, na.rm = TRUE), p10 = stats::quantile({        {            value_var        }    }, probs = 0.1, names = FALSE, na.rm = TRUE), p25 = stats::quantile({        {            value_var        }    }, probs = 0.25, names = FALSE, na.rm = TRUE), p75 = stats::quantile({        {            value_var        }    }, probs = 0.75, names = FALSE, na.rm = TRUE), p90 = stats::quantile({        {            value_var        }    }, probs = 0.9, names = FALSE, na.rm = TRUE), cw3 = sum(.data[["cw3"]],         na.rm = TRUE), cw5 = sum(.data[["cw5"]], na.rm = TRUE),     cold_days = sum({        {            value_var        }    } <= .data[["normal_p10"]]), t_0 = sum({        {            value_var        }    } <= 0), t_5 = sum({        {            value_var        }    } <= 5), t_10 = sum({        {            value_var        }    } <= 10), t_15 = sum({        {            value_var        }    } <= 15), t_20 = sum({        {            value_var        }    } <= 20), ): ℹ In argument: `cw3 = sum(.data[["cw3"]], na.rm = TRUE)`.
#> ℹ In group 1: `code_muni = 3106200`, `year = 1961`, `month = 1`.
#> Caused by error in `.data[["cw3"]]`:
#> ! Column `cw3` not found in `.data`.
```
