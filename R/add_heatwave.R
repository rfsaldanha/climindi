add_heatwave <- function(
  .x,
  date_var,
  normals_df,
  normal_plus = 5,
  size = 3,
  var_name = "hw3"
) {
  # Assertions
  checkmate::assert_data_frame(x = .x)

  # Assert group
  if (!dplyr::is_grouped_df(.x)) {
    (stop(".x must be a grouped data frame"))
  }

  original_groups <- dplyr::group_keys(.x)

  # Join normals, isolate values based on threshold and split groups to list
  suppressMessages(
    res <- .x |>
      dplyr::mutate(month = lubridate::month(date)) |>
      dplyr::inner_join(normals_df) |>
      # Isolate values above threshold (heat wave definition) |>
      dplyr::mutate(
        ref = ifelse(test = value >= normal_mean + normal_plus, yes = 1, no = 0)
      ) |>
      dplyr::group_split()
  )

  # Function to identify sequences
  iden <- function(res) {
    positions <- nseq::trle_cond(
      x = res$ref,
      a_op = "gte",
      a = size,
      b_op = "e",
      b = 1,
      pos = TRUE
    )

    positions <- unlist(purrr::map2(
      .x = positions$p1,
      .y = positions$p2,
      .f = seq
    ))

    res$ref <- NULL
    res[[var_name]] <- FALSE
    res[[var_name]][positions] <- TRUE

    return(res)
  }

  # Identify sequences
  res2 <- purrr::map(.x = res, .f = iden) |> purrr::list_rbind()

  # Regroup data
  res3 <- dplyr::group_by(
    res2,
    dplyr::across(dplyr::all_of(dplyr::group_vars(.x)))
  )

  # Return
  return(res3)
}
