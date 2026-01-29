#' Compute evapotranspirations indicators from grouped data
#'
#' The function computes evapotranspirations (ETo) indicators from grouped data. Expects evapotranspiration in millimeters (mm).
#'
#' @details
#' The high and low ETo indicators are computed based on climatological normals, created with the `summarise_normal()` function and passed with the `normals_df` argument. Keys to join the normals data must be present (like id, year, and month) and use the same names.
#' The variables `l_eto_3`, `l_eto_5`, `h_eto_3` and `lheto_5` must be present in the dataset. Those variables can be computed with the `add_wave()` function. Plase follow this function example for the correct arguments.
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
#'  \item{`l_eto_3` Count of sequences of 3 days or more with evapotranspirations bellow the climatological average normal}
#'  \item{`l_eto_5` Count of sequences of 5 days or more with evapotranspirations bellow the climatological average normal}
#'  \item{`h_eto_3` Count of sequences of 3 days or more with evapotranspirations above the climatological average normal}
#'  \item{`h_eto_5` Count of sequences of 5 days or more with evapotranspirations above the climatological average normal}
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
#' normals <- evapotranspiration_data |>
#'   # Identify month
#'   dplyr::mutate(month = lubridate::month(date)) |>
#'   # Group by id variable and month
#'   dplyr::group_by(code_muni, month) |>
#'   summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
#'   dplyr::ungroup()
#'
#' # Compute indicators
#' evapotranspiration_data |>
#' # Create wave variables
#' dplyr::group_by(code_muni) |>
#'  add_wave(
#'      normals_df = normals,
#'      threshold = 0,
#'      threshold_cond = "lte",
#'      size = 3,
#'      var_name = "l_eto_3"
#'    ) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = 0,
#'      threshold_cond = "lte",
#'      size = 5,
#'      var_name = "l_eto_5"
#'    ) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = 0,
#'      threshold_cond = "gte",
#'      size = 3,
#'      var_name = "h_eto_3"
#'    ) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = 0,
#'      threshold_cond = "gte",
#'      size = 5,
#'      var_name = "h_eto_5"
#'    ) |>
#'    dplyr::ungroup() |>
#'  # Identify year
#'  dplyr::mutate(year = lubridate::year(date)) |>
#'  # Identify month
#'  dplyr::mutate(month = lubridate::month(date)) |>
#'  # Group by id variable, year and month
#'  dplyr::group_by(code_muni, year, month) |>
#'  # Compute evapotranspiration indicators
#'  summarise_evapotrapiration(value_var = value, normals_df = normals) |>
#'  # Ungroup
#'  dplyr::ungroup()
#'
summarise_evapotrapiration <- function(.x, value_var, normals_df) {
  # Assertions
  checkmate::assert_data_frame(x = .x)
  checkmate::assert_true(
    all(c("l_eto_3", "l_eto_5", "h_eto_3", "h_eto_5") %in% names(.x))
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
        l_eto_3 = sum(.data[["l_eto_3"]], na.rm = TRUE),
        l_eto_5 = sum(.data[["l_eto_5"]], na.rm = TRUE),
        h_eto_3 = sum(.data[["h_eto_3"]], na.rm = TRUE),
        h_eto_5 = sum(.data[["h_eto_5"]], na.rm = TRUE)
      )
  )
}
