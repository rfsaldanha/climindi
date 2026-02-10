# Add waves

Detect sequence of events (waves) in a ordered vector considering its
normal values.

## Usage

``` r
add_wave(
  .x,
  normals_df,
  threshold = 5,
  threshold_cond = "gte",
  size = 3,
  var_name = "hw3"
)
```

## Arguments

- .x:

  A data.frame object.

- normals_df:

  A data.frame object with normal values, computed with
  [`summarise_normal()`](https://rfsaldanha.github.io/climindi/reference/summarise_normal.md).

- threshold:

  numeric. A positive of negative threshold value to be added to the
  normal mean value. Use value zero to consider only the normal value.

- threshold_cond:

  string. A threshold condition. Use `gte` for "greather than or equal"
  or `lte` for less than or equal.

- size:

  numeric. Minimum size of the sequence.

- var_name:

  string. Variable name with the outputs result.

## Value

A data.frame with the `var_name` variable with logical values.

## Details

This is a helper function to detect sequence of events in a ordered
vector considering historical normal values.

An event is considered as a sequence of values of a certain size (`size`
argument) that are greather and less than (`threshold_cond` argument) an
historical normal (`normal` argument) plus an threshold (`threshold`
value).

The function will fill the variable `var_name` with `TRUE` if the record
belongs to an event.
