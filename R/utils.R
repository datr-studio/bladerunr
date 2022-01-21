#' @importFrom magrittr %>%

# Custom Argument Checker and Error Msg
#' @import cli
check_args <- function(msg, ...) {
  invisible(if (!all(...)) {
    cli::cli_abort(msg)
  })
}

input <- function(prompt) {
  if (interactive()) {
    return(readline(cli::col_yellow(prompt)))
  } else {
    cli::cli_text(cli::col_yellow(prompt))
    return(readLines("stdin", n = 1))
  }
}

#' @importFrom rlang local_options
stop_quietly <- function() {
  rlang::local_options(options(show.error.messages = FALSE))
  stop()
}

`%||%` <- function(a, b) ifelse(!is.null(a), a, b)

`%NA%` <- function(a, b) ifelse(!is.na(a), a, b)