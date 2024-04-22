ids_count <- length(unique(temp_max_data$code_muni))
years_count <- length(unique(lubridate::year(temp_max_data$date)))

test_that("compute_indicator works, 1 year", {
  res <- compute_indicators(.x = temp_max_data, y = 1, keys = "code_muni")

  expect_true(ids_count*12*(years_count/1) == nrow(res))
})

test_that("compute_indicator works, 10 year", {
  res <- compute_indicators(.x = temp_max_data, y = 10, keys = "code_muni")

  expect_true(ids_count*12*(ceiling(years_count/10)) == nrow(res))
})

test_that("compute_indicator works, 30 year", {
  res <- compute_indicators(.x = temp_max_data, y = 30, keys = "code_muni")

  expect_true(ids_count*12*(ceiling(years_count/30)) == nrow(res))
})
