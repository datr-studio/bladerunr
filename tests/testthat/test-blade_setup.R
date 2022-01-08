test_that("blade_setup successfully stores options", {
  foo <- function(x) 0
  bar <- function(x) 0

  blade_setup(
    run_name = "test",
    pre_runr = foo,
    runr = bar,
    post_runr = bar
  )
  expect_equal(options("bladerunr_run_name")[[1]], "test")
  expect_equal(options("bladerunr_pre_runr")[[1]], foo)
  expect_equal(options("bladerunr_runr")[[1]], bar)
  expect_equal(options("bladerunr_post_runr")[[1]], bar)
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
  expect_equal(options("bladerunr_run_name")[[1]], "test")
  expect_equal(options("bladerunr_pre_runr")[[1]], NULL)
  expect_equal(options("bladerunr_runr")[[1]], foo)
  expect_equal(options("bladerunr_post_runr")[[1]], NULL)
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
})