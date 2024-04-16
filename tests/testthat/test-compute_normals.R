test_that("compute normals create variables", {
  res <- temp_max_data |>
    year_cut(n = 30) |>
    compute_normals(keys = c("code_muni", "date_interval"))

  expect_true("avg" %in% names(res))
  expect_true("sd" %in% names(res))
  expect_true("max" %in% names(res))
  expect_true("min" %in% names(res))
})

test_that("compute normals have the right dimension", {
  res <- temp_max_data |>
    year_cut(n = 30) |>
    compute_normals(keys = c("code_muni", "date_interval"))

  expect_true(length(unique(res$code_muni)) * length(unique(res$date_interval)) == 12)
})
