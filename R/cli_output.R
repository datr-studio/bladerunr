# Start Msg ---------------------------------------------------------------
#'

opening_logo <- function() {
  cat("\n")
  d <- cli::cli_div(theme = list(rule = list(
    color = "cyan",
    "line-type" = "double"
  )))
  cli::cli_rule(left = cli::col_white("Bladerunr"))
  cli::cli_alert_info("Setting up tests...")
  cli_end(d)
}

# Prepare Directory ---------------------------------------------------------------
#'

overwrite_prompt <- function(run_name) {
  cli::cli_alert_warning("The {cli::col_br_yellow(run_name)} folder already exists. Continuing will overwrite any files in it.")
}

# Announce Progress ---------------------------------------------------------------
#'

#' @import cli
show_test_update <- function(i, start, av_dur) {
  cli::cli_rule(left = cli::col_yellow("Test {i}"))
  cli::cli_alert_info("Initiated test at {strftime(start, '%H:%M')}")
  duration <- ifelse(!is.nan(av_dur),
    prettyunits::pretty_sec(av_dur, compact = TRUE),
    cli::col_grey("calculating")
  )
  cli::cli_alert_info("Average test duration: {duration}")
}

success_msg <- function(n) {
  cli::cli_alert_success("Test {n} is complete.")
}

# Errors ---------------------------------------------------------------
#'

timeout_msg <- function(n, time_limit) {
  cli::cli_alert_danger("Test run {n} exceeded the time limit of {prettyunits::pretty_sec(time_limit)}.")
}

error_msg <- function(n, msg, call) {
  cli::cli_alert_danger(
    "Test run {n} failed due to an {.emph {msg}} error while attempting '{call}'."
  )
}

skip_msg <- function(n) {
  cli::cli_alert_danger(cli::col_red("Test run {n} has reached the attempt threshold and will be skipped."))
}





# Final Msg ---------------------------------------------------------------
#'

#' @importFrom vroom vroom_write
final_run_msg <- function(total) {
  cat("\n")
  d <- cli::cli_div(theme = list(rule = list(
    color = "cyan",
    "line-type" = "double"
  )))
  cli::cli_rule(left = cli::col_white("Bladerunr Complete"))
  cli_end(d)
  log <- get_log()
  if (nrow(log) > 0) {
    n_failures <- length(unique(get_log()$test_n))
    n_success <- total - n_failures
    if (n_success == 0) {
      show_absolute_failure(n_failures)
    } else {
      show_partial_failure(n_failures, n_success)
    }
    vroom::vroom_write(log, "skipped_tests.csv")
  } else {
    show_complete_success()
  }
}

show_complete_success <- function() {
  cli::cli_alert_success("All tests were completed successfully.")
}


show_absolute_failure <- function(n_failures) {
  cli::cli_alert_danger(cli::col_red("{qty(n_failures)} {?Your/All} test{?s} failed and {?was/were} not run."))
  cli::cli_text(cli::col_grey("See {.emph skipped_tests.csv} for a breakdown of test failures."))
}

show_partial_failure <- function(n_failures, n_success) {
  cli::cli_alert_success("{n_success} test{?s} w{?as/ere} completed successfully.")
  cli::cli_alert_danger(cli::col_red("{n_failures} test{?s} failed and {?was/were} not run."))
  cli::cli_text(cli::col_grey("See {.emph skipped_tests.csv} for a breakdown of test failures."))
}