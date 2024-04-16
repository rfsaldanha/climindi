#' Year cut
#'
#' Discretize dates into yearly intervals
#'
#' @param .x a tibble.
#' @param date_var Date variable. If `NULL`, the function will default to 'date'.
#' @param n numeric. Size of the interval, in years. Minimum of 1.
#'
#' @return a tibble with the variable `year_ref`.
#' @export
#'
year_cut <- function(.x, date_var = NULL, n){
  # Assertions
  checkmate::assert_tibble(x = .x)
  checkmate::assert_numeric(x = n, lower = 1)

  # Date variable
  if(is.null(date_var)){
    date_var <- "date"
  }

  # Assert date variable
  checkmate::assert_choice(x = date_var, choices = names(.x))
  checkmate::assert_date(x = get(date_var, .x))

  # Compute interval
  .x |>
    dplyr::mutate(
      year_ref = paste0(
        lubridate::year(lubridate::floor_date(!!dplyr::sym(date_var), lubridate::years(n))),
        "--",
        lubridate::year(lubridate::ceiling_date(!!dplyr::sym(date_var), lubridate::years(n)))
      )
    )
}
