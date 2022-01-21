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
#' @param output_dir A path to be given to the `post_runrs`, if required. Optional.
#' @param timeout An int representing the time in seconds to allow the runr. If the runr exceeds it, the function will either try again or move on depending on the `max_attempts` value. Optional.
#' @param max_attempts An int specifying the number of time to attempt a run before moving on. Optional.
#'
#' @export
#'
#' @examples
#'
#' foo_run <- function() {
#'   # Do some fancy stuff
#' }
#'
#' blade_setup("test-run",  foo_run, "path/to/save/outputs")
# source("R/user_feedback.R")
# source("R/utils.R")
# source("R/config.R")
blade_setup <- function(run_name, runr, output_dir = NULL,
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

  if (!is.null(output_dir)) {
    check_args(
      "`output_dir` must be a character vector of length 1.",
      is.character(run_name), length(run_name) == 1
    )
  }

  set_config(
    run_name = run_name,
    runr = runr,
    output_dir = output_dir,
    timeout = timeout,
    max_attempts = max_attempts
  )

  cli::cli_alert_success("Setup complete.")
}

is_function <- function(f) typeof(f) == "closure"