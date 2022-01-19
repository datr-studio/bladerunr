test_that("blade_setup successfully stores options", {
  foo <- function(x) 0
  bar <- function(x) 0

  blade_setup(
    run_name = "test",
    pre_runr = foo,
    runr = bar,
    post_runr = bar,
  )
  expect_equal(get_config("run_name"), "test")
  expect_equal(get_config("pre_runr"), foo)
  expect_equal(get_config("runr"), bar)
  expect_equal(get_config("post_runr"), bar)
})


test_that("blade_setup can have NULL values for pre or post runners but not the runr.", {
  foo <- function(x) 0
  expect_error(blade_setup(
    run_name = "test",
    pre_runr = foo,
    runr = NULL,
    post_runr = foo
  ), "A `runr` function is required.")


  blade_setup(
    run_name = "test",
    pre_runr = NULL,
    runr = foo,
    post_runr = NULL
  )
  expect_equal(get_config("run_name"), "test")
  expect_equal(get_config("pre_runr"), NULL)
  expect_equal(get_config("runr"), foo)
  expect_equal(get_config("post_runr"), NULL)
})

test_that("blade_setup fails appropriately", {
  foo <- function(x) 0
  bar <- function(x) 0
  expect_error(blade_setup(
    run_name = 1,
    pre_runr = foo,
    runr = bar,
    post_runr = bar
  ), "`run_name` must be a character vector of length 1.")
  expect_error(blade_setup(
    run_name = "test",
    pre_runr = "not a function",
    runr = bar,
    post_runr = bar
  ), "`pre_runr` argument must be a function")
  expect_error(blade_setup(
    run_name = "test", runr = bar, timeout = bar
  ), "`timeout` must be a single positive number.")
  expect_error(blade_setup(
    run_name = "test", runr = bar, max_attempts = -1
  ), "`max_attempts` must be a single number greater than or equal to 1.")
  expect_error(blade_setup(
    run_name = "test", runr = bar, max_attempts = "a"
  ), "`max_attempts` must be a single number greater than or equal to 1.")
})
