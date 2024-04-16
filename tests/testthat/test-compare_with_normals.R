test_that("compare with normals works", {
  normals <- temp_max_data |>
    year_cut(n = 30) |>
    compute_normals(keys = "code_muni")

  res <- temp_max_data |>
    compare_with_normals(y = normals, key = "code_muni")
})
