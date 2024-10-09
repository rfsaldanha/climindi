#' @importFrom rlang .data

summarise_temp <- function(.x, id_var, value_var, normals_df){
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
      n = dplyr::n(),
      normal = mean(.data[["normal"]], na.rm = TRUE),
      avg = mean({{value_var}}, na.rm = TRUE),
      sd = stats::sd({{value_var}}, na.rm = TRUE),
      se = .data[["sd"]]/sqrt(.data[["n"]]),
      max = max({{value_var}}, na.rm = TRUE),
      min = min({{value_var}}, na.rm = TRUE),
      p10 = window_percentile({{value_var}}, k = 5, p = 0.1),
      p90 = window_percentile({{value_var}}, k = 5, p = 0.9),
      heat_waves = nseq::trle_cond(x = {{value_var}}, a = 5, a_op = "gte", b = .data[["normal"]] + 5, b_op = "gte"),
      tx90p = nseq::trle_cond(x = {{value_var}}, a = 1, a_op = "gte", b = .data[["p90"]], b_op = "gte"),
    )

}







summarise_temp_old <- function(.x, var, upper_ref){
  # Assertions
  checkmate::assert_data_frame(x = .x)

  # Assert group
  if(!dplyr::is_grouped_df(.x))(
    stop(".x must be a grouped data frame")
  )

  # Compute indicators
  .x |>
    dplyr::summarise(
      n = dplyr::n(),
      avg = mean({{var}}, na.rm = TRUE),
      sd = stats::sd({{var}}, na.rm = TRUE),
      se = .data[["sd"]]/sqrt(.data[["n"]]),
      max = max({{var}}, na.rm = TRUE),
      min = min({{var}}, na.rm = TRUE),
      n_a1 = sum({{var}} > .data[["avg"]] + (1 * .data[["sd"]]), na.rm = TRUE),
      n_a2 = sum({{var}} > .data[["avg"]] + (2 * .data[["sd"]]), na.rm = TRUE),
      n_b1 = sum({{var}} < .data[["avg"]] - (1 * .data[["sd"]]), na.rm = TRUE),
      n_b2 = sum({{var}} < .data[["avg"]] - (2 * .data[["sd"]]), na.rm = TRUE),
      n_c1 = nseq::trle_cond({{var}}, a = 3, b = .data[["avg"]]),
      n_c2 = nseq::trle_cond({{var}}, a = 5, b = .data[["avg"]]),
      n_d1 = nseq::trle_cond({{var}}, a = 3, b_op = "lte", b = .data[["avg"]]),
      n_d2 = nseq::trle_cond({{var}}, a = 5, b_op = "lte", b = .data[["avg"]]),
      n_ar = sum({{var}} > {{upper_ref}}, na.rm = TRUE)
    )
}
