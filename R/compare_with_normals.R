compare_with_normals <- function(.x, y, date_var = NULL, key){

  by <- dplyr::join_by(!!dplyr::sym(key), dplyr::between(x$date, y$date_start, y$date_end))

  dplyr::left_join(.x, y, by) |>
    dplyr::mutate(avg_diff = value - avg)
}
