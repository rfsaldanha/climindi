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
#> Error in dplyr::summarise(dplyr::inner_join(.x, normals_df), count = dplyr::n(),     normal_mean = utils::head(.data[["normal_mean"]], 1), normal_p10 = utils::head(.data[["normal_p10"]],         1), normal_p90 = utils::head(.data[["normal_p90"]], 1),     mean = mean({        {            value_var        }    }, na.rm = TRUE), median = stats::median({        {            value_var        }    }, na.rm = TRUE), sd = stats::sd({        {            value_var        }    }, na.rm = TRUE), se = .data[["sd"]]/sqrt(.data[["count"]]),     max = max({        {            value_var        }    }, na.rm = TRUE), min = min({        {            value_var        }    }, na.rm = TRUE), p10 = stats::quantile({        {            value_var        }    }, probs = 0.1, names = FALSE, na.rm = TRUE), p25 = stats::quantile({        {            value_var        }    }, probs = 0.25, names = FALSE, na.rm = TRUE), p75 = stats::quantile({        {            value_var        }    }, probs = 0.75, names = FALSE, na.rm = TRUE), p90 = stats::quantile({        {            value_var        }    }, probs = 0.9, names = FALSE, na.rm = TRUE), rs3 = sum(.data[["rs3"]],         na.rm = TRUE), rs5 = sum(.data[["rs5"]], na.rm = TRUE),     p_1 = sum({        {            value_var        }    } >= 1), p_5 = sum({        {            value_var        }    } >= 5), p_10 = sum({        {            value_var        }    } >= 10), p_50 = sum({        {            value_var        }    } >= 50), p_100 = sum({        {            value_var        }    } >= 100), d_3 = nseq::trle_cond(x = {        {            value_var        }    }, a = 3, a_op = "gte", b = 0, b_op = "e"), d_5 = nseq::trle_cond(x = {        {            value_var        }    }, a = 5, a_op = "gte", b = 0, b_op = "e"), d_10 = nseq::trle_cond(x = {        {            value_var        }    }, a = 10, a_op = "gte", b = 0, b_op = "e"), d_15 = nseq::trle_cond(x = {        {            value_var        }    }, a = 15, a_op = "gte", b = 0, b_op = "e"), d_20 = nseq::trle_cond(x = {        {            value_var        }    }, a = 20, a_op = "gte", b = 0, b_op = "e"), d_25 = nseq::trle_cond(x = {        {            value_var        }    }, a = 25, a_op = "gte", b = 0, b_op = "e"), ): ℹ In argument: `rs3 = sum(.data[["rs3"]], na.rm = TRUE)`.
#> ℹ In group 1: `code_muni = 3106200`, `year = 1961`, `month = 1`.
#> Caused by error in `.data[["rs3"]]`:
#> ! Column `rs3` not found in `.data`.
```
