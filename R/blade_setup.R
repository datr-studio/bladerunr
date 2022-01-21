#' Setup bladerunr
#'
#' `blade_setup()` must be called to specify the functions
#' you want to repeat for each iteration of your grid search.
#'
#' There are three types of callbacks bladerunr can use at each iteration:
#' pre-runrs, runrs, and post-runrs. This enables the user to break up their
#' functions into smaller chunks. It also anticipates that the model may involve
#' files being generated, either as inputs, outputs, or both; the callbacks
#' enable the user to deal with these as they wish.
#'
#' Detailed explanation of how the runrs and setup works can be found at the README.
#
#'
#' @param run_name The name of the run. Used for output folder naming.
#' @param runr A function to be executed as the main test. Function may produce side-effects, or return a value. Any value returned is passed to the post_runr. The function will also receive the following three arguments for context: test_number, run_name, and output_dir (as specified in the setup).
#' @param pre_runr A function to execute *before* each model run. This function will each receive a list of all the model params for the given run as input. This function will be executed at every iteration. Optional.
#' @param post_runr A function to execute *after* each model run. If the main runr returned a value, it will be passed on. The function will be executed at every iteration; and, if the user specifies an `output_dir`, this value will be passed to to the function as well. Optional.
#' @param output_dir A path to be given to the `post_runrs`, if required. Optional.
#' @param timeout An int representing the time in seconds to allow the runr. If the runr exceeds it, the function will either try again or move on depending on the `max_attempts` value. Optional.
#' @param max_attempts An int specifying the number of time to attempt a run before moving on. Optional.
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
# source("R/user_feedback.R")
# source("R/utils.R")
# source("R/config.R")
blade_setup <- function(run_name, runr, pre_runr = NULL,
                        post_runr = NULL, output_dir = NULL,
                        timeout = NULL, max_attempts = 2) {
  reset_config()

  check_args(
    "`run_name` must be a character vector of length 1.",
    is.character(run_name), length(run_name) == 1
  )
  check_args(
    "A `runr` function is required.",
    !is.null(runr), length(runr) == 1
  )

  check_args(
    "`timeout` must be a single positive number.",
    is.null(timeout) || is.numeric(timeout)
  )
  check_args(
    "`max_attempts` must be a single number greater than or equal to 1.",
    is.null(max_attempts) || is.numeric(max_attempts)
  )

  check_args(
    "`timeout` must be a single positive number.",
    is.null(timeout) || timeout > 0
  )
  check_args(
    "`max_attempts` must be a single number greater than or equal to 1.",
    is.null(max_attempts) || max_attempts > 0
  )


  if (!is.null(pre_runr)) {
    check_args(
      "`pre_runr` argument must be a function",
      is_function(pre_runr)
    )
  }

  if (!is.null(post_runr)) {
    check_args(
      "`post_runr` argument must be a function",
      is_function(post_runr)
    )
  }

  if (!is.null(output_dir)) {
    check_args(
      "`output_dir` must be a character vector of length 1.",
      is.character(run_name), length(run_name) == 1
    )
  }

  set_config("run_name", run_name)
  set_config("pre_runr", pre_runr)
  set_config("runr", runr)
  set_config("post_runr", post_runr)
  set_config("output_dir", output_dir)
  set_config("timeout", timeout)
  set_config("max_attempts", max_attempts)

  cli::cli_alert_success("Setup complete.")
}

is_function <- function(f) typeof(f) == "closure"