#' Add waves
#'
#' Detect sequence of events (waves) in a ordered vector considering its normal values.
#'
#' This is a helper function to detect sequence of events in a ordered vector considering historical normal values.
#'
#' An event is considered as a sequence of values of a certain size (`size` argument) that are greather and less than (`threshold_cond` argument) an historical normal (`normal` argument) plus an threshold (`threshold` value).
#'
#' The function will fill the variable `var_name` with `TRUE` if the record belongs to an event.
#'
#' @param .x A data.frame object.
#' @param normals_df A data.frame object with normal values, computed with `summarise_normal()`.
#' @param threshold numeric. A positive of negative threshold value to be added to the normal mean value. Use value zero to consider only the normal value.
#' @param threshold_cond string. A threshold condition. Use `gte` for "greather than or equal" or `lte` for less than or equal.
#' @param size numeric. Minimum size of the sequence.
#' @param var_name string. Variable name with the outputs result.
#'
#' @returns A data.frame with the `var_name` variable with logical values.
#'
#' @export
# @importFrom rlang .data
add_wave <- function(
  .x,
  normals_df,
  threshold = 5,
  threshold_cond = "gte",
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

  suppressMessages({
    # Join normals
    tmp1 <- .x |>
      dplyr::mutate(month = lubridate::month(date)) |>
      dplyr::inner_join(normals_df)

    # Isolate values based on threshold
    if (threshold_cond == "gte") {
      tmp2 <- tmp1 |>
        dplyr::mutate(
          ref = ifelse(
            test = .data$value >= .data$normal_mean + threshold,
            yes = 1,
            no = 0
          )
        )
    } else if (threshold_cond == "lte") {
      tmp2 <- tmp1 |>
        dplyr::mutate(
          ref = ifelse(
            test = .data$value <= .data$normal_mean + threshold,
            yes = 1,
            no = 0
          )
        )
    }

    # Split groups to list
    res <- tmp2 |>
      dplyr::group_split()

    rm(tmp1, tmp2)
  })

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

  # Regroup data and remove normal variables
  res3 <- dplyr::group_by(
    res2,
    dplyr::across(dplyr::all_of(dplyr::group_vars(.x)))
  ) |>
    dplyr::select(-.data$normal_mean, -.data$normal_p10, -.data$normal_p90)

  # Return
  return(res3)
}
