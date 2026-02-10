#' Compute maximum temperature indicators from grouped data
#'
#' The function computes maximum temperature indicators from grouped data. Expects temperature in celsius degrees.
#'
#' @details
#' The heat waves indicators are computed based on climatological normals, created with the `summarise_normal()` function and passed with the `normals_df` argument. Keys to join the normals data must be present (like id, year, and month)  and use the same names.
#' The variables `hw3` and `hw5` must be present in the dataset. Those variables can be computed with the `add_wave()` function. Plase follow this function example for the correct arguments.
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
#'  \item{`hw3` Count of heat waves occurences, with 3 or more consecutive days with maximum temperature above the climatological normal value plus 5 celsius degrees}
#'  \item{`hw5` Count of heat waves occurences, with 5 or more consecutive days with maximum temperature above the climatological normal value plus 5 celsius degrees}
#'  \item{`hot_days` Count of warm days, when the maximum temperature is above the normal 90th percentile}
#'  \item{`t_25` Count of days with temperatures above or equal to 25 celsius degrees}
#'  \item{`t_30` Count of days with temperatures above or equal to 30 celsius degrees}
#'  \item{`t_35` Count of days with temperatures above or equal to 35 celsius degrees}
#'  \item{`t_40` Count of days with temperatures above or equal to 40 celsius degrees}
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
#' normals <- temp_max_data |>
#'   # Identify month
#'   dplyr::mutate(month = lubridate::month(date)) |>
#'   # Group by id variable and month
#'   dplyr::group_by(code_muni, month) |>
#'   summarise_normal(date_var = date, value_var = value, year_start = 1981, year_end = 2010) |>
#'   dplyr::ungroup()
#'
#' # Compute indicators
#' temp_max_data |>
#' dplyr::filter(date >= as.Date("2011-01-01")) |>
#' # Create wave variables
#' dplyr::group_by(code_muni) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = 5,
#'      threshold_cond = "gte",
#'      size = 3,
#'      var_name = "hw3"
#'    ) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = 5,
#'      threshold_cond = "gte",
#'      size = 5,
#'      var_name = "hw5"
#'    ) |>
#'    dplyr::ungroup() |>
#'  # Identify year
#'  dplyr::mutate(year = lubridate::year(date)) |>
#'  # Identify month
#'  dplyr::mutate(month = lubridate::month(date)) |>
#'  # Group by id variable, year and month
#'  dplyr::group_by(code_muni, year, month) |>
#'  # Compute maximum temperature indicators
#'  summarise_temp_max(value_var = value, normals_df = normals) |>
#'  # Ungroup
#'  dplyr::ungroup()
#'
summarise_temp_max <- function(.x, value_var, normals_df) {
  # Assertions
  checkmate::assert_data_frame(x = .x)
  checkmate::assert_true(
    all(c("hw3", "hw5") %in% names(.x))
  )

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
        normal_mean = utils::head("normal_mean", 1),
        normal_p10 = utils::head("normal_p10", 1),
        normal_p90 = utils::head("normal_p90", 1),
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
        hw3 = sum(.data[["hw3"]], na.rm = TRUE),
        hw5 = sum(.data[["hw5"]], na.rm = TRUE),
        hot_days = sum({{ value_var }} >= .data[["normal_p90"]]),
        t_25 = sum({{ value_var }} >= 25),
        t_30 = sum({{ value_var }} >= 30),
        t_35 = sum({{ value_var }} >= 35),
        t_40 = sum({{ value_var }} >= 40),
      )
  )
}
