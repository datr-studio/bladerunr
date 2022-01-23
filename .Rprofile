options(repos = "https://cran.stat.auckland.ac.nz/")

if (interactive()) {
  suppressMessages(require(devtools))
}

.pkg_name <- "bladerunr"
reinstall <- function() {
  if (.pkg_name %in% installed.packages()) {
    remove.packages(.pkg_name, lib = "/Users/josh/.rlibs/common/4.1")
  }
  devtools::load_all()
  devtools::document()
  devtools::install()
}