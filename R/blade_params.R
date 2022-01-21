#' Create a search grid
#'
#' `blade_params()` takes a list of name-value pairs and sets up a grid comprising all possible combinations of these values. It also provides the optional ability to filter out certain combinations through specifying conditions.
#'
#' This function provides a wrapper around tidyr::expand_grid and then (optionally) filters it by passing on the given conditions to dplyr::filter().
#'
#' @param params 	A list of name-value pairs. The name will become the column name in the output.
#' @param ... Conditions to filter the grid. Optional.
#'
#' @import dplyr
#' @import cli
#'
#' @importFrom tidyr expand_grid
#'
#' @return A tibble with one column for each input in ...., optionally filtered by the conditions, and beginning with a column identifying each test case.
#'
#' @export
#'
#' @examples
#' params <- list(
#'   a = seq(1:3),
#'   b = 2
#' )
#' blade_params(params, a > b)
blade_params <- function(params, ...) {
  if (typeof(params) != "list") {
    cli::cli_abort("Parameters need to be given as lists.")
  }
  if (length(params) == 0) {
    cli::cli_abort("At least one parameter is required.")
  }
  test <- NULL
  .grid <- tidyr::expand_grid(!!!params) %>%
    dplyr::mutate(test = dplyr::row_number()) %>%
    dplyr::filter(...) %>%
    dplyr::select(test, dplyr::everything())

  n <- nrow(.grid)
  if (n == 0) {
    cli::cli_alert_warning("This combination of parameters and conditions leads to {cli::col_yellow('zero')} test cases.")
  } else {
    cli::cli_alert_success("Grid generated with {cli::col_green(nrow(.grid))} {cli::qty(nrow(.grid))}row{?s}.")
  }
  .grid
}



#' FUNCTION_TITLE
#'
#' FUNCTION_DESCRIPTION
#'
#' @param grid DESCRIPTION.
#' @param from DESCRIPTION.
#' @param to DESCRIPTION.
#'
#' @export
#'
#' @return RETURN_DESCRIPTION
#' @examples
#' # ADD_EXAMPLES_HERE
blade_partition <- function(grid, from, to = NA) {
  test <- NULL
  check_args("`grid` must be a data.frame with a column named test.", is.data.frame(grid))
  to <- ifelse(is.na(to), nrow(grid), to)
  grid %>%
    dplyr::filter(dplyr::between(test, from, to))
}