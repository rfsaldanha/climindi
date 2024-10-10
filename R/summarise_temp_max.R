#' Compute maximum temperature indicators from grouped data
#'
#' The function computes maximum temperature indicators from grouped data. Expects temperature in celsius degrees.
#' 
#' @details
#' The following indicators are computed for each group.
#' \itemize{
#'  \item{`count` Count of data points}
#'  \item{`normal` Climatological normal, from `normals_df` argument}
#'  \item{`mean` Average}
#'  \item{`median` Median}
#'  \item{`sd` Standard deviation}
#'  \item{`se` Standard error}
#'  \item{`max` Maximum value}
#'  \item{`min` Minimum value}
#'  \item{`p10` 10th percentile}
#'  \item{`p25` 25th percentile}
#'  \item{`p75` 75th percentile}
#'  \item{`p90` 10th percentile}
#'  \item{`p10_w` 10th percentile from a rolling window of size 5}
#'  \item{`p90_w` 90th percentile from a rolling window of size 5}
#'  \item{`heat_waves` Count of heat waves occurences, 5 or more consecutive days with maximum temperature above the climatological normal value plus 5 celsius degrees}
#'  \item{`tx90p` Count of warm days, days with maximum temperatures above the 90th percentile}
#'  \item{`t_25` Count of days with temperatures above or equal to 25 celsius degrees}
#'  \item{`t_30` Count of days with temperatures above or equal to 30 celsius degrees}
#'  \item{`t_35` Count of days with temperatures above or equal to 35 celsius degrees}
#'  \item{`t_40` Count of days with temperatures above or equal to 40 celsius degrees}
#' }
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
#'   dplyr::group_by(code_muni) |>
#'   summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
#'   dplyr::ungroup()
#' 
#' temp_max_data |>
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
      count = dplyr::n(),
      normal = mean(.data[["normal"]], na.rm = TRUE),
      mean = mean({{value_var}}, na.rm = TRUE),
      median = stats::median({{value_var}}, na.rm = TRUE),
      sd = stats::sd({{value_var}}, na.rm = TRUE),
      se = .data[["sd"]]/sqrt(.data[["count"]]),
      max = max({{value_var}}, na.rm = TRUE),
      min = min({{value_var}}, na.rm = TRUE),
      p_10 = stats::quantile({{value_var}}, probs = 0.10, names = FALSE),
      p_25 = stats::quantile({{value_var}}, probs = 0.25, names = FALSE),
      p_75 = stats::quantile({{value_var}}, probs = 0.75, names = FALSE),
      p_90 = stats::quantile({{value_var}}, probs = 0.90, names = FALSE),
      p10_w = caTools::runquantile({{value_var}}, k = 5, p = 0.1)[1],
      p90_w = caTools::runquantile({{value_var}}, k = 5, p = 0.9)[1],
      heat_waves = nseq::trle_cond(x = {{value_var}}, a = 5, a_op = "gte", b = .data[["normal"]] + 5, b_op = "gte"),
      tx90p = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = .data[["p90_w"]], b_op = "gte"),
      t_25 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 25, b_op = "gte"),
      t_30 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 30, b_op = "gte"),
      t_35 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 35, b_op = "gte"),
      t_40 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 40, b_op = "gte"),
    )
}







