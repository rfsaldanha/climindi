#' Compute maximum temperature indicators from grouped data
#'
#' The function computes several maximum temperature indicators from grouped data.
#'
#' @param .x grouped data, created with `dplyr::group_by()`
#' @param value_var name of the variable with temperature values.
#' @param normals_df normals data, created with `summarise_normal()`
#' @param id_var id variable to join normals with temperature data
#'
#' @return A tibble.
#' @export
#' @importFrom rlang .data
#'
#' @examples
#' # Compute normals
#' normals <- temp_max_data |>
#'   dplyr::mutate(value = value - 273.15) |>
#'   dplyr::group_by(code_muni) |>
#'   summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
#'   dplyr::ungroup()
#' 
#' temp_max_data |>
#'  # Kelvin to celsius
#'  dplyr::mutate(value = value - 273.15) |>
#'  # Identify year
#'  dplyr::mutate(year = lubridate::year(date)) |>
#'  # Group by municipality code and year
#'  dplyr::group_by(code_muni, year) |>
#'  # Compute temperature indicators
#'  summarise_temp_max(value_var = value, normals_df = normals, id_var = "code_muni") |>
#'  # Ungroup
#'  dplyr::ungroup()
#' 
summarise_temp_max <- function(.x, value_var, normals_df, id_var){
  # Assertions
  checkmate::assert_data_frame(x = .x)

  # Assert group
  if(!dplyr::is_grouped_df(.x))(
    stop(".x must be a grouped data frame")
  )

  # Compute indicators
  .x |>
    dplyr::inner_join(normals_df, by = {{id_var}}) |>
    dplyr::summarise(
      n = dplyr::n(),
      normal = mean(.data[["normal"]], na.rm = TRUE),
      avg = mean({{value_var}}, na.rm = TRUE),
      sd = stats::sd({{value_var}}, na.rm = TRUE),
      se = .data[["sd"]]/sqrt(.data[["n"]]),
      max = max({{value_var}}, na.rm = TRUE),
      min = min({{value_var}}, na.rm = TRUE),
      p10 = caTools::runquantile({{value_var}}, k = 5, p = 0.1)[1],
      p90 = caTools::runquantile({{value_var}}, k = 5, p = 0.9)[1],
      heat_waves = nseq::trle_cond(x = {{value_var}}, a = 5, a_op = "gte", b = .data[["normal"]] + 5, b_op = "gte"),
      tx90p = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = .data[["p90"]], b_op = "gte"),
    )
}







