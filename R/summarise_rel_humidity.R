#' Compute relative humidity indicators from grouped data
#'
#' The function computes relative humidity indicators from grouped data. Expects relative humidity in percentage.
#' 
#' @details
#' The dry and wet spells indicators are computed based on climatological normals, created with the `summarise_normal()` function and passed with the `normals_df` argument. Keys to join the normals data must be present (like id, year, and month)  and use the same names.
#' 
#' The following indicators are computed for each group.
#' \itemize{
#'  \item{`count` Count of data points}
#'  \item{`normal_mean` Climatological normal mean, from `normals_df` argument}
#'  \item{`normal_p10` Climatological 10th percentile, from `normals_df` argument}
#'  \item{`normal_p90` Climatological 90th percentile, from `normals_df` argument}
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
#'  \item{`dry_spells_3d` Count of dry spells occurences, with 3 or more consecutive days with relative humidity bellow the climatological normal value minus 10 percent}
#'  \item{`dry_spells_5d` Count of dry spells occurences, with 5 or more consecutive days with relative humidity bellow the climatological normal value minus 10 percent}
#'  \item{`wet_spells_3d` Count of wet spells occurences, with 3 or more consecutive days with relative humidity above the climatological normal value plus 10 percent}
#'  \item{`wet_spells_5d` Count of wet spells occurences, with 5 or more consecutive days with relative humidity above the climatological normal value plus 10 percent}
#'  \item{`dry_days` Count of dry days, when the relative humidity is bellow the normal 10th percentile}
#'  \item{`wet_days` Count of wet days, when the relative humidity is above the normal 90th percentile}
#'  \item{`h_21_30` Count of days with relative humidity between 21% and 30%. Attention level}
#'  \item{`h_12_20` Count of days with relative humidity between 12% and 20%. Alert level}
#'  \item{`h_11` Count of days with relative humidity bellow 12%. Emergence level}
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
#' normals <- rel_humidity_data |>
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
#' rel_humidity_data |>
#'  # Identify year
#'  dplyr::mutate(year = lubridate::year(date)) |>
#'  # Identify month
#'  dplyr::mutate(month = lubridate::month(date)) |>
#'  # Group by id variable, year and month
#'  dplyr::group_by(code_muni, year, month) |>
#'  # Compute relative humidity indicators
#'  summarise_rel_humidity(value_var = value, normals_df = normals) |>
#'  # Ungroup
#'  dplyr::ungroup()
#' 
summarise_rel_humidity <- function(.x, value_var, normals_df){
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
      normal_mean = head(.data[["normal_mean"]], 1),
      normal_p10 = head(.data[["normal_p10"]], 1),
      normal_p90 = head(.data[["normal_p90"]], 1),
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
      dry_spells_3d = nseq::trle_cond(x = {{value_var}}, a = 3, a_op = "gte", b = .data[["normal_mean"]] - 10, b_op = "lte"),
      dry_spells_5d = nseq::trle_cond(x = {{value_var}}, a = 5, a_op = "gte", b = .data[["normal_mean"]] - 10, b_op = "lte"),
      wet_spells_3d = nseq::trle_cond(x = {{value_var}}, a = 3, a_op = "gte", b = .data[["normal_mean"]] + 10, b_op = "gte"),
      wet_spells_5d = nseq::trle_cond(x = {{value_var}}, a = 5, a_op = "gte", b = .data[["normal_mean"]] + 10, b_op = "gte"),
      dry_days = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = .data[["normal_p10"]], b_op = "lte"),
      wet_days = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = .data[["normal_p90"]], b_op = "gte"),
      h_30 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 30, b_op = "lte"),
      h_20 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 20, b_op = "lte"),
      h_12 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 12, b_op = "lte"),
      h_21_30 = .data[["h_30"]] - .data[["h_20"]],
      h_12_20 = .data[["h_20"]] - .data[["h_12"]],
      h_11 = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = 11, b_op = "lte"),
    ) |>
    dplyr::select(-"h_30", -"h_20", -"h_12")
  ) 
}

