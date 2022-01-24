run_test <- function(params, context) {
  if (!is.null(get_config("timeout"))) {
    setTimeLimit(elapsed = get_config("timeout"), transient = TRUE)
    on.exit(setTimeLimit(elapsed = Inf, transient = FALSE))
    execute_runr(params, context)
  } else {
    execute_runr(params, context)
  }
}
#' @importFrom utils capture.output
execute_runr <- function(params, context) {
  tryCatch(
    {
      runr <- get_config("runr")
      if (get_config("log_output")) {
        log_path <- ifelse(!is.null(get_config("output_dir")),
          file.path(get_config("output_dir"), "runr_output.log"),
          "runr_output.log"
        )
        sink(file = log_path, append = TRUE, type = "output")
        runr(params, context)
      } else {
        capture.output(runr(params, context), type = "output")
      }

      return(TRUE)
    },
    error = function(e) {
      if (grepl("reached elapsed time limit|reached CPU time limit", e$message)) {
        # we reached timeout, apply some alternative method or do something else
        time_limit <- get_config("timeout")
        timeout_msg(context$test, time_limit)
        add_to_log(
          test = context$test,
          attempt = context$attempt + 1,
          reason = "Timeout",
          details = paste0("Test exceeded the time limit of ", prettyunits::pretty_sec(time_limit))
        )
        return(FALSE)
      } else {
        # error not related to timeout
        msg <- conditionMessage(e)
        error_msg(context$test, msg)
        add_to_log(
          test = context$test,
          attempt = context$attempt + 1,
          reason = "Runr failure",
          details = msg
        )
        return(FALSE)
      }
    },
    finally = {
      if (sink.number() > 0) {
        sink(NULL)
      }
    }
  )
}