#' @importFrom magrittr %>%
#' @import glue

# Custom Argument Checker and Error Msg
check_args <- function(msg, ...) {
  invisible(if (!all(...)) {
    stop(msg, call. = FALSE)
  })
}

null_or_condition <- function(val, cond) is.null(val) || cond


input <- function(prompt) {
  if (interactive()) {
    return(readline(prompt))
  } else {
    cat("\r" %+% prompt)
    return(readLines("stdin", n = 1))
  }
}

str_with_places <- function(n, total, decimal_points = 0) {
  max_places <- log10(total) + 1 + decimal_points
  if (decimal_points > 0 && !stringr::str_detect(crayon::chr(n, "\\."))) {
    n <- paste0(chr(n), ".0")
  } else if (n == total) {
    max_places <- max_places
  }
  stringr::str_pad(n, max_places)
}