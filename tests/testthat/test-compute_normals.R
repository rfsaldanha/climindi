test_that("compute normals create variables", {
  res <- temp_max_data |>
    year_cut(n = 30) |>
    compute_normals(keys = "code_muni")

  expect_true("avg" %in% names(res))
  expect_true("sd" %in% names(res))
  expect_true("max" %in% names(res))
  expect_true("min" %in% names(res))
})

test_that("compute normals have the right dimension", {
  res <- temp_max_data |>
    year_cut(n = 30) |>
    compute_normals(keys = "code_muni")

  expect_true(length(unique(res$code_muni)) * length(unique(res$interval_label)) == 12)
})
