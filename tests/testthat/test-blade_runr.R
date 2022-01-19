

test_that("blade_runr fails politely when it should", {
  expect_error(blade_runr(list("a" = 1)), "`grid` must be a dataframe")
})

test_that("blade_runr fails politely if options aren't set", {
  expect_error(blade_runr(data.frame(a = 1)), "`blade_setup` must be called first to setup your runrs")
})

test_that("blade_runr executes functions", {
  pre_run <- "not_run"
  run <- "not_run"
  post_run <- "not_run"

  pre <- function(...) pre_run <<- "pre run executed"
  run <- function(...) run <<- "run executed"
  post <- function(...) post_run <<- "post run executed"

  blade_setup(run_name = "test", runr = run, pre_runr = pre, post_runr = post)
  blade_runr(data.frame(test = 1))

  expect_equal(pre_run, "pre run executed")
  expect_equal(run, "run executed")
  expect_equal(post_run, "post run executed")
})

test_that("blade_runr executes functions without a prerunr", {
  run <- FALSE
  post_run <- FALSE

  run <- function(...) run <<- TRUE
  post <- function(...) post_run <<- TRUE

  blade_setup(run_name = "test", runr = run, post_runr = post)
  blade_runr(data.frame(test = 1))

  expect_true(run)
  expect_true(post_run)
})

test_that("blade_runr executes functions without a pre or postrunr", {
  run <- FALSE
  run <- function(...) run <<- TRUE

  blade_setup(run_name = "test", runr = run)
  blade_runr(data.frame(test = 1))

  expect_true(run)
})

test_that("blade_runr repeats a function up to the max_attempts value", {
  runs <- 0
  run <- function(...) {
    runs <<- runs + 1
    1 / "a"
  }

  blade_setup(run_name = "test", runr = run, max_attempts = 3)
  blade_runr(data.frame(test = 1))

  expect_equal(runs, 3)
})

test_that("blade_runr catches long runs and restarts the runr up to 2 times", {
  runs <- 0
  run <- function(...) {
    runs <<- runs + 1
    Sys.sleep(0.2)
  }

  blade_setup(run_name = "test", runr = run, timeout = 0.1, max_attempts = 2)
  blade_runr(data.frame(test = 1))

  expect_equal(runs, 2)
})

test_that("blade_runr gives the runr function the correct context", {
  check_n <- NULL
  check_test_name <- NULL
  check_output_dir <- NULL

  run <- function(params, context) {
    check_n <<- context$test_n
    check_test_name <<- context$run_name
    check_output_dir <<- context$output_dir
  }

  blade_setup(run_name = "test", runr = run, output_dir = "testdir")

  blade_runr(data.frame(test = 1))

  expect_equal(check_n, 1)
  expect_equal(check_test_name, "test")
  expect_equal(check_output_dir, "testdir")
  unlink("testdir", recursive = TRUE)
  expect_true(!dir.exists("testdir"))
})

test_that("post_runr receives results from runr", {
  test_var <- NULL
  foo <- function(...) "res"
  bar <- function(res, context) test_var <<- res
  blade_setup(run_name = "test", runr = foo, post_runr = bar)
  blade_runr(data.frame(test = 1))
  expect_equal(test_var, "res")
})
