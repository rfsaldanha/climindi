window_percentile <- function(.x, k = 5, p = 0.9){
  caTools::runquantile(x = .x, k = k, probs = p)
}
