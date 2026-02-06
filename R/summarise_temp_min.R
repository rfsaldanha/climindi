#' Compute minimum temperature indicators from grouped data
#'
#' The function computes minimum temperature indicators from grouped data. Expects temperature in celsius degrees.
#'
#' @details
#' The cold spells indicators are computed based on climatological normals, created with the `summarise_normal()` function and passed with the `normals_df` argument. Keys to join the normals data must be present (like id, year, and month)  and use the same names.
#' The variables `cw3` and `cw5` must be present in the dataset. Those variables can be computed with the `add_wave()` function. Plase follow this function example for the correct arguments.
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
#'  \item{`cold_spells_3d` Count of cold spells occurences, with 3 or more consecutive days with minimum temperature bellow the climatological normal value minus 5 celsius degrees}
#'  \item{`cold_spells_5d` Count of cold spells occurences, with 5 or more consecutive days with minimum temperature bellow the climatological normal value minus 5 celsius degrees}
#'  \item{`cold_days` Count of cold days, when the minimum temperature is bellow the normal 10th percentile}
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
#'   # Identify month
#'   dplyr::mutate(month = lubridate::month(date)) |>
#'   # Group by id variable and month
#'   dplyr::group_by(code_muni, month) |>
#'   summarise_normal(date_var = date, value_var = value, year_start = 1981, year_end = 2010) |>
#'   dplyr::ungroup()
#'
#' # Compute indicators
#' temp_min_data |>
#' dplyr::filter(date >= as.Date("2011-01-01")) |>
#' # Create wave variables
#' dplyr::group_by(code_muni) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = -5,
#'      threshold_cond = "lte",
#'      size = 3,
#'      var_name = "cw3"
#'    ) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = -5,
#'      threshold_cond = "lte",
#'      size = 5,
#'      var_name = "cw5"
#'    ) |>
#'    dplyr::ungroup() |>
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
summarise_temp_min <- function(.x, value_var, normals_df) {
  # Assertions
  checkmate::assert_data_frame(x = .x)
  checkmate::assert_true(
    all(c("cw3", "cw5") %in% names(.x))
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
        cw3 = sum(.data[["cw3"]], na.rm = TRUE),
        cw5 = sum(.data[["cw5"]], na.rm = TRUE),
        cold_days = sum({{ value_var }} <= .data[["normal_p10"]]),
        t_0 = sum({{ value_var }} <= 0),
        t_5 = sum({{ value_var }} <= 5),
        t_10 = sum({{ value_var }} <= 10),
        t_15 = sum({{ value_var }} <= 15),
        t_20 = sum({{ value_var }} <= 20),
      )
  )
}
