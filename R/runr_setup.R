#' Setup bladerunr
#'
#' `runr_setup()` is required to set up the model runs. Its job is to specify
#'
#' @param run_name The name of the run. Used for output folder naming.
#' @param runr A function or list of functions to be executed as the main test. Function should produce side-effects as no input or output will be held.
#' @param pre_runrs A function or list of functions to execute *before* each model run. These functions should be caused for side-effects and will each receive a list of all the model params for the given run as input. Each will be executed at every iteration. Optional.
#' @param post_runrs A function or list of functions to execute *after* each model run. These functions should be caused for side-effects and will receive no input. Each will be executed at every iteration. Optional.
#'
#' @importFrom purrr map_lgl
#'
#' @export
#' 
#' @examples
#'
#' foo_before <- function(params) {
#'   # Do some setup work
#' }
#' foo_run <- function() {
#'   # Do some fancy stuff
#' }
#' foo_after <- function() {
#'   # Transform and save model results
#' }
#'
#' runr_setup("test-run", foo_before, foo_run, foo_after)
runr_setup <- function(run_name, runr, pre_runrs = NULL, post_runrs = NULL) {
  check_args(
    "Run name must be a character vector of length 1.",
    is.character(run_name), length(run_name) == 1
  )
  check_args(
    "A runr function is required.",
    !is.null(runr)
  )

  pre_runrs <- standardise_callbacks(pre_runrs, "Pre-runrs")
  runr <- standardise_callbacks(runr, "runr")
  post_runrs <- standardise_callbacks(post_runrs, "Post-runrs")

  options(bladerunr_run_name = run_name)
  options(bladerunr_pre_runrs = pre_runrs)
  options(bladerunr_runr = runr)
  options(bladerunr_post_runrs = post_runrs)
}

is_function <- function(f) typeof(f) == "closure"

list_contains_only_functions <- function(lst) {
  all(purrr::map_lgl(lst, is_function))
}

standardise_callbacks <- function(lst, list_name = "Callback list ") {
  if (typeof(lst) == "closure") {
    lst <- list(lst)
  } else if (!is.null(lst) & !list_contains_only_functions(lst)) {
    stop(list_name, " must be a single function or list of functions.", call. = FALSE)
  }
  lst
}