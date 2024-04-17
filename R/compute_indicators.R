compute_indicators <- function(.x, date_var = NULL, value_var = NULL, keys){
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
    dplyr::mutate(year = lubridate::year(!!dplyr::sym(date_var))) |>
    dplyr::mutate(month = lubridate::month(!!dplyr::sym(date_var))) |>
    dplyr::summarise(
      n = dplyr::n(),
      avg = mean(!!dplyr::sym(value_var), na.rm = TRUE),
      sd = sd(!!dplyr::sym(value_var), na.rm = TRUE),
      se = sd/sqrt(n),
      max = max(!!dplyr::sym(value_var), na.rm = TRUE),
      min = min(!!dplyr::sym(value_var), na.rm = TRUE),
      days_a1 = sum(!!dplyr::sym(value_var) > avg + (1 * sd), na.rm = TRUE),
      days_a2 = sum(!!dplyr::sym(value_var) > avg + (2 * sd), na.rm = TRUE),
      days_b1 = sum(!!dplyr::sym(value_var) < avg - (1 * sd), na.rm = TRUE),
      days_b2 = sum(!!dplyr::sym(value_var) < avg - (2 * sd), na.rm = TRUE),
      .by = dplyr::all_of(c(keys, "year", "month"))
    )
}
