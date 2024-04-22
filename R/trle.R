#' Run Length Encoding and return result as a tibble
#'
#' Given a tibble object and a variable \code{y}, this function will count the number of occurrence of each element in \code{y} in the sequence that they appear, and return this count as a tibble object.
#'
#' @param .data a \code{tibble} object.
#' @param y character. A variable available on \code{.data}
#'
#' @return a \code{tibble} object.
#'
#' @seealso [rle()]
#'
#' @export
#'
#' @examples
#' example_1 <- tibble::tibble(
#' cod = rep(1, 10),
#' time = 1:10,
#' value = c(8,15,20,0,0,0,0,5,9,12)
#' )
#'
#' trle(.x = example_1, y = "value")
trle <- function(.x, y){
  # Check assertions
  checkmate::assert_data_frame(x = .x)
  checkmate::assert_choice(x = y, choices = names(.x))

  # Run length encoding
  res <- rle(get(y, .x))

  # Tibble result
  tibble::tibble(
    lengths = res$lengths,
    values = res$values
  )
}
