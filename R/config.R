.config <- new.env(parent = emptyenv())
.config$data <- list(
  run_name = NULL,
  runr = NULL,
  output_dir = NULL,
  timeout = NULL,
  max_attempts = 2
)


reset_config <- function() {
  .config$data <- list(
    run_name = NULL,
    runr = NULL,
    output_dir = NULL,
    timeout = NULL,
    max_attempts = 2
  )
}



#' Get Config
#'
#' `get_config` manages the internal configuration for bladerunr.
#'
#'
#' @param ... name = value pairs
#'
#' @importFrom utils modifyList
#'
#' @return List of config settings.
set_config <- function(...) {
  .config$data <- modifyList(.config$data, list(...))
}



#' Set Config
#'
#' `Set_config` manages the internal configuration for bladerunr.
#'
#'
#'
#' @param attr Name of attribute to get/set
get_config <- function(attr) {
  .config$data[[attr]]
}

get_context <- function() {
  .config$data[names(.config$data) %in% c("run_name", "output_dir")]
}