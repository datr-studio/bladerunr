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