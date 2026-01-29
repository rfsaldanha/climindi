#' Compute windspeed indicators from grouped data
#'
#' The function computes windspeed (u2) indicators from grouped data. Expects windspeed in meters per second (m/s).
#'
#' @details
#' The high and low u2 indicators are computed based on climatological normals, created with the `summarise_normal()` function and passed with the `normals_df` argument. Keys to join the normals data must be present (like id, year, and month)  and use the same names.
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
#'  \item{`l_eto_3` Count of sequences of 3 days or more with windspeed bellow the climatological normal}
#'  \item{`l_eto_5` Count of sequences of 5 days or more with windspeed bellow the climatological normal}
#'  \item{`h_eto_3` Count of sequences of 3 days or more with windspeed above the climatological normal}
#'  \item{`h_eto_5` Count of sequences of 5 days or more with windspeed above the climatological normal}
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
#' normals <- windspeed_data |>
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
#' windspeed_data |>
#'  # Identify month
#'  dplyr::mutate(month = lubridate::month(date)) |>
#'  # Group by id variable and month
#'  dplyr::group_by(code_muni, month) |>
#'  # Compute windspeed indicators
#'  summarise_windspeed(value_var = value, normals_df = normals) |>
#'  # Ungroup
#'  dplyr::ungroup()
#'
summarise_windspeed <- function(.x, value_var, normals_df) {
  # Assertions
  checkmate::assert_data_frame(x = .x)

  # Assert group
  if (!dplyr::is_grouped_df(.x)) {
    (stop(".x must be a grouped data frame"))
  }

  # Compute indicators
  suppressMessages(
    .x |>
      dplyr::inner_join(normals_df) |>
      dplyr::summarise(
        count = dplyr::n(),
        normal_mean = utils::head(.data[["normal_mean"]], 1),
        normal_p10 = utils::head(.data[["normal_p10"]], 1),
        normal_p90 = utils::head(.data[["normal_p90"]], 1),
        mean = mean({{ value_var }}, na.rm = TRUE),
        median = stats::median({{ value_var }}, na.rm = TRUE),
        sd = stats::sd({{ value_var }}, na.rm = TRUE),
        se = .data[["sd"]] / sqrt(.data[["count"]]),
        max = max({{ value_var }}, na.rm = TRUE),
        min = min({{ value_var }}, na.rm = TRUE),
        p10 = stats::quantile(
          {{ value_var }},
          probs = 0.10,
          names = FALSE,
          na.rm = TRUE
        ),
        p25 = stats::quantile(
          {{ value_var }},
          probs = 0.25,
          names = FALSE,
          na.rm = TRUE
        ),
        p75 = stats::quantile(
          {{ value_var }},
          probs = 0.75,
          names = FALSE,
          na.rm = TRUE
        ),
        p90 = stats::quantile(
          {{ value_var }},
          probs = 0.90,
          names = FALSE,
          na.rm = TRUE
        ),
        #p10_w = caTools::runquantile({{value_var}}, k = 5, p = 0.1)[1],
        #p90_w = caTools::runquantile({{value_var}}, k = 5, p = 0.9)[1],
        l_u2_3 = sum(.data[["l_u2_3"]], na.rm = TRUE),
        l_u2_5 = sum(.data[["l_u2_5"]], na.rm = TRUE),
        h_u2_3 = sum(.data[["h_u2_3"]], na.rm = TRUE),
        h_u2_5 = sum(.data[["h_u2_5"]], na.rm = TRUE),
        b0 = sum(ifelse({{ value_var }} < 2, 1, 0), na.rm = TRUE),
        b1 = sum(
          ifelse({{ value_var }} >= 2 & {{ value_var }} <= 5, 1, 0),
          na.rm = TRUE
        ),
        b2 = sum(
          ifelse({{ value_var }} >= 6 & {{ value_var }} <= 11, 1, 0),
          na.rm = TRUE
        ),
        b3 = sum(
          ifelse({{ value_var }} >= 12 & {{ value_var }} <= 19, 1, 0),
          na.rm = TRUE
        ),
        b4 = sum(
          ifelse({{ value_var }} >= 20 & {{ value_var }} <= 28, 1, 0),
          na.rm = TRUE
        ),
        b5 = sum(
          ifelse({{ value_var }} >= 29 & {{ value_var }} <= 38, 1, 0),
          na.rm = TRUE
        ),
        b6 = sum(
          ifelse({{ value_var }} >= 39 & {{ value_var }} <= 49, 1, 0),
          na.rm = TRUE
        ),
        b7 = sum(
          ifelse({{ value_var }} >= 50 & {{ value_var }} <= 61, 1, 0),
          na.rm = TRUE
        ),
        b8 = sum(
          ifelse({{ value_var }} >= 62 & {{ value_var }} <= 74, 1, 0),
          na.rm = TRUE
        ),
        b9 = sum(
          ifelse({{ value_var }} >= 75 & {{ value_var }} <= 88, 1, 0),
          na.rm = TRUE
        ),
        b10 = sum(
          ifelse({{ value_var }} >= 89 & {{ value_var }} <= 102, 1, 0),
          na.rm = TRUE
        ),
        b11 = sum(
          ifelse({{ value_var }} >= 103 & {{ value_var }} <= 117, 1, 0),
          na.rm = TRUE
        ),
        b12 = sum(
          ifelse({{ value_var }} >= 118, 1, 0),
          na.rm = TRUE
        )
      )
  )
}
