compare_with_normals <- function(.x, y, date_var = NULL, key, remove_normals_variables = TRUE){

  # Date variable
  if(is.null(date_var)){
    date_var <- "date"
  }

  by <- dplyr::join_by(!!dplyr::sym(key), "month", dplyr::between(x$date, y$date_start, y$date_end))

  res <- .x |>
    dplyr::mutate(month = lubridate::month(!!dplyr::sym(date_var))) |>
    dplyr::left_join(y, by) |>
    dplyr::mutate(
      avg_diff = value - avg,

    ) |>
    dplyr::select(-"month")

  if(remove_normals_variables == TRUE){
    res <- res |>
      dplyr::select(-tidyselect::any_of(c("interval_label", "start_date", "end_date","avg", "sd", "se", "max", "min", "n")))
  }

  return(res)
}
