test_that("blade_setup successfully stores options", {
  foo <- function(x) 0

  blade_setup(
    run_name = "test",
    runr = foo,
  )
  expect_equal(get_config("runr"), foo)
})


test_that("blade_setup cannot have NULL values for the runr.", {
  foo <- function(x) 0
  expect_error(blade_setup(
    run_name = "test",
    runr = NULL,
  ), "A `runr` function is required.")
})

test_that("blade_setup fails appropriately", {
  foo <- function(x) 0
  expect_error(blade_setup(
    run_name = 1,
    runr = foo,
  ), "`run_name` must be a character vector of length 1.")
  expect_error(blade_setup(
    run_name = "test", runr = foo, timeout = foo
  ), "`timeout` must be a single positive number.")
  expect_error(blade_setup(
    run_name = "test", runr = foo, max_attempts = -1
  ), "`max_attempts` must be a single number greater than or equal to 1.")
  expect_error(blade_setup(
    run_name = "test", runr = foo, max_attempts = "a"
  ), "`max_attempts` must be a single number greater than or equal to 1.")
})

