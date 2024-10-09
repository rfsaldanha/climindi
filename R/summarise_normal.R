summarise_normal <- function(.x, date_var, value_var, year_start, year_end){
  # Assertions
  checkmate::assert_data_frame(x = .x)

  # Assert group
  if(!dplyr::is_grouped_df(.x))(
    stop(".x must be a grouped data frame")
  )

  .x |>
    dplyr::filter(
      lubridate::year({{date_var}}) >= year_start,
      lubridate::year({{date_var}}) <= year_end,
    ) |>
    dplyr::summarise(
      normal = mean({{value_var}}, na.rm = TRUE)
    )
}