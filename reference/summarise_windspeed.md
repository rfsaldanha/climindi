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
#> Error in dplyr::summarise(dplyr::inner_join(.x, normals_df), count = dplyr::n(),     normal_mean = utils::head(.data[["normal_mean"]], 1), normal_p10 = utils::head(.data[["normal_p10"]],         1), normal_p90 = utils::head(.data[["normal_p90"]], 1),     mean = mean({        {            value_var        }    }, na.rm = TRUE), median = stats::median({        {            value_var        }    }, na.rm = TRUE), sd = stats::sd({        {            value_var        }    }, na.rm = TRUE), se = .data[["sd"]]/sqrt(.data[["count"]]),     max = max({        {            value_var        }    }, na.rm = TRUE), min = min({        {            value_var        }    }, na.rm = TRUE), p10 = stats::quantile({        {            value_var        }    }, probs = 0.1, names = FALSE, na.rm = TRUE), p25 = stats::quantile({        {            value_var        }    }, probs = 0.25, names = FALSE, na.rm = TRUE), p75 = stats::quantile({        {            value_var        }    }, probs = 0.75, names = FALSE, na.rm = TRUE), p90 = stats::quantile({        {            value_var        }    }, probs = 0.9, names = FALSE, na.rm = TRUE), l_u2_3 = sum(.data[["l_u2_3"]],         na.rm = TRUE), l_u2_5 = sum(.data[["l_u2_5"]], na.rm = TRUE),     h_u2_3 = sum(.data[["h_u2_3"]], na.rm = TRUE), h_u2_5 = sum(.data[["h_u2_5"]],         na.rm = TRUE)): ℹ In argument: `l_u2_3 = sum(.data[["l_u2_3"]], na.rm = TRUE)`.
#> ℹ In group 1: `code_muni = 3106200` `month = 1`.
#> Caused by error in `.data[["l_u2_3"]]`:
#> ! Column `l_u2_3` not found in `.data`.
```
