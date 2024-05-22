#' @importFrom rlang .data
summarise_temp <- function(.x, var, upper_ref){
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
