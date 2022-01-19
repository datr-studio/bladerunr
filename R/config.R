.config <- new.env(parent = emptyenv())
.config$run_name <- NULL
.config$runr <- NULL
.config$pre_runr <- NULL
.config$post_runr <- NULL
.config$output_dir <- NULL
.config$timeout <- NULL
.config$max_attempts <- 2

reset_config <- function() {
  .config$run_name <- NULL
  .config$runr <- NULL
  .config$pre_runr <- NULL
  .config$post_runr <- NULL
  .config$output_dir <- NULL
  .config$timeout <- NULL
  .config$max_attempts <- 2
}


#' Get and Set Config
#'
#' These two functions manage the internal configuration for bladerunr.
#' They are not exposed to the user.
#'
#' @name getset
#'
#' @param attr Name of attribute to get/set
#' @param value Value for named attribute
#'
#' @return List of config settings.
set_config <- function(attr, value) {
  if (!is.null(value)) {
    setter_func <- eval(rlang::sym(paste0("set_", attr)))
    setter_func(value)
  }
}

set_run_name <- function(run_name) {
  .config$run_name <- run_name
}

set_runr <- function(runr) {
  .config$runr <- runr
}

set_pre_runr <- function(pre_runr) {
  .config$pre_runr <- pre_runr
}

set_post_runr <- function(post_runr) {
  .config$post_runr <- post_runr
}

set_output_dir <- function(output_dir) {
  .config$output_dir <- output_dir
}

set_timeout <- function(timeout) {
  .config$timeout <- timeout
}

set_max_attempts <- function(max_attempts) {
  .config$max_attempts <- max_attempts
}



#' @rdname getset
get_config <<- function(attr) {
  getter_func <- eval(rlang::sym(paste0("get_", attr)))
  getter_func()
}

get_run_name <- function() {
  .config$run_name
}

get_runr <- function() {
  .config$runr
}

get_pre_runr <- function() {
  .config$pre_runr
}

get_post_runr <- function() {
  .config$post_runr
}

get_output_dir <- function() {
  .config$output_dir
}

get_timeout <- function() {
  .config$timeout
}

get_max_attempts <- function() {
  .config$max_attempts
}
