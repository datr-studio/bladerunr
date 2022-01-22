# Start Msg ---------------------------------------------------------------
#'

opening_logo <- function() {
  cat("\n")
  d <- cli::cli_div(theme = list(rule = list(
    color = "cyan",
    "line-type" = "double"
  )))
  cli::cli_rule(left = cli::col_white("Bladerunr"))
  cat("\n")
  cli::cli_alert_info("Setting up tests...")
  cli_end(d)
}

# Prepare Directory ---------------------------------------------------------------
#'

overwrite_prompt <- function(path) {
  cli::cli_alert_warning(
    "The {.path {path}} folder already exists. Continuing will overwrite any files in it."
  )
}

# Announce Progress ---------------------------------------------------------------
#'

#' @import cli
show_test_update <- function(i, start) {
  cli::cli_rule(left = cli::col_yellow("Test {i}"))
  cli::cli_alert_info("Initiated current test at {strftime(Sys.time(), '%H:%M:%S')}")
  cli::cli_alert_info("Overall run began {prettyunits::time_ago(start)}")
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
    "Test run {n} failed: {.emph {msg}}."
  )
}

skip_msg <- function(n) {
  cli::cli_alert_danger(cli::col_red("Test run {n} has reached the attempt threshold and will be skipped."))
}





# Final Msg ---------------------------------------------------------------
#'

#' @importFrom vroom vroom_write
final_run_msg <- function(total, start) {
  elapsed <- as.numeric(Sys.time() - start, units = "secs")
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
      show_absolute_failure(n_failures, elapsed)
    } else {
      show_partial_failure(n_failures, n_success, elapsed)
    }
    vroom::vroom_write(log, "skipped_tests.csv")
  } else {
    show_complete_success(elapsed)
  }
}

show_complete_success <- function(elapsed) {
  cli::cli_alert_success(
    "All tests were completed successfully. [{prettyunits::pretty_sec(elapsed)}]"
  )
}


show_absolute_failure <- function(n_failures, elapsed) {
  cli::cli_alert_danger(cli::col_red("{qty(n_failures)} {?Your/All} test{?s} failed and {?was/were} not run. [{prettyunits::pretty_sec(elapsed)}]"))
  cli::cli_text(cli::col_grey("See {.emph skipped_tests.csv} for a breakdown of test failures."))
}

show_partial_failure <- function(n_failures, n_success, elapsed) {
  cli::cli_alert_success("{n_success} test{?s} w{?as/ere} completed successfully. [{prettyunits::pretty_sec(elapsed)}]")
  cli::cli_alert_danger(cli::col_red("{n_failures} test{?s} failed and {?was/were} not run."))
  cli::cli_text(cli::col_grey("See {.emph skipped_tests.csv} for a breakdown of test failures."))
}