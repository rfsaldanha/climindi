compute_normals <- function(.x, value_var = NULL, keys){
  # Assertions
  checkmate::assert_tibble(x = .x)
  #checkmate::assert_choice(x = keys, choices = names(.x))

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
    dplyr::summarise(
      avg = mean(!!dplyr::sym(value_var), na.rm = TRUE),
      sd = sd(!!dplyr::sym(value_var), na.rm = TRUE),
      se = sd/sqrt(dplyr::n()),
      max = max(!!dplyr::sym(value_var), na.rm = TRUE),
      min = min(!!dplyr::sym(value_var), na.rm = TRUE),
      n = dplyr::n(),
      .by = dplyr::all_of(keys)
    )
}
