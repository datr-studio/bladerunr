test_that("setup_calls executes a list of callbacks without error", {
  a <- -1
  b <- -2

  params <- list(
    a = 1,
    b = 2
  )
  callbacks <- list(
    f1 = function(params) a <<- params$a,
    f1 = function(params) b <<- params$b
  )
  setup_calls(params, callbacks)
  expect_equal(a, 1)
  expect_equal(b, 2)
})