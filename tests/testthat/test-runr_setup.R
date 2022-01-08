test_that("runr_setup successfully stores options", {
  foo <- function(x) 0
  bar <- function(x) 0

  runr_setup(
    run_name = "test",
    pre_runrs = list(foo),
    runr = bar,
    post_runrs = list(foo, bar)
  )
  expect_equal(options("bladerunr_run_name")[[1]], "test")
  expect_equal(options("bladerunr_pre_runrs")[[1]], list(foo))
  expect_equal(options("bladerunr_runr")[[1]], list(bar))
  expect_equal(options("bladerunr_post_runrs")[[1]], list(foo, bar))
})

test_that("runr accepts only one main function.", {
  foo <- function(x) 0
  bar <- function(x) 0

  expect_error(runr_setup(
    run_name = "test",
    pre_runrs = list(foo),
    runr = list(foo, bar),
    post_runrs = list(foo, foo)
  ), "A single runr function is required.")
})

test_that("runr_setup can have NULL values for pre or post runners but not the runr.", {
  foo <- function(x) 0
  expect_error(runr_setup(
    run_name = "test",
    pre_runrs = list(foo),
    runr = NULL,
    post_runrs = list(foo, foo)
  ), "A single runr function is required.")


  runr_setup(
    run_name = "test",
    pre_runrs = NULL,
    runr = foo,
    post_runrs = NULL
  )
  expect_equal(options("bladerunr_run_name")[[1]], "test")
  expect_equal(options("bladerunr_pre_runrs")[[1]], NULL)
  expect_equal(options("bladerunr_runr")[[1]], list(foo))
  expect_equal(options("bladerunr_post_runrs")[[1]], NULL)
})

test_that("runr_setup fails appropriately", {
  foo <- function(x) 0
  bar <- function(x) 0
  expect_error(runr_setup(
    run_name = 1,
    pre_runrs = list(foo),
    runr = bar,
    post_runrs = list(foo, bar)
  ), "Run name must be a character vector of length 1.")
  expect_error(runr_setup(
    run_name = "test",
    pre_runrs = list(foo, "not a function"),
    runr = bar,
    post_runrs = list(foo, bar)
  ), "Pre-runrs must be a single function or list of functions.")
})

test_that("standardise_callbacks returns a list of functions and only functions", {
  foo <- function(x) 0
  expect_equal(standardise_callbacks(foo), list(foo))
  expect_equal(standardise_callbacks(list(foo)), list(foo))
  expect_true(list_contains_only_functions(standardise_callbacks(foo)))
})

test_that("standardise_callbacks rejects non functions", {
  foo <- function(x) 0
  expect_error(
    standardise_callbacks("not a function", "foo"), "foo must be a single function or list of functions."
  )
  expect_error(
    standardise_callbacks(list(foo, "not a function"), "foo"), "foo must be a single function or list of functions."
  )
})

test_that("pre_calls executes a list of callbacks without error", {
  a <- -1
  b <- -2

  params <- list(
    a = 1,
    b = 2
  )
  callbacks <- list(
    function(params) a <<- params$a,
    function(params) b <<- params$b
  )
  pre_run_calls(params, callbacks)
  expect_equal(a, 1)
  expect_equal(b, 2)
})

test_that("post_run_calls executes a list of callbacks without error", {
  a <- -1
  b <- -2

  callbacks <- list(
    function() a <<- 1,
    function() b <<- 2
  )
  post_run_calls(callbacks)
  expect_equal(a, 1)
  expect_equal(b, 2)
})