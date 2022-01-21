test_that("log can set and get", {
  reset_log()
  add_to_log(
    test_n = 1,
    attempt = 1,
    reason = "testing logs"
  )
  expected <- tibble::tibble(
    test_n = 1,
    attempt = 1,
    reason = "testing logs",
    details = NA_character_
  )
  expect_equal(get_log(), expected)
})