#' Compute solar radiation indicators from grouped data
#'
#' The function computes solar radiation indicators from grouped data. Expects solar radiation in MJm-2.
#' 
#' The following indicators are computed for each group.
#' \itemize{
#'  \item{`count` Count of data points}
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
#'  \item{`dark_3` Count of sequences of 3 days or more with solar radiation bellow 5}
#'  \item{`dark_5` Count of sequences of 5 days or more with solar radiation bellow 5}
#'  \item{`light_3` Count of sequences of 3 days or more with solar radiation above 25}
#'  \item{`light_5` Count of sequences of 5 days or more with solar radiation above 25}
#' }
#' 
#' @param .x grouped data, created with `dplyr::group_by()`
#' @param value_var name of the variable with temperature values.
#'
#' @return A tibble.
#' @export
#' @importFrom rlang .data
#'
#' @examples
#' # Compute indicators
#' solar_radiation_data |>
#'  # Identify year
#'  dplyr::mutate(year = lubridate::year(date)) |>
#'  # Identify month
#'  dplyr::mutate(month = lubridate::month(date)) |>
#'  # Group by id variable, year and month
#'  dplyr::group_by(code_muni, year, month) |>
#'  # Compute precipitation indicators
#'  summarise_solar_radiation(value_var = value) |>
#'  # Ungroup
#'  dplyr::ungroup()
#' 
summarise_solar_radiation <- function(.x, value_var){
  # Assertions
  checkmate::assert_data_frame(x = .x)

  # Assert group
  if(!dplyr::is_grouped_df(.x))(
    stop(".x must be a grouped data frame")
  )

  # Compute indicators
  suppressMessages(
    .x |>
    dplyr::summarise(
      count = dplyr::n(),
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
      dark_3 = nseq::trle_cond(x = {{value_var}}, a = 3, a_op = "gte", b = 5, b_op = "lte"),
      dark_5 = nseq::trle_cond(x = {{value_var}}, a = 5, a_op = "gte", b = 5, b_op = "lte"),
      light_3 = nseq::trle_cond(x = {{value_var}}, a = 3, a_op = "gte", b = 25, b_op = "gte"),
      light_5 = nseq::trle_cond(x = {{value_var}}, a = 5, a_op = "gte", b = 25, b_op = "gte"),
    )
  ) 
}

