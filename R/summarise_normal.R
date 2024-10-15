#' Compute normals from grouped data
#'
#' The function computes normals (mean, 10th and 90th percentile) of a variable for each group.
#'
#' @param .x grouped data, created with `dplyr::group_by()`
#' @param date_var name of the variable with dates.
#' @param value_var name of the variable with values.
#' @param year_start starting year of the normal
#' @param year_end ending year of the normal
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' temp_max_data |>
#'   # Identify month
#'   dplyr::mutate(month = lubridate::month(date)) |>
#'   # Group by id variable and month
#'   dplyr::group_by(code_muni, month) |>
#'   summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
#'   dplyr::ungroup()
#' 
summarise_normal <- function(.x, date_var, value_var, year_start, year_end){
  # Assertions
  checkmate::assert_multi_class(x = .x, classes = c("data.frame", "tibble", "multidplyr_party_df"))

  
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
      normal_mean = mean({{value_var}}, na.rm = TRUE),
      normal_p10 = stats::quantile({{value_var}}, probs = 0.10, names = FALSE, na.rm = TRUE),
      normal_p90 = stats::quantile({{value_var}}, probs = 0.90, names = FALSE, na.rm = TRUE)
    )
}