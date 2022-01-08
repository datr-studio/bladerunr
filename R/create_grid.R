#' Create a search grid
#'
#' This function provides a wrapper around tidyr::expand_grid and filters it by the given filter conditions (optional).
#'
#' @param params 	A list of name-value pairs. The name will become the column name in the output.
#' @param ... Conditions to be passed on to dplyr::filter, if required.
#'
#' @import dplyr
#'
#' @importFrom tidyr expand_grid
#'
#' @return A tibble with one column for each input in ...., optionally filtered by the conditions
#'
#' @export
#'
#' @examples
#' params <- list(
#'   a = seq(1:3),
#'   b = 2
#' )
#' create_grid(params, a > b)
create_grid <- function(params, ...) {
  if (typeof(params) != "list") {
    stop("Parameters need to be given as lists.")
  }
  if (length(params) == 0) {
    stop("At least one parameter is required.")
  }
  test <- NULL
  grid <- tidyr::expand_grid(!!!params) %>%
    dplyr::mutate(test = dplyr::row_number()) %>%
    dplyr::filter(...) %>%
    dplyr::select(test, dplyr::everything())
}