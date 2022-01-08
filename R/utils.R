#' @importFrom magrittr %>%
#'
#'

# Custom Argument Checker and Error Msg
check_args <- function(msg, ...) {
  invisible(if (!all(...)) {
    stop(msg, call. = FALSE)
  })
}

# Get name of variable
var_name <- function(var) deparse(substitute(var))

# Defaults for NULL values
`%||%` <- function(a, b) if (is.null(a)) b else a

# Remove NULLs from a list
compact <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}

# Time function for speed test
get_exec_time <- function(f, ...) {
  st <- Sys.time()
  f(...)
  end <- Sys.time()
  as.numeric(end - st, unit = "secs")
}

#' @importFrom purrr walk
speed_test <- function(f, ...) {
  times <- rep(-1, 1e2)
  purrr::walk(seq_len(length(times)), function(n) {
    times[n] <<- get_exec_time(f, ...)
  })
  message("Average time: ", round(mean(times), 2), " seconds")
}