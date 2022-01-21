.config <- new.env(parent = emptyenv())
.config$data <- list(
  run_name = NULL,
  runr = NULL,
  pre_runr = NULL,
  post_runr = NULL,
  output_dir = NULL,
  timeout = NULL,
  max_attempts = 2
)


reset_config <- function() {
  .config$data <- list(
    run_name = NULL,
    runr = NULL,
    pre_runr = NULL,
    post_runr = NULL,
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
#' @param attr Name of attribute to get/set
#' @param value Value for named attribute
#'
#' @return List of config settings.
set_config <- function(...) {
  new <- modifyList(.config$data, list(...))
  .config$data <- new
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