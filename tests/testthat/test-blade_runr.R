

test_that("blade_runr fails politely when it should", {
  expect_error(blade_runr(list("a" = 1)), "blade_runr requires a dataframe grid to run.")
})

test_that("blade_runr fails politely if options aren't set", {
  expect_error(blade_runr(data.frame(a = 1)), "`blade_setup` must be called first to setup your runrs")
})

test_that("blade_runr executes functions", {
  run <- "not_run"
  run <- function(...) run <<- "run executed"

  blade_setup(run_name = "test", runr = run)
  blade_runr(data.frame(test = 1))

  expect_equal(run, "run executed")
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
  on.exit(unlink("skipped_tests.csv"))
  runs <- 0
  run <- function(...) {
    runs <<- runs + 1
    Sys.sleep(0.2)
  }

  blade_setup(run_name = "test", runr = run, timeout = 0.1, max_attempts = 2)
  blade_runr(data.frame(test = 1))

  expect_equal(runs, 2)
})