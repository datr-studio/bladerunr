#' Setup bladerunr
#'
#' `blade_setup()` is required to set up the model runs. Its job is to specify the functions you want to repeat for each iteration of your grid search.
#'
#' There are three types of callbacks bladerunr can use at each iteration: pre-runrs, runrs, and post-runrs. This enables the user to break up their functions into smaller chunks. It also expects that the model may involve files being generated, either as inputs, outputs, or both; the callbacks enable the user to deal with these as they wish.
#'
#' @param run_name The name of the run. Used for output folder naming.
#' @param runr A function to be executed as the main test. Function may produce side-effects, or return a value. Any value returned is passed to the post_runr.
#' @param pre_runr A function to execute *before* each model run. This function will each receive a list of all the model params for the given run as input. This function will be executed at every iteration. Optional.
#' @param post_runr A function to execute *after* each model run. If the main runr returned a value, it will be passed on. The function will be executed at every iteration; and, if the user specifies an `output_dir`, this value will be passed to to the function as well. Optional.
#' @param output_dir A path to be given to the `post_runrs`, if required. Optional.
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
#' blade_setup("test-run", foo_before, foo_run, foo_after, "path/to/save/outputs")
blade_setup <- function(run_name, runr, pre_runr = NULL, post_runr = NULL, output_dir = NULL) {
  check_args(
    "`run_name` must be a character vector of length 1.",
    is.character(run_name), length(run_name) == 1
  )
  check_args(
    "A `runr` function is required.",
    !is.null(runr), length(runr) == 1
  )

  if (!is.null(pre_runr)) {
    check_args("`pre_runr` argument must be a function", is_function(pre_runr))
  }

  if (!is.null(post_runr)) {
    check_args("`post_runr` argument must be a function", is_function(post_runr))
  }

  if (!is.null(output_dir)) {
    check_args(
      "`output_dir` must be a character vector of length 1.",
      is.character(run_name), length(run_name) == 1
    )
  }

  options(bladerunr_run_name = run_name)
  options(bladerunr_pre_runr = pre_runr)
  options(bladerunr_runr = runr)
  options(bladerunr_post_runr = post_runr)
  options(bladerunr_output_dir = output_dir)

  cat(crayon::green("Setup successfull.") %+%
    crayon::blurred("\nDefine parameters with " %+%
      crayon::italic("blade_param") %+% " to run."))
}

is_function <- function(f) typeof(f) == "closure"