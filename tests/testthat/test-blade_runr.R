clean_up <- function() {
  unlink("tests/testthat/testdir", recursive = TRUE)
}

test_that("blade_runr fails politely when it should", {
  expect_error(blade_runr(list("a" = 1), use_sound = FALSE), "`grid` must be a dataframe")
})

test_that("blade_runr fails politely if options aren't set", {
  expect_error(blade_runr(data.frame(a = 1), use_sound = FALSE), "`blade_setup` must be called to setup your runrs!")
})

test_that("blade_runr executes functions", {
  pre_run <- FALSE
  run <- FALSE
  post_run <- FALSE

  pre <- function(x) pre_run <<- TRUE
  run <- function(...) run <<- TRUE
  post <- function(...) post_run <<- TRUE

  blade_setup(run_name = "test", runr = run, pre_runr = pre, post_runr = post)
  blade_runr(data.frame(test = 1), use_sound = FALSE)

  expect_true(pre_run)
  expect_true(run)
  expect_true(post_run)
})

test_that("blade_runr executes functions without a prerunr", {
  run <- FALSE
  post_run <- FALSE

  run <- function(...) run <<- TRUE
  post <- function(...) post_run <<- TRUE

  blade_setup(run_name = "test", runr = run, post_runr = post)
  blade_runr(data.frame(test = 1), use_sound = FALSE)

  expect_true(run)
  expect_true(post_run)
})

test_that("blade_runr executes functions without a pre or postrunr", {
  run <- FALSE
  run <- function(...) run <<- TRUE

  blade_setup(run_name = "test", runr = run)
  blade_runr(data.frame(test = 1), use_sound = FALSE)

  expect_true(run)
})

test_that("blade_runr repeats a function up to the max_attempts value", {
  runs <- 0
  run <- function(...) {
    runs <<- runs + 1
    1 / "a"
  }

  blade_setup(run_name = "test", runr = run, max_attempts = 3)
  blade_runr(data.frame(test = 1), use_sound = FALSE)

  expect_equal(runs, 3)
})

test_that("blade_runr catches long runs and restarts the runr up to 2 times", {
  runs <- 0
  run <- function(...) {
    runs <<- runs + 1
    Sys.sleep(2)
  }

  blade_setup(run_name = "test", runr = run, timeout = 1, max_attempts = 2)
  blade_runr(data.frame(test = 1), use_sound = FALSE)

  expect_equal(runs, 2)
})

test_that("blade_runr gives the runr function the 3 expected vars", {
  check_n <- NULL
  check_test_name <- NULL
  check_output_dir <- NULL

  run <- function(n, test_name, output_dir) {
    check_n <<- n
    check_test_name <<- test_name
    check_output_dir <<- output_dir
  }

  blade_setup(run_name = "test", runr = run, output_dir = "testdir")

  blade_runr(data.frame(test = 1))

  expect_equal(check_n, 1)
  expect_equal(check_test_name, "test")
  expect_equal(check_output_dir, "testdir")
})

clean_up()
