test_that("config can be get and set", {
  reset_config()
  f <- function() set_config(run_name = "abc")
  f()
  expect_equal(get_config("run_name"), "abc")
})
