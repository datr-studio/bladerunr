test_that("create_grid returns a tibble filtered by a condition", {
  params <- list(
    a = seq(1:3),
    b = 2
  )
  expect_equal(create_grid(params, a > b), dplyr::tibble(test = 3, a = 3, b = 2))
})

test_that("create_grid fails when it should", {
  expect_error(create_grid(list()), "At least one parameter is required.")
  expect_error(create_grid(c("a")), "Parameters need to be given as lists.")
  expect_error(create_grid(1:9), "Parameters need to be given as lists.")
})