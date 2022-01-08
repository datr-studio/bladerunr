pre_run_calls <- function(params, callbacks) {
  invisible(purrr::walk(callbacks, function(f) f(params)))
}

run_call <- function(callback) callback()

post_run_calls <- function(callbacks) {
  invisible(purrr::walk(callbacks, function(f) f()))
}