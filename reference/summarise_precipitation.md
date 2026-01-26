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
#> Error in purrr::map(.x = res, .f = iden): ℹ In index: 1.
#> Caused by error in `nseq::trle_cond()`:
#> ! unused argument (pos = TRUE)
```
