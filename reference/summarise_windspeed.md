# Compute windspeed indicators from grouped data

The function computes windspeed (u2) indicators from grouped data.
Expects windspeed in kilometers per hour (km/h). 1 m/s equals to 3.6
km/h.

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
names. The variables `l_u2_3`, `l_u2_5`, `h_u2_3` and `h_u2_5` must be
present in the dataset. Those variables can be computed with the
[`add_wave()`](https://rfsaldanha.github.io/climindi/reference/add_wave.md)
function. Plase follow this function example for the correct arguments.

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

- `b1`, `b2`, `b3`, `b4`, `b5`, `b6`, `b7`, `b8`, `b9`, `b10`, `b11`,
  `b12` Beaufort scale classifications
