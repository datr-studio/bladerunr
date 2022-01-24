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

check_type <- function(arg, exp_type) {
  arg_name <- rlang::expr_text(rlang::enexpr(arg))
  if (!inherits(arg, exp_type)) {
    show_var_wrong_type_error(arg, arg_name, exp_type)
  }
}


confirm_dir_overwrite <- function(dir) {
  msg <- cli::format_inline("{.path {dir}} already contains files which will be overwritten.")
  if (confirm_action(msg, default_yes = TRUE)) {
    return(TRUE)
  } else {
    stop_quietly()
  }
}

confirm_dir_create <- function(dir) {
  msg <- cli::format_inline("{.path {dir}} doesn't exist and will be created.")
  if (confirm_action(msg, default_yes = TRUE)) {
    return(TRUE)
  } else {
    stop_quietly()
  }
}

confirm_overwrite <- function(path) {
  msg <- cli::format_inline("{.path {path}} already exists and will be overwritten.")
  if (confirm_action(msg, default_yes = FALSE)) {
    return(TRUE)
  } else {
    stop_quietly()
  }
}

confirm_action <- function(msg, default_yes = TRUE) {
  q <- ifelse(default_yes, "[Y/n]", "[y/N]")

  confirmation_prompt <- cli::format_inline(
    "{cli::symbol$pointer}{cli::symbol$pointer}{cli::symbol$pointer} {.strong Do you want to continue {q} ?}"
  )
  cat(
    cli::col_yellow("!"), cli::format_inline(msg), "\n"
  )
  if (interactive()) {
    res <- readline(confirmation_prompt)
  } else {
    cat(confirmation_prompt)
    res <- readLines("stdin", n = 1)
  }
  parse_res(res, default_yes)
}

parse_res <- function(res, default_yes) {
  res <- tolower(res)
  if (nchar(res) == 0) {
    return(default_yes)
  } else if (res == "y") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}