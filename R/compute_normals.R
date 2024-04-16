compute_normals <- function(.x, date_var = NULL, value_var = NULL, keys){
  # Assertions
  checkmate::assert_tibble(x = .x)

  # Date variable
  if(is.null(date_var)){
    date_var <- "date"
  }

  # Assert date variable
  checkmate::assert_choice(x = date_var, choices = names(.x))
  checkmate::assert_date(x = get(date_var, .x))

  # Value variable
  if(is.null(value_var)){
    value_var <- "value"
  }

  # Assert value variable
  checkmate::assert_choice(x = value_var, choices = names(.x))
  checkmate::assert_numeric(x = get(value_var, .x))

  # Assert keys
  checkmate::assert_subset(x = keys, choices = names(.x))

  # Compute normals
  .x |>
    dplyr::mutate(month = lubridate::month(!!dplyr::sym(date_var))) |>
    dplyr::summarise(
      avg = mean(!!dplyr::sym(value_var), na.rm = TRUE),
      sd = sd(!!dplyr::sym(value_var), na.rm = TRUE),
      se = sd/sqrt(dplyr::n()),
      max = max(!!dplyr::sym(value_var), na.rm = TRUE),
      min = min(!!dplyr::sym(value_var), na.rm = TRUE),
      n = dplyr::n(),
      .by = dplyr::all_of(c(keys, "interval_label", "date_start", "date_end", "month"))
    )
}
