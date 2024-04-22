#' Year cut
#'
#' Discretize dates into yearly intervals.
#'
#' The function compute yearly intervals of size `n` and adds to the tibble a date interval variable (`date_interval`) and a interval label variable (`interval_label`) with the staring and ending years of the interval.
#'
#' @param .x a tibble.
#' @param date_var Date variable. If `NULL`, the function will default to 'date'.
#' @param n numeric. Size of the interval, in years. Minimum of 1.
#'
#' @return a tibble with the variables `date_interval` and `interval_label`.
#' @export
#'
#' @examples
#' year_cut(temp_max_data, n = 30)
#'
year_cut <- function(.x, date_var = NULL, n){
  # Assertions
  checkmate::assert_data_frame(x = .x)
  checkmate::assert_integerish(x = n, lower = 1)


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
      year_date_start = lubridate::floor_date(!!dplyr::sym(date_var), lubridate::years(n)),
      year_date_end = lubridate::ceiling_date(!!dplyr::sym(date_var), lubridate::years(n))-1,
      year_interval = paste0(lubridate::year(year_date_start),"--",lubridate::year(year_date_end)+1)
    )
}
