#' @import cli
announce <- function(n, n_tests, duration, test_start, run_start) {
  perc <- paste0(round(n / n_tests * 100, 1), "%")
  remaining <- n_tests - n
  test_info <- list(
    n = n,
    n_tests = n_tests,
    perc = perc,
    test_start = test_start,
    duration = ifelse(!is.na(duration),
      prettyunits::pretty_sec(duration, compact = TRUE),
      cli::col_grey("calculating")
    )
  )
  announce_test_info(test_info)
  if (!is.na(duration)) {
    now <- Sys.time()
    time_remaining <- remaining * duration
    end <- now + time_remaining
    overall_info <- list(
      rstart = run_start,
      now = now,
      end = end
    )
    announce_overall_info(overall_info)
  }
}



#' @import prettyunits
announce_test_info <- function(test_info) {
  cli::cli_par()
  cat("\n")
  cli::cli_rule(left = cli::col_br_yellow("Test {test_info$n}/{test_info$n_tests} ({test_info$perc})"))
  cli::cli_alert_info("Test initiated on {strftime(test_info$test_start, '%h %d at %H:%M')}")
  cli::cli_alert_info("Average Test Duration: {test_info$duration}")
  cli::cli_end()
}

announce_overall_info <- function(overall_info) {
  cli::cli_par()
  cli::cli_alert_info("Bladerunr start: {prettyunits::time_ago(overall_info$rstart)}")
  cli::cli_alert_info(
    "Time Remaining: {prettyunits::pretty_sec(as.numeric(overall_info$end - overall_info$now, units = 'secs'), compact = TRUE)}"
  )
  cli::cli_text(cli::col_br_yellow("{cli::symbol$pointer} Expected Completion: {strftime(overall_info$end, '%h %d at %H:%M')}"))
  cli::cli_end()
}

output_open <- function() {
  output_break("Run Output")
}

output_close <- function() {
  output_break("End Run Output")
}

output_break <- function(msg) {
  d <- cli::cli_div(theme = list(rule = list(
    color = "silver",
    "line-type" = "-"
  )))
  cli::cli_rule(left = cli::col_grey(msg))
  cli_end(d)
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


# Prompts ---------------------------------------------------------------
#'

overwrite_prompt <- function(run_name) {
  browser()
  cli::cli_alert_warning("The {run_name} folder already exists. Continuing will overwrite any files in it.")
}

# Start Msg ---------------------------------------------------------------
#'

opening_logo <- function() {
  cat("\n")
  d <- cli::cli_div(theme = list(rule = list(
    color = "cyan",
    "line-type" = "double"
  )))
  cli::cli_rule(left = cli::col_white("Bladerunr"))
  cli_end(d)
}

# Final Msg ---------------------------------------------------------------
#'

#' @importFrom vroom vroom_write
final_run_msg <- function(skipped_tests) {
  cat("\n")
  d <- cli::cli_div(theme = list(rule = list(
    color = "cyan",
    "line-type" = "double"
  )))
  cli::cli_rule(left = cli::col_white("Bladerunr Complete"))
  cli_end(d)
  if (nrow(skipped_tests) > 0) {
    cli::cli_alert_warning(cli::col_yellow("Note: {length(skipped_tests$test_n)} test{?s} failed and {?was/were} not run."))
    cli::cli_text(cli::col_grey("See {.emph skipped_tests.csv} for a breakdown of test failures."))
    vroom::vroom_write(skipped_tests, "skipped_tests.csv")
  } else {
    cli::cli_alert_success("All tests were completed successfully.")
  }
}