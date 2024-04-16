test_that("year_cut variables", {
  res <- temp_max_data |>
    year_cut(n = 30)

  expect_true("date_start" %in% names(res))
  expect_true("date_end" %in% names(res))
  expect_true("interval_label" %in% names(res))
})

test_that("year_cut intervals are right", {
  res <- temp_max_data |>
    year_cut(n = 30)

  intervals_expected <- ceiling((lubridate::year(max(temp_max_data$date))-lubridate::year(min(temp_max_data$date))+1)/30)

  expect_true(intervals_expected == length(unique(res$interval_label)))
})
