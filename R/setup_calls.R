#' Specify callback functions to be executed before each model run
#'
#' `setup_calls()` executes setup functions using the test parameters for a given run. This is where you specify how to use your parameters to update your model.
#'
#' @param params A list of params which will include all the parameters of the grid for the given test run.
#'
#' @param callbacks A list of callback functions. Each takes one formal argument: params
#'
setup_calls <- function(params, callbacks) {
  purrr::walk(callbacks, function(f) f(params))
}