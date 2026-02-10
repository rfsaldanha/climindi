#' Compute relative humidity indicators from grouped data
#'
#' The function computes relative humidity indicators from grouped data. Expects relative humidity in percentage.
#'
#' @details
#' The dry and wet spells indicators are computed based on climatological normals, created with the `summarise_normal()` function and passed with the `normals_df` argument. Keys to join the normals data must be present (like id, year, and month)  and use the same names.
#' The variables `ds3`, `ds5`, `ws3` and `ws5` must be present in the dataset. Those variables can be computed with the `add_wave()` function. Plase follow this function example for the correct arguments.
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
#'  \item{`ds3` Count of dry spells occurences, with 3 or more consecutive days with relative humidity bellow the climatological normal value minus 10 percent}
#'  \item{`ds5` Count of dry spells occurences, with 5 or more consecutive days with relative humidity bellow the climatological normal value minus 10 percent}
#'  \item{`ws3` Count of wet spells occurences, with 3 or more consecutive days with relative humidity above the climatological normal value plus 10 percent}
#'  \item{`ws5` Count of wet spells occurences, with 5 or more consecutive days with relative humidity above the climatological normal value plus 10 percent}
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
#'   # Identify month
#'   dplyr::mutate(month = lubridate::month(date)) |>
#'   # Group by id variable and month
#'   dplyr::group_by(code_muni, month) |>
#'   summarise_normal(date_var = date, value_var = value, year_start = 1981, year_end = 2010) |>
#'   dplyr::ungroup()
#'
#' # Compute indicators
#' rel_humidity_data |>
#' dplyr::filter(date >= as.Date("2011-01-01")) |>
#' # Create wave variables
#' dplyr::group_by(code_muni) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = -10,
#'      threshold_cond = "lte",
#'      size = 3,
#'      var_name = "ds3"
#'    ) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = -10,
#'      threshold_cond = "lte",
#'      size = 5,
#'      var_name = "ds5"
#'    ) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = 10,
#'      threshold_cond = "lte",
#'      size = 3,
#'      var_name = "ws3"
#'    ) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = 10,
#'      threshold_cond = "lte",
#'      size = 5,
#'      var_name = "ws5"
#'    ) |>
#'    dplyr::ungroup() |>
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
summarise_rel_humidity <- function(.x, value_var, normals_df) {
  # Assertions
  checkmate::assert_data_frame(x = .x)
  checkmate::assert_true(
    all(c("ds3", "ds5", "ws3", "ws5") %in% names(.x))
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
        ds3 = sum(.data[["ds3"]], na.rm = TRUE),
        ds5 = sum(.data[["ds5"]], na.rm = TRUE),
        ws3 = sum(.data[["ws3"]], na.rm = TRUE),
        ws5 = sum(.data[["ws5"]], na.rm = TRUE),
        dry_days = sum({{ value_var }} <= .data[["normal_p10"]]),
        wet_days = sum({{ value_var }} >= .data[["normal_p90"]]),
        h_30 = sum({{ value_var }} >= 30),
        h_20 = sum({{ value_var }} >= 20),
        h_12 = sum({{ value_var }} >= 12),
        h_21_30 = .data[["h_30"]] - .data[["h_20"]],
        h_12_20 = .data[["h_20"]] - .data[["h_12"]],
        h_11 = sum({{ value_var }} <= 11)
      ) |>
      dplyr::select(-"h_30", -"h_20", -"h_12")
  )
}
