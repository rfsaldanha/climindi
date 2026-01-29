#' Compute precipitation indicators from grouped data
#'
#' The function computes precipitation indicators from grouped data. Expects precipitation in millimeters (mm).
#'
#' @details
#' The rain spells indicators are computed based on climatological normals, created with the `summarise_normal()` function and passed with the `normals_df` argument. Keys to join the normals data must be present (like id, year, and month)  and use the same names.
#' The variables `rs3` and `rs5` must be present in the dataset. Those variables can be computed with the `add_wave()` function. Plase follow this function example for the correct arguments.
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
#'  \item{`rain_spells_3d` Count of rain spells occurences, with 3 or more consecutive days with rain above the climatological normal average value}
#'  \item{`rain_spells_5d` Count of rain spells occurences, with 5 or more consecutive days with rain above the climatological normal average value}
#'  \item{`p_1` Count of days with precipitation above 1mm}
#'  \item{`p_5` Count of days with precipitation above 5mm}
#'  \item{`p_10` Count of days with precipitation above 10mm}
#'  \item{`p_50` Count of days with precipitation above 50mm}
#'  \item{`p_100` Count of days with precipitation above 100mm}
#'  \item{`d_3` Count of sequences of 3 days or more without precipitation}
#'  \item{`d_5` Count of sequences of 5 days or more without precipitation}
#'  \item{`d_10` Count of sequences of 10 days or more without precipitation}
#'  \item{`d_15` Count of sequences of 15 days or more without precipitation}
#'  \item{`d_20` Count of sequences of 20 days or more without precipitation}
#'  \item{`d_25` Count of sequences of 25 days or more without precipitation}
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
#' normals <- precipitation_data |>
#'   # Identify month
#'   dplyr::mutate(month = lubridate::month(date)) |>
#'   # Group by id variable and month
#'   dplyr::group_by(code_muni, month) |>
#'   summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
#'   dplyr::ungroup()
#'
#' # Compute indicators
#' precipitation_data |>
#' # Create wave variables
#' dplyr::group_by(code_muni) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = 0,
#'      threshold_cond = "gte",
#'      size = 3,
#'      var_name = "rs3"
#'    ) |>
#'    add_wave(
#'      normals_df = normals,
#'      threshold = 0,
#'      threshold_cond = "gte",
#'      size = 5,
#'      var_name = "rs5"
#'    ) |>
#'    dplyr::ungroup() |>
#'  # Identify year
#'  dplyr::mutate(year = lubridate::year(date)) |>
#'  # Identify month
#'  dplyr::mutate(month = lubridate::month(date)) |>
#'  # Group by id variable, year and month
#'  dplyr::group_by(code_muni, year, month) |>
#'  # Compute precipitation indicators
#'  summarise_precipitation(value_var = value, normals_df = normals) |>
#'  # Ungroup
#'  dplyr::ungroup()
#'
summarise_precipitation <- function(.x, value_var, normals_df) {
  # Assertions
  checkmate::assert_data_frame(x = .x)
  checkmate::assert_true(
    all(c("rs3", "rs5") %in% names(.x))
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
        rs3 = sum(.data[["rs3"]], na.rm = TRUE),
        rs5 = sum(.data[["rs5"]], na.rm = TRUE),
        p_1 = sum({{ value_var }} >= 1),
        p_5 = sum({{ value_var }} >= 5),
        p_10 = sum({{ value_var }} >= 10),
        p_50 = sum({{ value_var }} >= 50),
        p_100 = sum({{ value_var }} >= 100),
        d_3 = nseq::trle_cond(
          x = {{ value_var }},
          a = 3,
          a_op = "gte",
          b = 0,
          b_op = "e"
        ),
        d_5 = nseq::trle_cond(
          x = {{ value_var }},
          a = 5,
          a_op = "gte",
          b = 0,
          b_op = "e"
        ),
        d_10 = nseq::trle_cond(
          x = {{ value_var }},
          a = 10,
          a_op = "gte",
          b = 0,
          b_op = "e"
        ),
        d_15 = nseq::trle_cond(
          x = {{ value_var }},
          a = 15,
          a_op = "gte",
          b = 0,
          b_op = "e"
        ),
        d_20 = nseq::trle_cond(
          x = {{ value_var }},
          a = 20,
          a_op = "gte",
          b = 0,
          b_op = "e"
        ),
        d_25 = nseq::trle_cond(
          x = {{ value_var }},
          a = 25,
          a_op = "gte",
          b = 0,
          b_op = "e"
        ),
      )
  )
}
