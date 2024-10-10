#' Compute minimum temperature indicators from grouped data
#'
#' The function computes minimum temperature indicators from grouped data. Expects temperature in celsius degrees.
#' 
#' @details
#' The cold spells indicators are computed based on climatological normals, created with the `summarise_normal()` function and passed with the `normals_df` argument. Keys to join the normals data must be present (like id, year, and month)  and use the same names.
#' 
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
#'  \item{`p90` 90th percentile}
#'  \item{`cold_spells_3d` Count of cold spells occurences, with 3 or more consecutive days with minimum temperature bellow the climatological normal value minus 5 celsius degrees}
#'  \item{`cold_spells_5d` Count of cold spells occurences, with 5 or more consecutive days with minimum temperature bellow the climatological normal value minus 5 celsius degrees}
#'  \item{`cold_days` Count of cold days, when the minimum temperature is bellow the 10th percentile}
#'  \item{`t_0` Count of days with temperatures bellow or equal to 0 celsius degrees}
#'  \item{`t_5` Count of days with temperatures bellow or equal to 5 celsius degrees}
#'  \item{`t_10` Count of days with temperatures bellow or equal to 10 celsius degrees}
#'  \item{`t_15` Count of days with temperatures bellow or equal to 15 celsius degrees}
#'  \item{`t_20` Count of days with temperatures bellow or equal to 20 celsius degrees}
#' }
#' 
#' @param .x grouped data, created with `dplyr::group_by()`
#' @param value_var name of the variable with temperature values.
#' @param normals_df normals data, created with `summarise_normal()`
#'
#' @return A tibble.
#' @export
#' @importFrom rlang .data
#'
#' @examples
#' # Compute monthly normals
#' normals <- temp_min_data |>
#'   # Identify year
#'   dplyr::mutate(year = lubridate::year(date)) |>
#'   # Identify month
#'   dplyr::mutate(month = lubridate::month(date)) |>
#'   # Group by id variable, year and month
#'   dplyr::group_by(code_muni, year, month) |>
#'   summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
#'   dplyr::ungroup()
#' 
#' # Compute indicators
#' temp_min_data |>
#'  # Identify year
#'  dplyr::mutate(year = lubridate::year(date)) |>
#'  # Identify month
#'  dplyr::mutate(month = lubridate::month(date)) |>
#'  # Group by id variable, year and month
#'  dplyr::group_by(code_muni, year, month) |>
#'  # Compute minimum temperature indicators
#'  summarise_temp_min(value_var = value, normals_df = normals) |>
#'  # Ungroup
#'  dplyr::ungroup()
#' 
summarise_temp_min <- function(.x, value_var, normals_df){
  # Assertions
  checkmate::assert_data_frame(x = .x)

  # Assert group
  if(!dplyr::is_grouped_df(.x))(
    stop(".x must be a grouped data frame")
  )

  # Compute indicators
  suppressMessages(
    .x |>
    dplyr::inner_join(normals_df) |>
    dplyr::summarise(
      count = dplyr::n(),
      normal = mean(.data[["normal"]], na.rm = TRUE),
      mean = mean({{value_var}}, na.rm = TRUE),
      median = stats::median({{value_var}}, na.rm = TRUE),
      sd = stats::sd({{value_var}}, na.rm = TRUE),
      se = .data[["sd"]]/sqrt(.data[["count"]]),
      max = max({{value_var}}, na.rm = TRUE),
      min = min({{value_var}}, na.rm = TRUE),
      p10 = stats::quantile({{value_var}}, probs = 0.10, names = FALSE),
      p25 = stats::quantile({{value_var}}, probs = 0.25, names = FALSE),
      p75 = stats::quantile({{value_var}}, probs = 0.75, names = FALSE),
      p90 = stats::quantile({{value_var}}, probs = 0.90, names = FALSE),
      #p10_w = caTools::runquantile({{value_var}}, k = 5, p = 0.1)[1],
      #p90_w = caTools::runquantile({{value_var}}, k = 5, p = 0.9)[1],
      cold_spells_3d = nseq::trle_cond(x = {{value_var}}, a = 3, a_op = "gte", b = .data[["normal"]] - 5, b_op = "lte"),
      cold_spells_5d = nseq::trle_cond(x = {{value_var}}, a = 5, a_op = "gte", b = .data[["normal"]] - 5, b_op = "lte"),
      cold_days = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = .data[["p10"]], b_op = "lte"),
      t_0 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 0, b_op = "lte"),
      t_5 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 5, b_op = "lte"),
      t_10 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 10, b_op = "lte"),
      t_15 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 15, b_op = "lte"),
      t_20 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 20, b_op = "lte"),
    )
  )
  
}

