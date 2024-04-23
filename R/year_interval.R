#' Get yearly intervals
#'
#' Discretize dates into yearly intervals.
#'
#' The function compute yearly intervals of size `n` and adds to the tibble a date interval variable (`date_interval`) and a interval label variable (`interval_label`) with the staring and ending years of the interval.
#'
#' @param x a date object
#' @param n numeric. Size of the interval in years. Minimum of 1.
#'
#' @return The starting and ending year of the interval open to the right, separated by `--`.
#' @export
#'
#' @examples
#' year_interval(temp_max_data$date, n = 30)
#'
year_interval <- function(x, n){
  # Assertions
  checkmate::assert_integerish(x = n, lower = 1)
  # checkmate::assert_date(x = x)

  # Compute year interval
  year_date_start = lubridate::floor_date(x, lubridate::years(n))
  year_date_end = lubridate::ceiling_date(x, lubridate::years(n))-1

  interval = paste0(lubridate::year(year_date_start),"--",lubridate::year(year_date_end)+1)

  return(interval)
}
