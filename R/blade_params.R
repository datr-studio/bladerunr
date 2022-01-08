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
#' @import crayon
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
    stop("Parameters need to be given as lists.")
  }
  if (length(params) == 0) {
    stop("At least one parameter is required.")
  }
  test <- NULL
  .grid <- tidyr::expand_grid(!!!params) %>%
    dplyr::mutate(test = dplyr::row_number()) %>%
    dplyr::filter(...) %>%
    dplyr::select(test, dplyr::everything())

  n <- nrow(.grid)
  if (n == 0) {
    warning("This combination of parameters and conditions leads to zero test cases.", call. = FALSE)
  } else if (n == 1) {
    cat(green("Grid generated with " %+% blue$bold("1") %+% " row.\n"))
  } else {
    cat(green("Grid generated with " %+% blue$bold(nrow(.grid)) %+% " rows.\n"))
  }
  .grid
}