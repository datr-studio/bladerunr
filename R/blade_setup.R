#' Setup bladerunr
#'
#' `blade_setup()` is your first step. It sets up the function you want to
#' repeat for each iteration, as well as various other settings for your run.
#'
#' Detailed explanation of how the runr and setup work can be found at the README.
#
#'
#' @param run_name The name of the run. Used for output folder naming.
#' @param runr A function to be executed as the main test. Must receive two arguments:
#' params and context. See vignette for more details.
#' @param output_dir A path to be given to the runr, if required. Optional.
#' @param timeout An int representing the time in seconds to allow the runr.
#' If the runr exceeds it, the function will either try again or move on depending on the `max_attempts` value. Optional.
#' @param max_attempts An int specifying the number of time to attempt a run
#' before moving on. Optional.
#' @param log_output If `TRUE`, runr output will be saved to a log in either your
#' `output_dir` or working directory if no `output_dir` was specified. Defaults to FALSE.
#'
#' @export
#' @import cli
#' @examples
#'
#' foo_run <- function() {
#'   # Do some fancy stuff
#' }
#'
#' blade_setup("test-run", foo_run, "path/to/save/outputs")
blade_setup <- function(run_name, runr, output_dir = NULL,
                        timeout = NULL, max_attempts = 2, log_output = FALSE) {
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
    max_attempts = max_attempts,
    log_output = log_output
  )

  cli::cli_alert_success("Setup complete.")
}

is_function <- function(f) typeof(f) == "closure"