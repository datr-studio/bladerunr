.log <- new.env(parent = emptyenv())
.log$data <- tibble::tibble(
  test_n = integer(),
  attempt = integer(),
  reason = character(),
  details = character()
)

add_to_log <- function(...) {
  .log$data <- tibble::add_row(
    .log$data,
    ...
  )
}

reset_log <- function() {
  .log$data <- tibble::tibble(
    test_n = integer(),
    attempt = integer(),
    reason = character(),
    details = character()
  )
}

get_log <- function() {
  .log$data
}