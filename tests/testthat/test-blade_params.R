test_that("blade_params returns a tibble filtered by a condition", {
  params <- list(
    a = seq(1:3),
    b = 2
  )
  expect_equal(blade_params(params, a > b), dplyr::tibble(test = 1, a = 3, b = 2))
})

test_that("blade_params fails when it should", {
  expect_error(blade_params(list()), "At least one parameter is required.")
  expect_error(blade_params(c("a")), "Parameters need to be given as lists.")
  expect_error(blade_params(1:9), "Parameters need to be given as lists.")
})